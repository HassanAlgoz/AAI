#!/usr/bin/env python3
"""Report hands-on exercise completion-time estimates (no file edits).

Two kinds of exercises are recognized:

1. Exercise SETS — ``exset_*`` dirs / ``L*.Ex*`` links / quiz ``.md`` linked
   from a course README. Priced by *tasks* (code cells / questions the learner
   fills in). Calibrated against Data Wrangling exset_1 (~35 tasks -> ~45m).

2. EMBEDDED exercises — ``Exercise`` / ``Try it`` / ``Hands-On`` sections found
   *inside* a lesson's markdown (common in the Terminal and Agentic Engineering
   courses, which interleave practice into the lecture). Each such section is
   priced individually and excluded from the lesson's reading time.

Models (seconds, then ceil to minutes):

    set:       setup_min      + prose/wpm + tasks * task_sec
    embedded:  embedded_setup + prose/wpm + tasks * embedded_task_sec

where an embedded section's ``tasks`` = fenced code blocks + step markers
(``Step N`` headings and top-level numbered list items).

Examples:

    estimate_exercise_time.py courses/Data_Wrangling/L1/exset_1
    estimate_exercise_time.py --course courses/Data_Wrangling
    estimate_exercise_time.py --course courses/Terminal           # embedded only
    estimate_exercise_time.py --course courses/Data_Wrangling --json
    estimate_exercise_time.py courses/Terminal/L2/01_commands_grammar.md
"""
from __future__ import annotations

import argparse
import json
import math
import re
import sys
from dataclasses import asdict, dataclass
from pathlib import Path

from content_model import (
    FENCE_RE,
    PROSE_WPM,
    analyze_markdown_text,
    count_step_markers,
    discover_exercise_links,
    discover_lesson_links,
    partition_markdown_exercises,
)

EXSET_SETUP_MIN = 5.0
TASK_SEC = 60.0
# Embedded in-lesson exercises are smaller than full sets: a quick context
# switch instead of opening a fresh notebook, and shorter per-step actions.
EMBEDDED_SETUP_MIN = 1.0
EMBEDDED_TASK_SEC = 45.0

TEXT_SUFFIXES = {".md", ".txt"}


@dataclass
class ExerciseFeatures:
    notebooks: int = 0
    tasks: int = 0
    prose_words: int = 0

    def seconds(self, setup_min: float = EXSET_SETUP_MIN,
                prose_wpm: float = PROSE_WPM, task_sec: float = TASK_SEC) -> float:
        return (setup_min * 60.0
                + self.prose_words / prose_wpm * 60.0
                + self.tasks * task_sec)

    def to_dict(self) -> dict:
        return asdict(self)


def analyze_exercise_notebook(path: Path) -> ExerciseFeatures:
    nb = json.loads(path.read_text(encoding="utf-8"))
    f = ExerciseFeatures(notebooks=1)
    for cell in nb.get("cells", []):
        source = cell.get("source", "")
        if isinstance(source, list):
            source = "".join(source)
        if cell.get("cell_type") == "code":
            f.tasks += 1
        elif cell.get("cell_type") == "markdown":
            f.prose_words += len(source.split())
    return f


def analyze_exercise_markdown(path: Path) -> ExerciseFeatures:
    text = path.read_text(encoding="utf-8")
    questions = sum(
        1 for line in text.splitlines()
        if line.strip().endswith("?") or re.match(r"^\s*\d+[\.)]", line)
    )
    return ExerciseFeatures(
        notebooks=0,
        tasks=max(questions, 1),
        prose_words=len(text.split()),
    )


def analyze_exercise_path(path: Path) -> ExerciseFeatures:
    if path.suffix == ".ipynb":
        return analyze_exercise_notebook(path)
    if path.suffix in TEXT_SUFFIXES:
        return analyze_exercise_markdown(path)
    return ExerciseFeatures()


def analyze_exercise_dir(path: Path) -> ExerciseFeatures:
    total = ExerciseFeatures()
    for nb in sorted(path.rglob("*.ipynb")):
        part = analyze_exercise_notebook(nb)
        total.notebooks += part.notebooks
        total.tasks += part.tasks
        total.prose_words += part.prose_words
    for md in sorted(path.rglob("*.md")):
        if md.name.lower() == "readme.md":
            continue
        part = analyze_exercise_markdown(md)
        total.tasks += part.tasks
        total.prose_words += part.prose_words
    return total


def analyze_embedded_section(section_text: str) -> ExerciseFeatures:
    """Price one in-lesson exercise section by its actionable steps."""
    feats = analyze_markdown_text(section_text)
    blocks = len(FENCE_RE.findall(section_text))
    tasks = max(1, blocks + count_step_markers(section_text))
    return ExerciseFeatures(notebooks=0, tasks=tasks, prose_words=feats.prose_words)


