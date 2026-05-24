#!/usr/bin/env python3
"""Check that asset references in Typst files and Jupyter notebooks resolve.

Two passes:
  1. Typst files (`.typ`) under `courses/`. Paths starting with `/` are
     resolved relative to the project root; relative paths are resolved
     relative to the file itself.
  2. Jupyter notebooks (`.ipynb`) under `courses/`. Paths in markdown cells
     (`![alt](path)` and `<img src="path">`) are resolved relative to the
     notebook's directory.

Then a reverse pass walks `assets/` (top level) and every `assets/` folder
under `courses/` to flag files that are never referenced.

Final report:
  1. Missing assets (broken references) and which files reference them.
  2. Asset files that exist but are never referenced.
"""

from __future__ import annotations

import json
import re
import sys
from collections import defaultdict
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent

SOURCE_ROOT = PROJECT_ROOT / "courses"

ASSET_ROOTS: list[Path] = [
    PROJECT_ROOT / "assets",
    *sorted(p for p in (PROJECT_ROOT / "courses").rglob("assets") if p.is_dir()),
]

ASSET_EXTENSIONS = {
    ".png", ".jpg", ".jpeg", ".gif", ".svg", ".webp", ".bmp", ".ico",
    ".pdf", ".mp4", ".webm", ".mov", ".csv", ".json",
}

EXCLUDE_DIR_NAMES = {
    "_site", ".quarto", "node_modules", ".ipynb_checkpoints", ".git",
}


# Captures the first arg of a Typst `image("...")` call.
TYPST_IMAGE_RE = re.compile(r'image\(\s*"([^"]+)"')

# Markdown image: ![alt](path), allowing optional {attrs} suffix that we strip.
MD_IMAGE_RE = re.compile(r'!\[[^\]]*\]\(\s*([^)\s]+?)(?:\s+"[^"]*")?\s*\)')

# HTML <img src="..."> in markdown cells (handles escaped quotes in JSON).
HTML_IMG_RE = re.compile(r'<img\b[^>]*\bsrc\s*=\s*(?:"|\\")([^"\\]+)', re.IGNORECASE)


def is_external(path: str) -> bool:
    return path.startswith(("http://", "https://", "data:", "mailto:", "#"))


def strip_md_attrs(path: str) -> str:
    # `![](foo.png){height=400}` => `foo.png`
    return path.split("{", 1)[0].strip()


def iter_source_files(suffix: str) -> list[Path]:
    if not SOURCE_ROOT.exists():
        return []
    files: list[Path] = []
    for path in SOURCE_ROOT.rglob(f"*{suffix}"):
        if any(part in EXCLUDE_DIR_NAMES for part in path.parts):
            continue
        files.append(path)
    return files


def resolve_typst_path(raw: str, source_file: Path) -> Path:
    # Typst paths starting with `/` are project-root relative. Some files use
    # `//` by mistake; treat both the same.
    cleaned = raw.lstrip("/")
    if raw.startswith("/"):
        return (PROJECT_ROOT / cleaned).resolve()
    return (source_file.parent / raw).resolve()


def resolve_notebook_path(raw: str, notebook: Path) -> Path:
    # Notebook references are relative to the notebook's directory.
    if raw.startswith("/"):
        return (PROJECT_ROOT / raw.lstrip("/")).resolve()
    return (notebook.parent / raw).resolve()


def collect_typst_references() -> dict[Path, list[Path]]:
    """Return mapping of source_file -> list of resolved referenced paths."""
    refs: dict[Path, list[Path]] = defaultdict(list)
    for typ_file in iter_source_files(".typ"):
        try:
            text = typ_file.read_text(encoding="utf-8")
        except (OSError, UnicodeDecodeError) as exc:
            print(f"WARN: cannot read {typ_file}: {exc}", file=sys.stderr)
            continue
        for raw in TYPST_IMAGE_RE.findall(text):
            if is_external(raw):
                continue
            refs[typ_file].append(resolve_typst_path(raw, typ_file))
    return refs


