#!/usr/bin/env python3
"""Crawl a README's relative links and assemble a single combined README.

Starting from an input `README.md`, this script follows every *relative* link
whose target is another README -- either an explicit `.../README.md` file or a
folder path (e.g. `/courses/Terminal/` or `../foo`) that contains a `README.md`.
It recurses through those, building a tree, and emits one document.

Two output modes:

  * default   -- a nested bulleted list (table of contents): each linked course
                 README contributes its title and only module headings matching
                 `M1. `, `M2. `, ...
  * --enriched -- the same structure with full section content under each
                 module heading. The input README itself is never inlined; it
                 is only used as an index to discover linked course READMEs.

Path resolution mirrors GitHub markdown:
  * links starting with `/` resolve against the repository root (auto-detected
    by walking up to a `.git` dir, or set via `--root`);
  * all other relative links resolve against the linking file's directory;
  * external links (`http://`, `mailto:`, bare `#anchor`, ...) are ignored.

Usage:
    python scripts/build_readme.py README.md               # ToC to stdout
    python scripts/build_readme.py README.md --enriched     # full doc
    python scripts/build_readme.py README.md -o OUT.md      # write to file
"""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path
from urllib.parse import unquote

# Markdown inline link `[text](target)`; the leading `!` (images) is captured
# so we can discard image links. Targets may be wrapped in `<...>`.
MD_LINK_RE = re.compile(r"(!?)\[([^\]]*)\]\(\s*(<[^>]+>|[^)]+?)\s*\)")

# A fenced code block opener/closer: ``` or ~~~ (any indent, any info string).
FENCE_RE = re.compile(r"^\s*(`{3,}|~{3,})")

# ATX heading, e.g. `### Title`.
HEADING_RE = re.compile(r"^(#{1,6})\s+(.*?)\s*#*\s*$")

# Module headings such as `M1. Introductions`, `M12. Foo`.
MODULE_HEADING_RE = re.compile(r"^M\d+\.\s")


def is_external(target: str) -> bool:
    return target.startswith(
        ("http://", "https://", "data:", "mailto:", "tel:", "#")
    )


def clean_target(raw: str) -> str:
    """Normalize a raw link target to a filesystem-ish path."""
    target = raw.strip()
    if target.startswith("<") and target.endswith(">"):
        target = target[1:-1].strip()
    # Drop an optional markdown title: `(path "Title")`.
    target = re.sub(r'\s+(?:"[^"]*"|\'[^\']*\')\s*$', "", target)
    # Drop anchors and query strings.
    target = target.split("#", 1)[0].split("?", 1)[0].strip()
    return unquote(target)


def find_repo_root(start: Path) -> Path:
    """Walk up from `start` looking for a `.git` dir; fall back to `start`."""
    start = start.resolve()
    base = start if start.is_dir() else start.parent
    for candidate in (base, *base.parents):
        if (candidate / ".git").exists():
            return candidate
    return base


def iter_lines_outside_code(text: str):
    """Yield (line, in_fence) so callers can skip fenced code blocks."""
    fence: str | None = None
    for line in text.splitlines():
        match = FENCE_RE.match(line)
        if match:
            marker = match.group(1)[0]
            if fence is None:
                fence = marker
            elif marker == fence:
                fence = None
            yield line, True
            continue
        yield line, fence is not None


def extract_links(text: str) -> list[tuple[str, str]]:
    """Return `(link_text, target)` pairs for non-image links outside code."""
    links: list[tuple[str, str]] = []
    for line, in_code in iter_lines_outside_code(text):
        if in_code:
            continue
        for bang, link_text, raw_target in MD_LINK_RE.findall(line):
            if bang:  # image
                continue
            links.append((link_text.strip(), clean_target(raw_target)))
    return links


def resolve_readme(target: str, base_dir: Path, repo_root: Path) -> Path | None:
    """Resolve a link target to a README.md path, or None if it isn't one."""
    if not target or is_external(target):
        return None
    if target.startswith("/"):
        path = (repo_root / target.lstrip("/")).resolve()
    else:
        path = (base_dir / target).resolve()
    if path.is_dir():
        candidate = path / "README.md"
        return candidate if candidate.is_file() else None
    if path.is_file() and path.name.lower() == "readme.md":
        return path
    return None


@dataclass
class Node:
    path: Path
    link_text: str
    content: str
    children: list["Node"] = field(default_factory=list)


