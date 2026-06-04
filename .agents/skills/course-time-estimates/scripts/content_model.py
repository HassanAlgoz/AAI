"""Shared content analysis for course time-estimate scripts."""
from __future__ import annotations

import json
import math
import os
import re
import tomllib
from dataclasses import asdict, dataclass
from pathlib import Path

# --- Estimation parameters -------------------------------------------------
# The numbers below are tunable config, not code. They are read from the
# skill's own `config.toml` (kept next to SKILL.md so the skill is
# self-contained) and fall back to the defaults declared here when the file
# (or a key) is absent. Point the loader at another file with the
# COURSE_TIME_ESTIMATES_CONFIG env var.
#
# The skill root is one level up: scripts -> course-time-estimates.
_SKILL_ROOT = Path(__file__).resolve().parents[1]
_CONFIG_FILENAME = "config.toml"

_DEFAULTS: dict[str, dict[str, float]] = {
    "reading": {
        "setup_min": 3.0,
        "prose_wpm": 200.0,
        "code_sec_per_line": 8.6,
        "output_sec_per_line": 2.5,
        "image_sec": 18.0,
        "slide_sec": 105.0,
        "output_line_cap": 40,
    },
    "exercise": {
        "setup_min": 5.0,
        "prose_wpm": 200.0,
        "task_sec": 60.0,
    },
}


def _config_path() -> Path:
    override = os.environ.get("COURSE_TIME_ESTIMATES_CONFIG")
    if override:
        return Path(override).expanduser()
    return _SKILL_ROOT / _CONFIG_FILENAME


def load_config() -> dict[str, dict[str, float]]:
    """Return parameters, overlaying the skill's config.toml on the defaults."""
    cfg = {section: dict(values) for section, values in _DEFAULTS.items()}
    path = _config_path()
    if path.is_file():
        with path.open("rb") as fh:
            data = tomllib.load(fh)
        for section, values in data.items():
            if section in cfg and isinstance(values, dict):
                cfg[section].update(values)
    return cfg


_CONFIG = load_config()
_READING = _CONFIG["reading"]
_EXERCISE = _CONFIG["exercise"]

SETUP_MIN = float(_READING["setup_min"])
PROSE_WPM = float(_READING["prose_wpm"])
CODE_SEC_PER_LINE = float(_READING["code_sec_per_line"])
OUTPUT_SEC_PER_LINE = float(_READING["output_sec_per_line"])
IMAGE_SEC = float(_READING["image_sec"])
SLIDE_SEC = float(_READING["slide_sec"])
OUTPUT_LINE_CAP = int(_READING["output_line_cap"])

EXSET_SETUP_MIN = float(_EXERCISE["setup_min"])
EXSET_PROSE_WPM = float(_EXERCISE["prose_wpm"])
TASK_SEC = float(_EXERCISE["task_sec"])

NOTEBOOK_SUFFIXES = {".ipynb"}
TEXT_SUFFIXES = {".md", ".txt"}
TYPST_SUFFIXES = {".typ"}
COUNTABLE_SUFFIXES = NOTEBOOK_SUFFIXES | TEXT_SUFFIXES | TYPST_SUFFIXES

FENCE_RE = re.compile(
    r"^[ \t]*(`{3,}|~{3,}).*?\n(.*?)^[ \t]*\1[ \t]*$",
    re.DOTALL | re.MULTILINE,
)
LINK_RE = re.compile(r"\[(?P<text>[^\]]+)\]\((?P<target>[^)]+)\)")

# In-lesson exercise / "try it" sections embedded inside a lecture's markdown.
# A section starts at an ATX heading whose title matches EXERCISE_HEADING_RE and
# runs until the next heading of the same or higher level (or EOF). These are
# priced as hands-on exercises, not reading, and excluded from lecture prose.
ATX_HEADING_RE = re.compile(r"^(#{1,6})[ \t]+(.*?)[ \t]*#*[ \t]*$", re.MULTILINE)
EXERCISE_HEADING_RE = re.compile(
    r"(?i)\b("
    r"exercises?|try\s*it|try\s*this|try:|hands[\s-]*on|challenge|"
    r"your\s+turn|practice|do\s+it\s+yourself|workshop|lab\s*exercise"
    r")\b"
)
STEP_HEADING_RE = re.compile(r"(?im)^[ \t]*#{1,6}[ \t]*step\b")
NUMBERED_ITEM_RE = re.compile(r"(?m)^[ \t]*\d+[.)][ \t]+\S")

# Typst slide decks (Touying): a frame is the title slide, each heading
# (`=` / `==`), and each explicit `#pagebreak()`. Reveal steps (`#pause`,
# `#colbreak`) stay on the same frame and are not counted as new slides.
TYPST_HEADING_RE = re.compile(r"^\s*=+\s+\S", re.MULTILINE)
TYPST_TITLE_SLIDE_RE = re.compile(r"#title-slide\(\)")
TYPST_PAGEBREAK_RE = re.compile(r"#pagebreak\(\)")
TYPST_IMAGE_RE = re.compile(r"\bimage\s*\(")
TYPST_MATH_RE = re.compile(r"\$[^$]*\$", re.DOTALL)
TYPST_STRING_RE = re.compile(r'"[^"]*"')
TYPST_FUNC_RE = re.compile(r"#[A-Za-z][\w-]*")
TYPST_MARKUP_RE = re.compile(r"[#*_=+\-\[\](){}|<>]")


@dataclass
class Features:
    prose_words: int = 0
    code_lines: int = 0
    output_lines: int = 0
    images: int = 0
    slides: int = 0

    def seconds(self, **rates) -> float:
        setup_min = rates.get("setup_min", SETUP_MIN)
        prose_wpm = rates.get("prose_wpm", PROSE_WPM)
        code_sec = rates.get("code_sec", CODE_SEC_PER_LINE)
        out_sec = rates.get("out_sec", OUTPUT_SEC_PER_LINE)
        img_sec = rates.get("img_sec", IMAGE_SEC)
        slide_sec = rates.get("slide_sec", SLIDE_SEC)
        return (
            setup_min * 60.0
            + self.prose_words / prose_wpm * 60.0
            + self.code_lines * code_sec
            + self.output_lines * out_sec
            + self.images * img_sec
            + self.slides * slide_sec
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


def analyze_typst_text(text: str) -> Features:
    """Treat a Typst (Touying) source as a slide deck.

    Frames = title slide + headings + explicit page breaks. Prose is the
    readable text left after dropping the import/config preamble and
    stripping markup, function calls, math, and quoted strings (paths/URLs).
    """
    f = Features()
    f.images = len(TYPST_IMAGE_RE.findall(text))
    f.slides = (
        len(TYPST_TITLE_SLIDE_RE.findall(text))
        + len(TYPST_HEADING_RE.findall(text))
        + len(TYPST_PAGEBREAK_RE.findall(text))
    )

    first_heading = TYPST_HEADING_RE.search(text)
    body = text[first_heading.start():] if first_heading else text
    body = TYPST_MATH_RE.sub(" ", body)
    body = TYPST_STRING_RE.sub(" ", body)
    body = TYPST_FUNC_RE.sub(" ", body)
    body = TYPST_MARKUP_RE.sub(" ", body)
    f.prose_words = len(body.split())
    return f


def analyze_path(path: Path) -> Features:
    text = path.read_text(encoding="utf-8")
    if path.suffix in NOTEBOOK_SUFFIXES:
        return analyze_notebook_text(text)
    if path.suffix in TYPST_SUFFIXES:
        return analyze_typst_text(text)
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
