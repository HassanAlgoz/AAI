#!/usr/bin/env python3
"""Execute notebooks in parallel and report failures.

The runner uses the current Python interpreter as the notebook kernel. Run it
from the repository root with
`uv run python .agents/skills/verify-nbs/scripts/run_notebooks.py courses`
so notebooks execute inside this repository's `.venv`.

Paths (`root`, `--ignore-file`) are resolved relative to the current working
directory, so the script is independent of where it lives in the tree.

Concurrency model
-----------------
Each notebook is executed in its own short-lived worker *process* via a
``spawn``-based :class:`~concurrent.futures.ProcessPoolExecutor`:

- **Maximizes CPU utilization**: up to ``--jobs`` notebooks run at once
  (default: ``os.cpu_count()``), so all cores stay busy.
- **Deterministic**: the worker count is derived from the machine's CPU count,
  pass/fail is independent per notebook (fresh kernel + own working directory),
  and the final summary is always printed in sorted path order regardless of
  completion order. When running more than one job, each kernel is pinned to a
  single math-library thread so total parallelism equals ``--jobs`` instead of
  ``jobs x cores`` of oversubscribed, timing-dependent threads.
- **Cross-platform**: the ``spawn`` start method behaves identically on Linux,
  macOS, and Windows and avoids ``fork``-with-threads/asyncio deadlocks.
- **No concurrency issues**: workers share no mutable state; each kernel is a
  separate process with its own auto-assigned ports and connection file.
- **No memory/process leaks**: ``max_tasks_per_child=1`` replaces every worker
  after a single notebook (so nothing accumulates in a long-lived driver), and
  each kernel subprocess is explicitly shut down (``owns_km=True`` plus a
  defensive teardown) so no orphaned kernels or zmq channels are left behind.
"""

from __future__ import annotations

import argparse
import fnmatch
import os
import sys
import time
from concurrent.futures import ProcessPoolExecutor, as_completed
from dataclasses import dataclass
from multiprocessing import get_context
from pathlib import Path

import nbformat
from jupyter_client.kernelspec import KernelSpec
from jupyter_client.manager import KernelManager
from nbclient import NotebookClient
from nbclient.exceptions import CellExecutionError


WORKING_DIR = Path.cwd()
DEFAULT_IGNORE_PATTERNS = ("exset*", "exercise*")
EXCLUDED_DIR_NAMES = {".git", ".ipynb_checkpoints", ".quarto", "_site", "node_modules"}

# Pin math libraries to a single thread inside each kernel. When several
# notebooks run concurrently this keeps total CPU pressure equal to the number
# of worker processes instead of (jobs x cores), which both avoids
# oversubscription thrashing and makes utilization deterministic.
SINGLE_THREAD_ENV = {
    "OMP_NUM_THREADS": "1",
    "OPENBLAS_NUM_THREADS": "1",
    "MKL_NUM_THREADS": "1",
    "NUMEXPR_NUM_THREADS": "1",
    "VECLIB_MAXIMUM_THREADS": "1",
    "BLIS_NUM_THREADS": "1",
}


class CurrentInterpreterKernelManager(KernelManager):
    """Launch kernels with the interpreter running this script.

    ``extra_env`` is merged into the launched kernel's environment (see
    ``jupyter_client`` provisioner env substitution), letting us cap math-library
    threads per kernel without touching the driver's environment.
    """

    extra_env: dict[str, str] = {}

    @property
    def kernel_spec(self) -> KernelSpec:
        return KernelSpec(
            argv=[
                sys.executable,
                "-m",
                "ipykernel_launcher",
                "-f",
                "{connection_file}",
            ],
            display_name=f"Python ({sys.executable})",
            language="python",
            env=dict(self.extra_env),
        )