def extract_markdown_text(notebook_json: dict) -> str:
    pieces: list[str] = []
    for cell in notebook_json.get("cells", []):
        if cell.get("cell_type") != "markdown":
            continue
        source = cell.get("source", "")
        if isinstance(source, list):
            pieces.append("".join(source))
        elif isinstance(source, str):
            pieces.append(source)
    return "\n".join(pieces)


def collect_notebook_references() -> dict[Path, list[Path]]:
    refs: dict[Path, list[Path]] = defaultdict(list)
    for nb_file in iter_source_files(".ipynb"):
        try:
            with nb_file.open(encoding="utf-8") as fh:
                nb_json = json.load(fh)
        except (OSError, json.JSONDecodeError, UnicodeDecodeError) as exc:
            print(f"WARN: cannot parse {nb_file}: {exc}", file=sys.stderr)
            continue
        text = extract_markdown_text(nb_json)
        for raw in MD_IMAGE_RE.findall(text):
            raw = strip_md_attrs(raw)
            if not raw or is_external(raw):
                continue
            refs[nb_file].append(resolve_notebook_path(raw, nb_file))
        for raw in HTML_IMG_RE.findall(text):
            if is_external(raw):
                continue
            refs[nb_file].append(resolve_notebook_path(raw, nb_file))
    return refs


def collect_asset_files() -> set[Path]:
    found: set[Path] = set()
    for root in ASSET_ROOTS:
        if not root.exists():
            continue
        for path in root.rglob("*"):
            if not path.is_file():
                continue
            if any(part in EXCLUDE_DIR_NAMES for part in path.parts):
                continue
            if path.suffix.lower() not in ASSET_EXTENSIONS:
                continue
            found.add(path.resolve())
    return found


def rel(p: Path) -> str:
    try:
        return str(p.relative_to(PROJECT_ROOT))
    except ValueError:
        return str(p)


def in_tracked_asset_roots(p: Path) -> bool:
    """Only flag missing/unused for paths inside the asset roots we manage."""
    return any(
        str(p).startswith(str(root.resolve()) + "/") or p == root.resolve()
        for root in ASSET_ROOTS
    )


def build_report(
    refs_by_source: dict[Path, list[Path]],
    label: str,
) -> tuple[dict[Path, list[Path]], set[Path]]:
    """Return (missing_targets -> [referencing_files], referenced_targets)."""
    missing: dict[Path, list[Path]] = defaultdict(list)
    referenced: set[Path] = set()
    for source_file, targets in refs_by_source.items():
        for target in targets:
            referenced.add(target)
            if not target.exists():
                missing[target].append(source_file)
    if missing:
        print(f"\n=== Missing references ({label}) ===")
        for target in sorted(missing):
            print(f"\n  MISSING: {rel(target)}")
            for src in sorted(set(missing[target])):
                print(f"    referenced by: {rel(src)}")
    else:
        print(f"\n=== Missing references ({label}): none ===")
    return missing, referenced


def report_unused(referenced: set[Path]) -> None:
    print("\n=== Unreferenced asset files ===")
    asset_files = collect_asset_files()
    unused = sorted(asset_files - referenced)
    if not unused:
        print("  none")
        return
    for path in unused:
        print(f"  {rel(path)}")
    print(f"\n  total unreferenced: {len(unused)}")


def main() -> int:
    print(f"Project root: {PROJECT_ROOT}")
    print(f"Source root:  {rel(SOURCE_ROOT)}")
    print("Asset roots:")
    for root in ASSET_ROOTS:
        print(f"  - {rel(root)}")

    typst_refs = collect_typst_references()
    nb_refs = collect_notebook_references()

    print(
        f"\nScanned {len(typst_refs)} Typst files "
        f"and {len(nb_refs)} notebooks with references."
    )

    _, typst_referenced = build_report(typst_refs, "Typst")
    _, nb_referenced = build_report(nb_refs, "Notebooks")

    # For "unused", only count references that point inside our asset roots —
    # otherwise notebooks that reference local CSVs etc. would skew the set.
    referenced_in_assets = {
        p for p in (typst_referenced | nb_referenced) if in_tracked_asset_roots(p)
    }
    report_unused(referenced_in_assets)

    return 0


if __name__ == "__main__":
    sys.exit(main())
