#!/usr/bin/env python3
"""Render `README.md` from `README_template.md`, `outline.md`, and `course_notes.md`.

Before rendering, course blocks in `outline.md` are enriched from
``metadata.yml``: headings, descriptions, and per-course time estimates.
Module lists and track structure stay in ``outline.md``; policy and exercise
notes come from ``course_notes.md``.

Usage:
    python scripts/render_readme.py                 # write README.md
    python scripts/render_readme.py -o OUT.md       # write elsewhere
    python scripts/render_readme.py --check         # verify files are current
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from build_readme import find_repo_root  # noqa: E402
from course_meta import prepare_outline, strip_outline_title  # noqa: E402


def render_readme(template: str, outline: str, course_notes: str) -> str:
    outline_body = strip_outline_title(outline)
    rendered = template.replace("{{outline}}", outline_body)
    rendered = rendered.replace("{{course_notes}}", course_notes.strip("\n"))
    return rendered.rstrip("\n") + "\n"


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument(
        "-t", "--template", type=Path, default=None,
        help="Template file (default: README_template.md at repo root).",
    )
    parser.add_argument(
        "--outline", type=Path, default=None,
        help="Outline file (default: outline.md at repo root).",
    )
    parser.add_argument(
        "--course-notes", type=Path, default=None,
        help="Course notes file (default: course_notes.md at repo root).",
    )
    parser.add_argument(
        "-o", "--output", type=Path, default=None,
        help="Output file (default: README.md at repo root).",
    )
    parser.add_argument(
        "--root", type=Path, default=None,
        help="Repository root (default: auto-detect).",
    )
    parser.add_argument(
        "--check", action="store_true",
        help="Exit non-zero if outline or README is out of date (no write).",
    )
    args = parser.parse_args(argv)

    repo_root = args.root.resolve() if args.root else find_repo_root(Path(__file__))
    template_path = args.template or (repo_root / "README_template.md")
    outline_path = args.outline or (repo_root / "outline.md")
    course_notes_path = args.course_notes or (repo_root / "course_notes.md")
    output_path = args.output or (repo_root / "README.md")

    if not template_path.is_file():
        print(f"error: template not found: {template_path}", file=sys.stderr)
        return 1
    if not outline_path.is_file():
        print(f"error: outline not found: {outline_path}", file=sys.stderr)
        return 1
    if not course_notes_path.is_file():
        print(f"error: course notes not found: {course_notes_path}", file=sys.stderr)
        return 1

    template = template_path.read_text(encoding="utf-8")
    outline = outline_path.read_text(encoding="utf-8")
    course_notes = course_notes_path.read_text(encoding="utf-8")
    enriched_outline, validation_errors = prepare_outline(outline, repo_root)
    if validation_errors:
        for error in validation_errors:
            print(f"error: {error}", file=sys.stderr)
        return 1

    rendered = render_readme(template, enriched_outline, course_notes)

    if args.check:
        outline_ok = outline == enriched_outline
        readme_ok = (
            output_path.read_text(encoding="utf-8") == rendered
            if output_path.is_file()
            else False
        )
        if not outline_ok or not readme_ok:
            print(
                f"error: {outline_path} and/or {output_path} are out of date; "
                "run render_readme.py",
                file=sys.stderr,
            )
            return 1
        print(f"{outline_path} and {output_path} are up to date", file=sys.stderr)
        return 0

    if enriched_outline != outline:
        outline_path.write_text(enriched_outline, encoding="utf-8")
        print(f"wrote {outline_path}", file=sys.stderr)

    output_path.write_text(rendered, encoding="utf-8")
    print(f"wrote {output_path}", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