@dataclass(frozen=True)
class NotebookRun:
    path: Path
    elapsed_seconds: float
    error: str | None = None

    @property
    def passed(self) -> bool:
        return self.error is None


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Execute .ipynb files with a fresh kernel per notebook.",
    )
    parser.add_argument(
        "root",
        nargs="?",
        default="courses",
        help="Folder to scan for notebooks. Defaults to courses/.",
    )
    parser.add_argument(
        "--ignore-file",
        default=".nbignore",
        help="Ignore file with glob patterns. Defaults to .nbignore.",
    )
    parser.add_argument(
        "--timeout",
        type=int,
        default=120,
        help="Per-cell timeout in seconds. Defaults to 120.",
    )
    parser.add_argument(
        "-j",
        "--jobs",
        type=int,
        default=None,
        help="Number of notebooks to run in parallel. Defaults to the CPU count.",
    )
    parser.add_argument(
        "--list-only",
        action="store_true",
        help="Only print the notebooks that would run.",
    )
    return parser.parse_args()


def resolve_jobs(requested: int | None, notebook_count: int) -> int:
    if requested is not None:
        if requested < 1:
            raise ValueError("--jobs must be a positive integer")
        wanted = requested
    else:
        wanted = os.cpu_count() or 1
    return max(1, min(wanted, max(notebook_count, 1)))


def rel(path: Path) -> str:
    try:
        return path.resolve().relative_to(WORKING_DIR).as_posix()
    except ValueError:
        return path.as_posix()


def load_ignore_patterns(ignore_file: Path) -> list[str]:
    patterns: list[str] = []
    seen: set[str] = set()

    def add_pattern(pattern: str) -> None:
        if pattern in seen:
            return
        seen.add(pattern)
        patterns.append(pattern)

    for pattern in DEFAULT_IGNORE_PATTERNS:
        add_pattern(pattern)

    if not ignore_file.exists():
        return patterns

    for line in ignore_file.read_text(encoding="utf-8").splitlines():
        stripped = line.strip()
        if not stripped or stripped.startswith("#"):
            continue
        add_pattern(stripped)
    return patterns


def matches_ignore_pattern(path: Path, root: Path, pattern: str) -> bool:
    cleaned = pattern.strip().rstrip("/")
    if not cleaned:
        return False

    relative = path.relative_to(root).as_posix()
    parts = path.relative_to(root).parts

    if "/" in cleaned:
        return fnmatch.fnmatchcase(relative, cleaned)

    return (
        fnmatch.fnmatchcase(path.name, cleaned)
        or any(fnmatch.fnmatchcase(part, cleaned) for part in parts)
    )


def should_skip(path: Path, root: Path, ignore_patterns: list[str]) -> bool:
    if any(part in EXCLUDED_DIR_NAMES for part in path.parts):
        return True
    return any(matches_ignore_pattern(path, root, pattern) for pattern in ignore_patterns)


def find_notebooks(root: Path, ignore_patterns: list[str]) -> list[Path]:
    notebooks: list[Path] = []
    for notebook in root.rglob("*.ipynb"):
        if should_skip(notebook, root, ignore_patterns):
            continue
        notebooks.append(notebook)
    return sorted(notebooks)


def execute_notebook(notebook_path: Path, timeout: int, cap_threads: bool) -> NotebookRun:
    """Execute one notebook in a fresh kernel and guarantee kernel teardown."""
    started_at = time.monotonic()
    manager: KernelManager | None = None
    try:
        notebook = nbformat.read(notebook_path, as_version=4)
        manager = CurrentInterpreterKernelManager()
        if cap_threads:
            manager.extra_env = SINGLE_THREAD_ENV
        client = NotebookClient(
            notebook,
            km=manager,
            timeout=timeout,
            resources={"metadata": {"path": str(notebook_path.parent)}},
        )
        # We supplied the kernel manager, which makes nbclient treat the kernel
        # as externally owned and skip shutdown. Reclaim ownership so the kernel
        # process and its zmq channels are always torn down after execution.
        client.owns_km = True
        client.execute()
    except CellExecutionError as exc:
        return NotebookRun(notebook_path, time.monotonic() - started_at, str(exc).strip())
    except Exception as exc:  # noqa: BLE001 - report every notebook failure.
        return NotebookRun(
            notebook_path,
            time.monotonic() - started_at,
            f"{type(exc).__name__}: {exc}",
        )
    finally:
        _shutdown_kernel(manager)

    return NotebookRun(notebook_path, time.monotonic() - started_at)