def estimate_exercise_minutes(features: ExerciseFeatures, **rates) -> int:
    seconds = features.seconds(**rates)
    if seconds <= 0:
        return 0
    return max(1, math.ceil(seconds / 60.0))


@dataclass
class Row:
    label: str
    kind: str  # "set" or "embedded"
    features: ExerciseFeatures
    path: str


def _embedded_rows_for_lesson(label: str, path: Path) -> list[Row]:
    rows: list[Row] = []
    _, exercises = partition_markdown_exercises(path.read_text(encoding="utf-8"))
    for title, section in exercises:
        rows.append(Row(
            label=f"{label} :: {title}",
            kind="embedded",
            features=analyze_embedded_section(section),
            path=str(path),
        ))
    return rows


def collect_rows(paths: list[Path], course: Path | None, scan_lessons: bool) -> list[Row]:
    rows: list[Row] = []
    if course is not None:
        readme = course / "README.md"
        if not readme.is_file():
            print(f"error: missing {readme}", file=sys.stderr)
            sys.exit(1)
        for _, target, resolved in discover_exercise_links(readme):
            feats = analyze_exercise_dir(resolved) if resolved.is_dir() else analyze_exercise_path(resolved)
            rows.append(Row(target, "set", feats, str(resolved)))
        if scan_lessons:
            for _, target, resolved in discover_lesson_links(readme):
                if resolved.is_file() and resolved.suffix in TEXT_SUFFIXES:
                    rows.extend(_embedded_rows_for_lesson(target, resolved))
        return rows

    for p in paths:
        if p.is_dir():
            rows.append(Row(str(p), "set", analyze_exercise_dir(p), str(p)))
        elif p.suffix in TEXT_SUFFIXES and scan_lessons:
            embedded = _embedded_rows_for_lesson(str(p), p)
            rows.extend(embedded or [Row(str(p), "set", analyze_exercise_path(p), str(p))])
        else:
            rows.append(Row(str(p), "set", analyze_exercise_path(p), str(p)))
    return rows


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("paths", nargs="*", type=Path, help="exercise dirs/files, lesson files, or course dir")
    parser.add_argument("--course", type=Path, help="course directory; uses exercise + embedded links in README")
    parser.add_argument("--json", action="store_true")
    parser.add_argument("--setup-min", type=float, default=EXSET_SETUP_MIN)
    parser.add_argument("--prose-wpm", type=float, default=PROSE_WPM)
    parser.add_argument("--task-sec", type=float, default=TASK_SEC)
    parser.add_argument("--embedded-setup-min", type=float, default=EMBEDDED_SETUP_MIN)
    parser.add_argument("--embedded-task-sec", type=float, default=EMBEDDED_TASK_SEC)
    parser.add_argument("--no-scan-lessons", action="store_true",
                        help="skip in-lesson Exercise/Try-it sections (sets only)")
    args = parser.parse_args(argv)

    if not args.paths and args.course is None:
        parser.error("provide paths or --course")

    set_rates = dict(setup_min=args.setup_min, prose_wpm=args.prose_wpm, task_sec=args.task_sec)
    embedded_rates = dict(setup_min=args.embedded_setup_min, prose_wpm=args.prose_wpm,
                          task_sec=args.embedded_task_sec)

    rows = collect_rows(args.paths, args.course, scan_lessons=not args.no_scan_lessons)
    if not rows:
        print("error: no exercise paths found", file=sys.stderr)
        return 1

    results = []
    total = 0
    for row in rows:
        rates = embedded_rates if row.kind == "embedded" else set_rates
        minutes = estimate_exercise_minutes(row.features, **rates)
        total += minutes
        results.append({
            "target": row.label,
            "path": row.path,
            "kind": row.kind,
            "minutes": minutes,
            "features": row.features.to_dict(),
        })

    payload = {
        "kind": "exercise",
        "course": str(args.course) if args.course else None,
        "count": len(results),
        "total_minutes": total,
        "items": results,
    }

    if args.json:
        print(json.dumps(payload, indent=2))
        return 0

    width = max(len(r["target"]) for r in results)
    print(f"{'exercise'.ljust(width)}  {'kind':>8} {'nbs':>3} {'tasks':>5} {'prose':>5}  {'est':>5}")
    for r in results:
        f = r["features"]
        print(f"{r['target'].ljust(width)}  {r['kind']:>8} {f['notebooks']:>3} {f['tasks']:>5} "
              f"{f['prose_words']:>5}  {'~' + str(r['minutes']) + 'm':>5}")
    print(f"\nTOTAL (exercises only): {len(results)} exercises, ~{total}m")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
