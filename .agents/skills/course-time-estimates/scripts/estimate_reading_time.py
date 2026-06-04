#!/usr/bin/env python3
"""Report hands-on reading-time estimates for lessons (no file edits).

The agent applies (~Xm) annotations to README files; this script only
computes deterministic numbers from content structure.

Model (seconds, then ceil to minutes):

    setup_min + prose/wpm + code_lines*code_sec + output_lines*out_sec
              + images*img_sec + slides*slide_sec

Notebooks (.ipynb) and markdown (.md/.txt) use prose/code/output/images.
Typst decks (.typ) are priced as slides: title slide + headings + page
breaks, plus their prose and images.

Examples:

    # Single lesson
    estimate_reading_time.py courses/Data_Wrangling/L1/01_pandas_io.ipynb

    # All lessons linked from a course README
    estimate_reading_time.py --course courses/Data_Wrangling

    # Machine-readable output for an agent
    estimate_reading_time.py --course courses/Data_Wrangling --json
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from content_model import (
    COUNTABLE_SUFFIXES,
    SETUP_MIN,
    PROSE_WPM,
    CODE_SEC_PER_LINE,
    OUTPUT_SEC_PER_LINE,
    IMAGE_SEC,
    SLIDE_SEC,
    analyze_path,
    discover_lesson_links,
    estimate_minutes,
)


def collect_paths(paths: list[Path], course: Path | None) -> list[tuple[str, Path]]:
    """Return (label, path) rows to estimate."""
    rows: list[tuple[str, Path]] = []
    if course is not None:
        readme = course / "README.md"
        if not readme.is_file():
            print(f"error: missing {readme}", file=sys.stderr)
            sys.exit(1)
        for text, target, resolved in discover_lesson_links(readme):
            rows.append((target, resolved))
        return rows

    for p in paths:
        if p.is_file():
            rows.append((str(p), p))
        elif p.is_dir():
            readme = p / "README.md"
            if readme.is_file():
                rows.extend((t, r) for _, t, r in discover_lesson_links(readme))
            else:
                for child in sorted(p.rglob("*")):
                    if child.suffix in COUNTABLE_SUFFIXES and child.is_file():
                        rows.append((str(child.relative_to(p)), child))
    return rows


def build_rates(args: argparse.Namespace) -> dict:
    return dict(
        setup_min=args.setup_min,
        prose_wpm=args.prose_wpm,
        code_sec=args.code_sec,
        out_sec=args.out_sec,
        img_sec=args.img_sec,
        slide_sec=args.slide_sec,
    )


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("paths", nargs="*", type=Path, help="lesson files or course directories")
    parser.add_argument("--course", type=Path,
                        help="course directory with README.md (uses linked lessons only)")
    parser.add_argument("--json", action="store_true", help="emit JSON for agent consumption")
    parser.add_argument("--setup-min", type=float, default=SETUP_MIN)
    parser.add_argument("--prose-wpm", type=float, default=PROSE_WPM)
    parser.add_argument("--code-sec", type=float, default=CODE_SEC_PER_LINE)
    parser.add_argument("--out-sec", type=float, default=OUTPUT_SEC_PER_LINE)
    parser.add_argument("--img-sec", type=float, default=IMAGE_SEC)
    parser.add_argument("--slide-sec", type=float, default=SLIDE_SEC,
                        help="per-slide cost for .typ decks (title slide + headings + pagebreaks)")
    args = parser.parse_args(argv)

    if not args.paths and args.course is None:
        parser.error("provide paths or --course")

    rates = build_rates(args)
    rows = collect_paths(args.paths, args.course)
    if not rows:
        print("error: no countable lesson files found", file=sys.stderr)
        return 1

    results = []
    total = 0
    for label, path in rows:
        feats = analyze_path(path)
        minutes = estimate_minutes(feats, **rates)
        total += minutes
        results.append({
            "target": label,
            "path": str(path),
            "minutes": minutes,
            "features": feats.to_dict(),
        })

    payload = {
        "kind": "reading",
        "course": str(args.course) if args.course else None,
        "total_minutes": total,
        "items": results,
    }

    if args.json:
        print(json.dumps(payload, indent=2))
        return 0

    width = max(len(r["target"]) for r in results)
    print(f"{'lesson'.ljust(width)}  {'prose':>5} {'code':>4} {'out':>4} {'img':>3} {'sld':>3}  {'est':>5}")
    for r in results:
        f = r["features"]
        print(f"{r['target'].ljust(width)}  {f['prose_words']:>5} {f['code_lines']:>4} "
              f"{f['output_lines']:>4} {f['images']:>3} {f['slides']:>3}  {'~' + str(r['minutes']) + 'm':>5}")
    print(f"\nTOTAL (lessons only): ~{total}m")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
