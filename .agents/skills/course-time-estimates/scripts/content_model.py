"""Shared content analysis for course time-estimate scripts."""
from __future__ import annotations

import json
import math
import re
from dataclasses import asdict, dataclass
from pathlib import Path

SETUP_MIN = 3.0
PROSE_WPM = 200.0
CODE_SEC_PER_LINE = 8.6
OUTPUT_SEC_PER_LINE = 2.5
IMAGE_SEC = 18.0
OUTPUT_LINE_CAP = 40

NOTEBOOK_SUFFIXES = {".ipynb"}
TEXT_SUFFIXES = {".md", ".txt"}
COUNTABLE_SUFFIXES = NOTEBOOK_SUFFIXES | TEXT_SUFFIXES

FENCE_RE = re.compile(
    r"^[ \t]*(`{3,}|~{3,}).*?\n(.*?)^[ \t]*\1[ \t]*$",
    re.DOTALL | re.MULTILINE,
)
LINK_RE = re.compile(r"\[(?P<text>[^\]]+)\]\((?P<target>[^)]+)\)")


@dataclass
class Features:
    prose_words: int = 0
    code_lines: int = 0
    output_lines: int = 0
    images: int = 0

    def seconds(self, **rates) -> float:
        setup_min = rates.get("setup_min", SETUP_MIN)
        prose_wpm = rates.get("prose_wpm", PROSE_WPM)
        code_sec = rates.get("code_sec", CODE_SEC_PER_LINE)
        out_sec = rates.get("out_sec", OUTPUT_SEC_PER_LINE)
        img_sec = rates.get("img_sec", IMAGE_SEC)
        return (
            setup_min * 60.0
            + self.prose_words / prose_wpm * 60.0
            + self.code_lines * code_sec
            + self.output_lines * out_sec
            + self.images * img_sec
        )

    def to_dict(self) -> dict:
        return asdict(self)


def _nonblank_lines(text: str) -> int:
    return sum(1 for line in text.split("\n") if line.strip())


def analyze_notebook_text(text: str) -> Features:
    nb = json.loads(text)
    f = Features()
    for cell in nb.get("cells", []):
        source = cell.get("source", "")
        if isinstance(source, list):
            source = "".join(source)
        cell_type = cell.get("cell_type")
        if cell_type == "markdown":
            f.prose_words += len(source.split())
        elif cell_type == "code":
            f.code_lines += _nonblank_lines(source)
            for out in cell.get("outputs", []):
                data = out.get("data", {})
                if "image/png" in data or "image/jpeg" in data:
                    f.images += 1
                text_out = out.get("text") or data.get("text/plain") or ""
                if isinstance(text_out, list):
                    text_out = "".join(text_out)
                f.output_lines += min(OUTPUT_LINE_CAP, _nonblank_lines(text_out))
    return f


def analyze_markdown_text(text: str) -> Features:
    f = Features()

    def strip(match: re.Match) -> str:
        f.code_lines += _nonblank_lines(match.group(2))
        return "\n"

    prose = FENCE_RE.sub(strip, text)
    f.prose_words += len(prose.split())
    return f


def analyze_path(path: Path) -> Features:
    text = path.read_text(encoding="utf-8")
    if path.suffix in NOTEBOOK_SUFFIXES:
        return analyze_notebook_text(text)
    return analyze_markdown_text(text)


def estimate_minutes(features: Features, **rates) -> int:
    seconds = features.seconds(**rates)
    if seconds <= 0:
        return 0
    return max(1, math.ceil(seconds / 60.0))


def is_countable_link(target: str) -> bool:
    if "://" in target or target.startswith(("http:", "https:", "mailto:")):
        return False
    path_part = target.split("#", 1)[0].split("?", 1)[0]
    return Path(path_part).suffix in COUNTABLE_SUFFIXES


def resolve_link_target(readme: Path, target: str) -> Path | None:
    rel = target.split("#", 1)[0].split("?", 1)[0]
    resolved = (readme.parent / rel).resolve()
    return resolved if resolved.exists() else None


def _is_exercise_target(target: str, resolved: Path) -> bool:
    t = target.lower()
    if "exset" in t or "/ex/" in t:
        return True
    return any(part.startswith("exset") for part in resolved.parts)


def discover_lesson_links(readme: Path) -> list[tuple[str, str, Path]]:
    """Return (link_text, target, resolved_path) for local lesson files."""
    found: list[tuple[str, str, Path]] = []
    for match in LINK_RE.finditer(readme.read_text(encoding="utf-8")):
        target = match.group("target")
        if not is_countable_link(target):
            continue
        resolved = resolve_link_target(readme, target)
        if resolved is None or not resolved.is_file():
            continue
        if _is_exercise_target(target, resolved):
            continue
        found.append((match.group("text"), target, resolved))
    return found


def discover_exercise_links(readme: Path) -> list[tuple[str, str, Path]]:
    """Return exercise-set links (directories or exercise markdown files)."""
    found: list[tuple[str, str, Path]] = []
    for match in LINK_RE.finditer(readme.read_text(encoding="utf-8")):
        target = match.group("target")
        if "://" in target:
            continue
        resolved = resolve_link_target(readme, target)
        if resolved is None:
            continue
        label = match.group("text")
        if _is_exercise_target(target, resolved) or re.search(r"\bEx\d", label):
            found.append((label, target, resolved))
    return found
