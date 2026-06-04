#!/usr/bin/env python3
"""Report hands-on exercise completion-time estimates (no file edits).

Exercise notebooks are priced by *tasks* (code cells the learner fills in),
not by reading speed alone. Calibrated against Data Wrangling exset_1
(~35 tasks -> ~45m anchor in course README).

Model (seconds, then ceil to minutes):

    setup_min + prose/wpm + tasks * task_sec

Examples:

    estimate_exercise_time.py courses/Data_Wrangling/L1/exset_1
    estimate_exercise_time.py --course courses/Data_Wrangling
    estimate_exercise_time.py --course courses/Data_Wrangling --json
"""
from __future__ import annotations

import argparse
import json
import math
import re
import sys
from dataclasses import asdict, dataclass
from pathlib import Path

from content_model import PROSE_WPM, discover_exercise_links

EXSET_SETUP_MIN = 5.0
TASK_SEC = 60.0


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
    if path.suffix in {".md", ".txt"}:
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


def estimate_exercise_minutes(features: ExerciseFeatures, **rates) -> int:
    seconds = features.seconds(**rates)
    if seconds <= 0:
        return 0
    return max(1, math.ceil(seconds / 60.0))


def collect_exercise_rows(paths: list[Path], course: Path | None) -> list[tuple[str, Path]]:
    rows: list[tuple[str, Path]] = []
    if course is not None:
        readme = course / "README.md"
        if not readme.is_file():
            print(f"error: missing {readme}", file=sys.stderr)
            sys.exit(1)
        for _, target, resolved in discover_exercise_links(readme):
            rows.append((target, resolved))
        return rows

    for p in paths:
        rows.append((str(p), p))
    return rows


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("paths", nargs="*", type=Path, help="exercise dirs/files or course dir")
    parser.add_argument("--course", type=Path, help="course directory; uses exercise links in README")
    parser.add_argument("--json", action="store_true")
    parser.add_argument("--setup-min", type=float, default=EXSET_SETUP_MIN)
    parser.add_argument("--prose-wpm", type=float, default=PROSE_WPM)
    parser.add_argument("--task-sec", type=float, default=TASK_SEC)
    args = parser.parse_args(argv)

    if not args.paths and args.course is None:
        parser.error("provide paths or --course")

    rates = dict(setup_min=args.setup_min, prose_wpm=args.prose_wpm, task_sec=args.task_sec)
    rows = collect_exercise_rows(args.paths, args.course)
    if not rows:
        print("error: no exercise paths found", file=sys.stderr)
        return 1

    results = []
    total = 0
    for label, path in rows:
        feats = analyze_exercise_dir(path) if path.is_dir() else analyze_exercise_path(path)
        minutes = estimate_exercise_minutes(feats, **rates)
        total += minutes
        results.append({
            "target": label,
            "path": str(path),
            "minutes": minutes,
            "features": feats.to_dict(),
        })

    payload = {
        "kind": "exercise",
        "course": str(args.course) if args.course else None,
        "total_minutes": total,
        "items": results,
    }

    if args.json:
        print(json.dumps(payload, indent=2))
        return 0

    width = max(len(r["target"]) for r in results)
    print(f"{'exercise'.ljust(width)}  {'nbs':>3} {'tasks':>5} {'prose':>5}  {'est':>5}")
    for r in results:
        f = r["features"]
        print(f"{r['target'].ljust(width)}  {f['notebooks']:>3} {f['tasks']:>5} "
              f"{f['prose_words']:>5}  {'~' + str(r['minutes']) + 'm':>5}")
    print(f"\nTOTAL (exercises only): ~{total}m")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