def _shutdown_kernel(manager: KernelManager | None) -> None:
    """Best-effort kernel shutdown so no kernel subprocess is ever orphaned."""
    if manager is None:
        return
    try:
        if manager.has_kernel:
            manager.shutdown_kernel(now=True)
    except Exception:  # noqa: BLE001 - teardown must never mask the real result.
        pass


def run_notebooks(notebooks: list[Path], timeout: int, jobs: int, cap_threads: bool) -> list[NotebookRun]:
    total = len(notebooks)
    results: list[NotebookRun] = []

    if jobs == 1:
        for index, notebook in enumerate(notebooks, start=1):
            print(f"[{index}/{total}] RUN  {rel(notebook)}", flush=True)
            result = execute_notebook(notebook, timeout, cap_threads)
            results.append(result)
            _log_result(index, total, result)
        return results

    # spawn keeps behavior identical across platforms and avoids fork+thread
    # deadlocks; max_tasks_per_child=1 retires each worker after one notebook so
    # nothing accumulates in a long-lived process.
    context = get_context("spawn")
    completed = 0
    with ProcessPoolExecutor(
        max_workers=jobs,
        mp_context=context,
        max_tasks_per_child=1,
    ) as executor:
        futures = {
            executor.submit(execute_notebook, notebook, timeout, cap_threads): notebook
            for notebook in notebooks
        }
        for future in as_completed(futures):
            result = future.result()
            results.append(result)
            completed += 1
            _log_result(completed, total, result)

    return results


def _log_result(index: int, total: int, result: NotebookRun) -> None:
    status = "PASS" if result.passed else "FAIL"
    print(
        f"[{index}/{total}] {status} {rel(result.path)} ({result.elapsed_seconds:.1f}s)",
        flush=True,
    )


def print_summary(results: list[NotebookRun]) -> None:
    ordered = sorted(results, key=lambda result: result.path)
    passed = [result for result in ordered if result.passed]
    failed = [result for result in ordered if not result.passed]

    print("\n=== Notebook execution summary ===")
    print(f"Passed: {len(passed)}")
    print(f"Failed: {len(failed)}")
    print(f"Total:  {len(ordered)}")

    if not failed:
        return

    print("\n=== Failures ===")
    for result in failed:
        print(f"\nFAIL: {rel(result.path)} ({result.elapsed_seconds:.1f}s)")
        if result.error:
            print(result.error)


def main() -> int:
    args = parse_args()
    root = (WORKING_DIR / args.root).resolve()
    ignore_file = (WORKING_DIR / args.ignore_file).resolve()

    if not root.exists() or not root.is_dir():
        print(f"ERROR: root is not a directory: {root}", file=sys.stderr)
        return 2

    ignore_patterns = load_ignore_patterns(ignore_file)
    notebooks = find_notebooks(root, ignore_patterns)

    try:
        jobs = resolve_jobs(args.jobs, len(notebooks))
    except ValueError as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 2
    cap_threads = jobs > 1

    print(f"Working dir:  {WORKING_DIR}")
    print(f"Scan root:    {rel(root)}")
    print(f"Python:       {sys.executable}")
    print(f"Ignore file:  {rel(ignore_file)}")
    print("Ignore patterns:")
    for pattern in ignore_patterns:
        print(f"  - {pattern}")
    print(f"\nNotebooks selected: {len(notebooks)}")
    print(f"Parallel jobs:      {jobs}" + (" (kernels pinned to 1 thread)" if cap_threads else ""))

    if args.list_only:
        for notebook in notebooks:
            print(f"  {rel(notebook)}")
        return 0

    if not notebooks:
        print("\nNo notebooks to run.")
        return 0

    print()
    results = run_notebooks(notebooks, args.timeout, jobs, cap_threads)

    print_summary(results)
    return 1 if any(not result.passed for result in results) else 0


if __name__ == "__main__":
    sys.exit(main())
