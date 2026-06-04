---
name: verify-nbs
description: Execute course Jupyter notebooks headlessly to catch runtime/import errors, with a fresh kernel per notebook and a .nbignore glob filter. Use when the user wants to verify, run, smoke-test, or check notebooks for errors across a folder, or mentions running all .ipynb files / checking notebooks compile.
---

# Verify Notebooks

Run `.ipynb` files without opening them to catch execution errors (syntax, imports, bad data paths, exceptions). Each notebook runs in a **fresh kernel** (no shared state between notebooks) using the **repository `.venv`**, from **its own directory** (so relative paths like `data/foo.csv` resolve). Notebooks run **in parallel** across CPU cores by default.

## Run

Always invoke from the repository root with `uv run` so the kernel uses `.venv`:

```bash
SKILL=.agents/skills/verify-nbs/scripts

# Run every notebook under courses/ (default root), parallel across all cores
uv run python $SKILL/run_notebooks.py

# Run a specific folder
uv run python $SKILL/run_notebooks.py courses/Data_Wrangling

# Preview selection without executing (fast sanity check on filtering)
uv run python $SKILL/run_notebooks.py courses --list-only

# Raise the per-cell timeout for slow notebooks (default 120s)
uv run python $SKILL/run_notebooks.py courses --timeout 300

# Control parallelism (default: CPU count). Use -j 1 for serial, easy-to-read logs
uv run python $SKILL/run_notebooks.py courses -j 4
uv run python $SKILL/run_notebooks.py courses -j 1
```

Exit code is `0` when all selected notebooks pass, `1` if any fail, `2` on bad input. The script runs **every** notebook and reports all failures at the end (it does not stop on the first failure).

## Parallelism

- `-j/--jobs` sets how many notebooks run concurrently. Default is `os.cpu_count()`; it is automatically capped at the number of selected notebooks.
- When more than one job runs, each kernel is pinned to a single math-library thread (`OMP/OPENBLAS/MKL/NUMEXPR/VECLIB/BLIS_NUM_THREADS=1`) so total load equals `--jobs` rather than `jobs x cores` of oversubscribed threads. This keeps CPU utilization full and deterministic. With `-j 1` no pinning is applied (notebooks may use all cores).
- Live `[i/total]` progress lines appear in completion order during parallel runs, but the final summary and failure list are always printed in sorted path order, so results are deterministic regardless of timing.

## Filtering with `.nbignore`

The runner reads `.nbignore` from the working directory (override with `--ignore-file`).

- Blank lines and `#` comment lines are ignored.
- A pattern without `/` matches against the notebook's **name** and any **path segment** (gitignore-like), so `exset*` skips everything under any `exset_*/` directory.
- A pattern containing `/` is matched against the notebook's path relative to the scan root via `fnmatch`.
- Built-in defaults `exset*` and `exercise*` are **always applied**, even if `.nbignore` is absent. The file adds to (does not replace) them.
- Directories `.git`, `.ipynb_checkpoints`, `.quarto`, `_site`, `node_modules` are always excluded.

## Requirements

Driver libraries live in the repo's dev dependency group (`pyproject.toml` → `[dependency-groups] dev`): `nbclient`, `nbformat`. The kernel uses the already-present `ipykernel` + `jupyter_client` in `.venv`. If imports fail, run `uv sync`.

## How it works (for debugging the runner)

- `CurrentInterpreterKernelManager` forces each kernel to launch via `sys.executable -m ipykernel_launcher`, so running the script with `.venv`'s Python (through `uv run`) guarantees notebooks execute in `.venv` rather than a globally registered `python3` kernelspec. Its `extra_env` is merged into the kernel environment to pin math-library threads.
- A new `NotebookClient` + kernel process is created per notebook and torn down after, giving per-notebook isolation while cells within one notebook still share state.
- Each notebook's working directory is set via `resources={"metadata": {"path": <notebook dir>}}`.
- **Kernel teardown:** because the runner supplies its own kernel manager, `nbclient` would otherwise treat the kernel as externally owned and never shut it down (leaking a kernel subprocess + zmq channels per notebook). The runner sets `client.owns_km = True` and adds a defensive `shutdown_kernel(now=True)` in a `finally`, so no kernel is ever orphaned.
- **Parallel execution** uses a `spawn`-based `ProcessPoolExecutor` (`run_notebooks`). `spawn` behaves identically on Linux/macOS/Windows and avoids `fork`-with-threads/asyncio deadlocks. `max_tasks_per_child=1` retires each worker after one notebook, so nothing accumulates in a long-lived driver process. Workers share no mutable state and each kernel gets its own auto-assigned ports/connection file. `-j 1` runs in-process (no pool) for the simplest debugging path.
