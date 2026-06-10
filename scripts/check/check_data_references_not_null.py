#!/usr/bin/env python3
"""Check that data references in Typst files, Markdown files, and notebooks resolve.

Three passes:
  1. Typst files (`.typ`) under `courses/`. Paths in `csv("...")`, `json("...")`,
     `read("...")` (and similar) calls are resolved. Paths starting with `/`
     are project-root relative; otherwise relative to the file itself.
  2. Markdown files (`.md`) under `courses/`. Markdown image/link targets and
     HTML `src`/`href` attributes with data-file extensions are resolved
     relative to the file itself.
  3. Jupyter notebook (`.ipynb`) code cells under `courses/`. Only string
     literals that sit inside a *read* construct are considered references:
       - `pd.read_csv(...)`, `read_json(...)`, `read_excel(...)`, …
       - `open(...)` and `Path(...)` calls
     This avoids false positives from `df.to_csv("out.csv")` and similar
     write/demo calls. For path-joining idioms such as
     `pd.read_csv(path_data / "trip.csv")` the literal `"trip.csv"` is
     resolved by trying every directory-like literal collected from the
     whole notebook (so a `Path("data/...")` defined in an earlier cell
     can still serve as a prefix hint).

Then a reverse pass walks `data/` (top level) and every `courses/**/data/`
folder to flag data files that are never referenced.

Final report:
  1. Missing data (broken references) and which files reference them.
  2. Data files that exist but are never referenced.
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

DATA_ROOTS: list[Path] = [
    p for p in [
        PROJECT_ROOT / "data",
        *sorted((PROJECT_ROOT / "courses").rglob("data")),
    ]
    if p.is_dir()
]

DATA_EXTENSIONS = {
    ".csv", ".tsv", ".json", ".jsonl", ".ndjson",
    ".xlsx", ".xls", ".ods",
    ".parquet", ".feather", ".arrow",
    ".h5", ".hdf5", ".pkl", ".pickle",
    ".txt", ".dat",
}

EXCLUDE_DIR_NAMES = {
    "_site", ".quarto", "node_modules", ".ipynb_checkpoints", ".git",
}


# Typst data-loading functions: csv("..."), json("..."), read("..."), etc.
TYPST_DATA_RE = re.compile(
    r'\b(?:csv|json|jsonl|toml|yaml|xml|cbor|read)\(\s*"([^"]+)"'
)

# Python read/path constructors whose argument lists we scan for path literals.
# `to_csv`, `write_*`, etc. are intentionally excluded.
PY_READ_CALL_RE = re.compile(
    r'\b(?:'
    r'read_csv|read_json|read_excel|read_parquet|read_table|read_pickle|'
    r'read_feather|read_html|read_xml|read_orc|read_fwf|read_sql|read_hdf|'
    r'read_stata|read_spss|read_sas|read_clipboard|load_dataset|'
    r'Path|open'
    r')\s*\('
)

# String literals in Python code: "..." or '...' with escape handling.
PY_STR_RE = re.compile(r'(?P<q>["\'])((?:\\.|(?!(?P=q)).)*)(?P=q)')

# Literals participating in path-joining via `/`, e.g.
#   Path("data") / "file.csv"     →  capture "file.csv"
#   "data" / Path("x") / "y.csv"  →  capture "data" and "y.csv"
PY_JOIN_LITERAL_RE = re.compile(
    r'/\s*(?P<qa>["\'])(?P<va>(?:\\.|(?!(?P=qa)).)*)(?P=qa)'
    r'|'
    r'(?P<qb>["\'])(?P<vb>(?:\\.|(?!(?P=qb)).)*)(?P=qb)\s*/'
)

# Markdown inline links/images. The target may contain spaces; trailing quoted
# titles are stripped in `clean_markdown_target`.
MD_INLINE_LINK_RE = re.compile(r'!?\[[^\]]*\]\(\s*(<[^>]+>|[^)]+?)\s*\)')

# HTML src/href attributes in markdown.
HTML_ATTR_RE = re.compile(
    r'<(?:img|source|video|a)\b[^>]*\b(?:src|href)\s*=\s*'
    r'(?:(?:"|\\")(?P<double>[^"\\]+)|\'(?P<single>[^\']+)\')',
    re.IGNORECASE,
)


def is_external(path: str) -> bool:
    return path.startswith(("http://", "https://", "ftp://", "s3://", "data:", "mailto:", "#"))


def has_data_ext(path: str) -> bool:
    return Path(path).suffix.lower() in DATA_EXTENSIONS


def clean_markdown_target(raw: str) -> str:
    target = raw.strip()
    if target.startswith("<") and target.endswith(">"):
        target = target[1:-1].strip()
    else:
        # Strip optional markdown titles without breaking paths that contain
        # spaces, e.g. `Salary Data.csv`.
        target = re.sub(r'\s+(?:"[^"]*"|\'[^\']*\')\s*$', "", target)
    # `![](foo.csv){download}` => `foo.csv`
    target = target.split("{", 1)[0].strip()
    # Local links may include anchors or cache-busting query strings.
    target = target.split("#", 1)[0].split("?", 1)[0].strip()
    return unquote(target)


def looks_like_dir(literal: str) -> bool:
    """Heuristic: a string literal that could be a directory prefix."""
    if not literal or is_external(literal):
        return False
    if has_data_ext(literal):
        return False
    # Must contain something path-like: a slash or look like a single segment
    # without spaces/special characters that doesn't have a file extension.
    if "\n" in literal or "\t" in literal:
        return False
    # Common dir markers
    if "/" in literal or literal.endswith(("/", ".")):
        return True
    # Otherwise restrict to simple identifier-like names to avoid noise.
    return bool(re.fullmatch(r"[A-Za-z0-9._-]+", literal))


def iter_source_files(suffix: str) -> list[Path]:
    if not SOURCE_ROOT.exists():
        return []
    files: list[Path] = []
    for path in SOURCE_ROOT.rglob(f"*{suffix}"):
        if any(part in EXCLUDE_DIR_NAMES for part in path.parts):
            continue
        files.append(path)
    return files


def resolve_relative(raw: str, source_file: Path) -> Path:
    """Paths starting with `/` are project-root relative."""
    if raw.startswith("/"):
        return (PROJECT_ROOT / raw.lstrip("/")).resolve()
    return (source_file.parent / raw).resolve()


def in_tracked_data_roots(p: Path) -> bool:
    """Only flag missing/unused for paths inside the data roots we manage."""
    return any(
        str(p).startswith(str(root.resolve()) + "/") or p == root.resolve()
        for root in DATA_ROOTS
    )


def collect_typst_references() -> dict[Path, list[Path]]:
    """Return mapping of source_file -> list of resolved referenced paths."""
    refs: dict[Path, list[Path]] = defaultdict(list)
    for typ_file in iter_source_files(".typ"):
        try:
            text = typ_file.read_text(encoding="utf-8")
        except (OSError, UnicodeDecodeError) as exc:
            print(f"WARN: cannot read {typ_file}: {exc}", file=sys.stderr)
            continue
        for raw in TYPST_DATA_RE.findall(text):
            if is_external(raw) or not has_data_ext(raw):
                continue
            refs[typ_file].append(resolve_relative(raw, typ_file))
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
            if not raw or is_external(raw) or not has_data_ext(raw):
                continue
            refs[md_file].append(resolve_relative(raw, md_file))
    return refs


def extract_code_cells(notebook_json: dict) -> list[str]:
    cells: list[str] = []
    for cell in notebook_json.get("cells", []):
        if cell.get("cell_type") != "code":
            continue
        source = cell.get("source", "")
        if isinstance(source, list):
            cells.append("".join(source))
        elif isinstance(source, str):
            cells.append(source)
    return cells


def string_literals(code: str) -> list[str]:
    return [m.group(2) for m in PY_STR_RE.finditer(code)]


def path_join_literals(code: str) -> list[str]:
    out: list[str] = []
    for m in PY_JOIN_LITERAL_RE.finditer(code):
        out.append(m.group("va") or m.group("vb") or "")
    return [s for s in out if s]


def extract_read_call_args(code: str) -> list[str]:
    """Return the argument text inside every read-style call.

    Balances parentheses so that nested calls don't truncate the slice.
    """
    args: list[str] = []
    for m in PY_READ_CALL_RE.finditer(code):
        depth = 1
        i = m.end()
        start = i
        while i < len(code) and depth > 0:
            ch = code[i]
            if ch == "(":
                depth += 1
            elif ch == ")":
                depth -= 1
                if depth == 0:
                    break
            i += 1
        if depth == 0:
            args.append(code[start:i])
    return args


def resolve_notebook_literal(
    filename: str,
    dir_hints: list[str],
    notebook: Path,
) -> Path:
    """Pick the best resolution among as-is and Path-joined candidates.

    Preference order:
      1. A candidate that exists on disk.
      2. A candidate inside one of the tracked data roots (likely intended
         target — surfaces it in the missing report instead of a confusing
         notebook-local path).
      3. The as-is resolution relative to the notebook directory.
    """
    candidates: list[Path] = [resolve_relative(filename, notebook)]
    for hint in dir_hints:
        if hint.startswith("/"):
            base = PROJECT_ROOT / hint.lstrip("/")
        else:
            base = notebook.parent / hint
        candidates.append((base / filename).resolve())

    for cand in candidates:
        if cand.exists():
            return cand
    for cand in candidates:
        if in_tracked_data_roots(cand):
            return cand
    return candidates[0]


def collect_notebook_references() -> dict[Path, list[Path]]:
    refs: dict[Path, list[Path]] = defaultdict(list)
    for nb_file in iter_source_files(".ipynb"):
        try:
            with nb_file.open(encoding="utf-8") as fh:
                nb_json = json.load(fh)
        except (OSError, json.JSONDecodeError, UnicodeDecodeError) as exc:
            print(f"WARN: cannot parse {nb_file}: {exc}", file=sys.stderr)
            continue

        # Collect candidate literals across the whole notebook so a `Path(...)`
        # defined in one cell can be used as a prefix hint in another.
        all_call_literals: list[str] = []
        for code in extract_code_cells(nb_json):
            for args_text in extract_read_call_args(code):
                all_call_literals.extend(string_literals(args_text))
            # Also catch literals that take part in `/` path-joining outside of
            # a read call, e.g. `file_path = Path('data') / 'foo.csv'`.
            all_call_literals.extend(path_join_literals(code))

        data_literals = [
            s for s in all_call_literals
            if has_data_ext(s) and not is_external(s)
        ]
        if not data_literals:
            continue
        dir_hints = [s for s in all_call_literals if looks_like_dir(s)]
        for raw in data_literals:
            refs[nb_file].append(resolve_notebook_literal(raw, dir_hints, nb_file))
    return refs


def collect_data_files() -> set[Path]:
    found: set[Path] = set()
    for root in DATA_ROOTS:
        for path in root.rglob("*"):
            if not path.is_file():
                continue
            if any(part in EXCLUDE_DIR_NAMES for part in path.parts):
                continue
            if path.suffix.lower() not in DATA_EXTENSIONS:
                continue
            found.add(path.resolve())
    return found


def rel(p: Path) -> str:
    try:
        return str(p.relative_to(PROJECT_ROOT))
    except ValueError:
        return str(p)


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
    print("\n=== Unreferenced data files ===")
    data_files = collect_data_files()
    unused = sorted(data_files - referenced)
    if not unused:
        print("  none")
        return
    for path in unused:
        print(f"  {rel(path)}")
    print(f"\n  total unreferenced: {len(unused)}")


def main() -> int:
    print(f"Project root: {PROJECT_ROOT}")
    print(f"Source root:  {rel(SOURCE_ROOT)}")
    print("Data roots:")
    if not DATA_ROOTS:
        print("  (none found)")
    for root in DATA_ROOTS:
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

    referenced_in_data = {
        p
        for p in (typst_referenced | md_referenced | nb_referenced)
        if in_tracked_data_roots(p)
    }
    report_unused(referenced_in_data)

    return 0


if __name__ == "__main__":
    sys.exit(main())
