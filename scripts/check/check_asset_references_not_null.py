#!/usr/bin/env python3
"""Check that asset references in Typst files, Markdown files, and notebooks resolve.

Three passes:
  1. Typst files (`.typ`) under `courses/`. Paths starting with `/` are
     resolved relative to the project root; relative paths are resolved
     relative to the file itself.
  2. Markdown files (`.md`) under `courses/`. Markdown image/link targets and
     HTML `src`/`href` attributes are resolved relative to the file itself.
  3. Jupyter notebooks (`.ipynb`) under `courses/`. Paths in markdown cells
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
from urllib.parse import unquote

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

# Single-parameter Typst helpers that build a path by concatenating a string
# literal with the parameter, e.g.
#   #let asset(name) = "/courses/.../assets/" + name
#   #let asset(name) = name + "_suffix.png"
# Captures (helper_name, prefix, suffix); exactly one of prefix/suffix is set.
TYPST_HELPER_DEF_RE = re.compile(
    r'#let\s+(?P<name>\w+)\s*\(\s*(?P<param>\w+)\s*\)\s*=\s*'
    r'(?:"(?P<prefix>[^"]*)"\s*\+\s*(?P=param)'
    r'|(?P=param)\s*\+\s*"(?P<suffix>[^"]*)")'
)

# Markdown inline links/images. The target may contain spaces; trailing quoted
# titles are stripped in `clean_markdown_target`.
MD_INLINE_LINK_RE = re.compile(r'!?\[[^\]]*\]\(\s*(<[^>]+>|[^)]+?)\s*\)')

# HTML src/href attributes in markdown (handles escaped quotes in JSON).
HTML_ATTR_RE = re.compile(
    r'<(?:img|source|video|a)\b[^>]*\b(?:src|href)\s*=\s*'
    r'(?:(?:"|\\")(?P<double>[^"\\]+)|\'(?P<single>[^\']+)\')',
    re.IGNORECASE,
)


def is_external(path: str) -> bool:
    return path.startswith(("http://", "https://", "data:", "mailto:", "#"))


def clean_markdown_target(raw: str) -> str:
    target = raw.strip()
    if target.startswith("<") and target.endswith(">"):
        target = target[1:-1].strip()
    else:
        # Strip optional markdown titles without breaking paths that contain
        # spaces, e.g. `Salary Data.csv`.
        target = re.sub(r'\s+(?:"[^"]*"|\'[^\']*\')\s*$', "", target)
    # `![](foo.png){height=400}` => `foo.png`
    target = target.split("{", 1)[0].strip()
    # Local links may include anchors or cache-busting query strings.
    target = target.split("#", 1)[0].split("?", 1)[0].strip()
    return unquote(target)


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


def typst_helper_paths(text: str) -> list[str]:
    """Resolve paths built via single-parameter string-concat helpers.

    Handles the common indirection where an `image(...)` call wraps a helper
    instead of a literal, e.g. `image(asset("roc_curve.png"))` with
    `#let asset(name) = "/courses/.../assets/" + name`.
    """
    resolved: list[str] = []
    for m in TYPST_HELPER_DEF_RE.finditer(text):
        name = m.group("name")
        prefix = m.group("prefix") or ""
        suffix = m.group("suffix") or ""
        call_re = re.compile(rf'\b{re.escape(name)}\(\s*"([^"]+)"')
        for arg in call_re.findall(text):
            resolved.append(f"{prefix}{arg}{suffix}")
    return resolved


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
        for raw in typst_helper_paths(text):
            if is_external(raw):
                continue
            refs[typ_file].append(resolve_typst_path(raw, typ_file))
    return refs


def markdown_targets(text: str) -> list[str]:
    targets: list[str] = []
    targets.extend(MD_INLINE_LINK_RE.findall(text))
    for match in HTML_ATTR_RE.finditer(text):
        targets.append(match.group("double") or match.group("single") or "")
    return [clean_markdown_target(raw) for raw in targets]


def collect_markdown_references() -> dict[Path, list[Path]]:
    refs: dict[Path, list[Path]] = defaultdict(list)
    for md_file in iter_source_files(".md"):
        try:
            text = md_file.read_text(encoding="utf-8")
        except (OSError, UnicodeDecodeError) as exc:
            print(f"WARN: cannot read {md_file}: {exc}", file=sys.stderr)
            continue
        for raw in markdown_targets(text):
            if not raw or is_external(raw):
                continue
            if Path(raw).suffix.lower() not in ASSET_EXTENSIONS:
                continue
            refs[md_file].append(resolve_notebook_path(raw, md_file))
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
        for raw in markdown_targets(text):
            if not raw or is_external(raw):
                continue
            if Path(raw).suffix.lower() not in ASSET_EXTENSIONS:
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
    md_refs = collect_markdown_references()
    nb_refs = collect_notebook_references()

    print(
        f"\nScanned {len(typst_refs)} Typst files "
        f"{len(md_refs)} Markdown files "
        f"and {len(nb_refs)} notebooks with references."
    )

    _, typst_referenced = build_report(typst_refs, "Typst")
    _, md_referenced = build_report(md_refs, "Markdown")
    _, nb_referenced = build_report(nb_refs, "Notebooks")

    # For "unused", only count references that point inside our asset roots —
    # otherwise notebooks that reference local CSVs etc. would skew the set.
    referenced_in_assets = {
        p
        for p in (typst_referenced | md_referenced | nb_referenced)
        if in_tracked_asset_roots(p)
    }
    report_unused(referenced_in_assets)

    return 0


if __name__ == "__main__":
    sys.exit(main())