def build_tree(readme: Path, repo_root: Path, visited: set[Path],
               link_text: str = "") -> Node:
    resolved = readme.resolve()
    text = resolved.read_text(encoding="utf-8")
    node = Node(path=resolved, link_text=link_text, content=text)
    for child_text, target in extract_links(text):
        child = resolve_readme(target, resolved.parent, repo_root)
        if child is None:
            continue
        child = child.resolve()
        if child in visited:
            continue
        visited.add(child)
        node.children.append(build_tree(child, repo_root, visited, child_text))
    return node


def strip_inline_md(text: str) -> str:
    """Reduce heading markup to plain text for display."""
    text = MD_LINK_RE.sub(lambda m: m.group(2), text)  # [t](u) -> t
    text = re.sub(r"[`*_]", "", text)
    return text.strip()


def is_module_heading(title: str) -> bool:
    return bool(MODULE_HEADING_RE.match(strip_inline_md(title)))


def get_course_title(text: str) -> str | None:
    """Return the first top-level (`#`) heading, if any."""
    for line, in_code in iter_lines_outside_code(text):
        if in_code:
            continue
        if m := HEADING_RE.match(line):
            if len(m.group(1)) == 1:
                return m.group(2).strip()
            return None
    return None


def extract_module_sections(text: str) -> list[tuple[str, str]]:
    """Return `(heading, body)` pairs for `## M<n>. ...` sections only."""
    sections: list[tuple[str, str]] = []
    current_title: str | None = None
    current_lines: list[str] = []

    for line, in_code in iter_lines_outside_code(text):
        if in_code:
            if current_title is not None:
                current_lines.append(line)
            continue

        match = HEADING_RE.match(line)
        if match and len(match.group(1)) == 2:
            if current_title is not None:
                sections.append((current_title, "\n".join(current_lines).strip()))
            title = match.group(2).strip()
            if is_module_heading(title):
                current_title = title
                current_lines = []
            else:
                current_title = None
                current_lines = []
        elif current_title is not None:
            current_lines.append(line)

    if current_title is not None:
        sections.append((current_title, "\n".join(current_lines).strip()))
    return sections


def render_enriched(node: Node, base_level: int, *, index_only: bool) -> str:
    parts: list[str] = []
    if not index_only:
        if title := get_course_title(node.content):
            parts.append(f"{'#' * base_level} {title}")
        for mod_title, mod_content in extract_module_sections(node.content):
            parts.append(f"{'#' * (base_level + 1)} {mod_title}")
            if mod_content:
                parts.append(mod_content)

    child_level = base_level if index_only else base_level + 1
    for child in node.children:
        parts.append(render_enriched(child, child_level, index_only=False))
    return "\n\n".join(p for p in parts if p)


def render_toc(node: Node, depth: int = 0, *, index_only: bool) -> str:
    lines: list[str] = []
    if not index_only:
        if title := get_course_title(node.content):
            indent = "  " * depth
            lines.append(f"{indent}- {strip_inline_md(title)}")
            for mod_title, _ in extract_module_sections(node.content):
                lines.append(f"{indent}  - {strip_inline_md(mod_title)}")

    child_depth = depth if index_only else depth + 1
    for child in node.children:
        child_toc = render_toc(child, child_depth, index_only=False)
        if child_toc:
            lines.append(child_toc)
    return "\n".join(lines)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("readme", type=Path, help="Path to the input README.md")
    parser.add_argument(
        "--enriched", action="store_true",
        help="Inline full content of every crawled README (default: ToC only).",
    )
    parser.add_argument(
        "--root", type=Path, default=None,
        help="Repository root for `/`-absolute links (default: auto-detect).",
    )
    parser.add_argument(
        "-o", "--output", type=Path, default=None,
        help="Write result to this file instead of stdout.",
    )
    args = parser.parse_args(argv)

    readme = args.readme.resolve()
    if not readme.is_file():
        print(f"error: not a file: {args.readme}", file=sys.stderr)
        return 1

    repo_root = (args.root.resolve() if args.root else find_repo_root(readme))

    tree = build_tree(readme, repo_root, visited={readme})
    result = (
        render_enriched(tree, base_level=1, index_only=True)
        if args.enriched
        else render_toc(tree, index_only=True)
    )
    result = result.rstrip("\n") + "\n"

    if args.output:
        args.output.write_text(result, encoding="utf-8")
        print(f"wrote {args.output}", file=sys.stderr)
    else:
        sys.stdout.write(result)
    return 0


if __name__ == "__main__":
    sys.exit(main())
