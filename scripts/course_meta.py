"""Load program metadata from metadata.yml and shared outline helpers."""

from __future__ import annotations

import re
from dataclasses import dataclass
from pathlib import Path

import yaml

# Outline files are Typst (`outline.typ`): `=` document title, `==` tracks,
# `=== N. Title` courses. Courses are keyed by title (Typst headings carry no
# link), unlike the README's Markdown `### N. [Title](path)` form.
DOC_TITLE_RE = re.compile(r"^=\s+(?P<title>.+?)\s*$")
COURSE_HEADING_RE = re.compile(r"^===\s+(?P<order>\d+)\.\s+(?P<title>.+?)\s*$")
TRACK_HEADING_RE = re.compile(r"^==\s+Track \d+:\s+(?P<name>.+?)\s*$")
PREREQUISITES_HEADING_RE = re.compile(r"^==\s+Pre-requisites\s*$")
HEADING_RE = re.compile(r"^=+\s")
MODULE_BULLET_RE = re.compile(r"^-\s+M\d+\.\s")
TYPST_DIRECTIVE_RE = re.compile(r"^\s*#[A-Za-z][\w.-]*\(")
REQUIRED_COURSE_FIELDS = ("title", "description", "time_estimate", "path", "order")


@dataclass(frozen=True)
class CourseMeta:
    title: str
    description: str
    time_estimate: str
    path: str
    track: str
    order: int


@dataclass(frozen=True)
class TrackMeta:
    name: str
    time_estimate: str | None
    courses: tuple[CourseMeta, ...]


@dataclass(frozen=True)
class ProgramMetadata:
    tracks: tuple[TrackMeta, ...]
    courses_by_path: dict[str, CourseMeta]

    @property
    def track_names(self) -> tuple[str, ...]:
        return tuple(track.name for track in self.tracks)

    @property
    def courses(self) -> tuple[CourseMeta, ...]:
        return tuple(self.courses_by_path[path] for path in sorted(self.courses_by_path))

    def outline_tracks(self) -> tuple[TrackMeta, ...]:
        """Tracks that appear in `outline.typ`."""
        return self.tracks

    def course_by_path(self, course_path: str) -> CourseMeta:
        normalized = normalize_course_path(course_path)
        try:
            return self.courses_by_path[normalized]
        except KeyError as exc:
            raise KeyError(f"no course metadata for path {course_path!r}") from exc

    def course_by_title(self, title: str) -> CourseMeta:
        index = {course.title: course for course in self.courses}
        try:
            return index[title.strip()]
        except KeyError as exc:
            raise KeyError(f"no course metadata for title {title!r}") from exc


def normalize_course_path(course_path: str) -> str:
    path = course_path.strip()
    if not path.startswith("/"):
        path = f"/{path}"
    if not path.endswith("/"):
        path = f"{path}/"
    return path


def _parse_course(entry: dict, track_name: str, *, source: str) -> CourseMeta:
    missing = [key for key in REQUIRED_COURSE_FIELDS if key not in entry]
    if missing:
        raise ValueError(f"{source}: missing required field(s): {', '.join(missing)}")

    order = entry["order"]
    if not isinstance(order, int) or order < 1:
        raise ValueError(f"{source}: order must be a 1-indexed integer")

    return CourseMeta(
        title=str(entry["title"]),
        description=str(entry["description"]),
        time_estimate=str(entry["time_estimate"]),
        path=normalize_course_path(str(entry["path"])),
        track=track_name,
        order=order,
    )


def load_program_metadata(metadata_path: Path) -> ProgramMetadata:
    data = yaml.safe_load(metadata_path.read_text(encoding="utf-8"))
    tracks: list[TrackMeta] = []
    courses_by_path: dict[str, CourseMeta] = {}

    for track_entry in data["tracks"]:
        track_name = track_entry["name"]
        track_courses: list[CourseMeta] = []
        seen_orders: set[int] = set()

        for course_entry in track_entry.get("courses", []):
            source = f"{metadata_path} ({track_name}, {course_entry.get('path', '?')})"
            course = _parse_course(course_entry, track_name, source=source)
            if course.order in seen_orders:
                raise ValueError(f"{source}: duplicate order {course.order} in track")
            seen_orders.add(course.order)

            if course.path in courses_by_path:
                raise ValueError(f"{source}: duplicate path {course.path}")
            courses_by_path[course.path] = course
            track_courses.append(course)

        tracks.append(
            TrackMeta(
                name=track_name,
                time_estimate=track_entry.get("time_estimate"),
                courses=tuple(sorted(track_courses, key=lambda c: c.order)),
            )
        )

    return ProgramMetadata(tracks=tuple(tracks), courses_by_path=courses_by_path)


def load_program_metadata_from_root(repo_root: Path) -> ProgramMetadata:
    return load_program_metadata(repo_root / "metadata.yml")


def courses_for_track(program: ProgramMetadata, track_name: str) -> list[CourseMeta]:
    for track in program.tracks:
        if track.name == track_name:
            return list(track.courses)
    raise KeyError(f"unknown track {track_name!r}")


def course_path_from_readme(readme_path: Path, repo_root: Path) -> str | None:
    """Map a course README path to its metadata path (e.g. `/courses/Foo/`)."""
    courses_root = (repo_root / "courses").resolve()
    readme = readme_path.resolve()
    try:
        rel = readme.parent.relative_to(courses_root)
    except ValueError:
        return None
    return normalize_course_path(f"/courses/{rel.as_posix()}/")


def course_readme_from_path(course_path: str, repo_root: Path) -> Path:
    """Resolve a course link path (e.g. `/courses/Foo/`) to its README.md."""
    rel = normalize_course_path(course_path).strip("/")
    path = (repo_root / rel).resolve()
    if path.is_dir():
        path = path / "README.md"
    if not path.is_file():
        raise FileNotFoundError(f"no README.md for course path {course_path!r}")
    return path


def render_course_heading(meta: CourseMeta) -> str:
    return f"=== {meta.order}. {meta.title}"


def render_course_section(meta: CourseMeta, modules: list[str]) -> str:
    """Render a full Typst course block for the outline."""
    parts = [render_course_heading(meta), "", meta.description]
    if modules:
        parts.append("")
        parts.extend(f"- {module}" for module in modules)
    parts.append("")
    parts.append(f"Time Estimate: {meta.time_estimate}.")
    return "\n".join(parts)


def parse_outline_track_name(line: str) -> str | None:
    """Return a track name from an outline `==` heading, if recognized."""
    if track_match := TRACK_HEADING_RE.match(line):
        return track_match.group("name").strip()
    if PREREQUISITES_HEADING_RE.match(line):
        return "Pre-requisites"
    return None


def strip_outline_title(text: str) -> str:
    """Drop the outline's own top-level `= ...` title and following blank lines."""
    lines = text.splitlines()
    body: list[str] = []
    skipped_title = False
    for line in lines:
        if not skipped_title:
            if DOC_TITLE_RE.match(line):
                skipped_title = True
            continue
        body.append(line)
    while body and not body[0].strip():
        body.pop(0)
    return "\n".join(body).strip("\n")


def _outline_course_titles(outline_text: str) -> set[str]:
    titles: set[str] = set()
    for line in outline_text.splitlines():
        if match := COURSE_HEADING_RE.match(line):
            titles.add(match.group("title").strip())
    return titles


def _track_section_bounds(
    lines: list[str], track_name: str
) -> tuple[int, int] | None:
    start: int | None = None
    for index, line in enumerate(lines):
        if parse_outline_track_name(line) == track_name:
            start = index
            break
    if start is None:
        return None

    end = len(lines)
    for index in range(start + 1, len(lines)):
        if parse_outline_track_name(lines[index]) is not None:
            end = index
            break
    return start, end


def ensure_outline_courses(outline_text: str, repo_root: Path) -> str:
    """Insert missing course headings from metadata.yml into track sections."""
    program = load_program_metadata_from_root(repo_root)
    lines = outline_text.splitlines()
    existing_titles = _outline_course_titles(outline_text)

    missing = [
        course for course in program.courses if course.title not in existing_titles
    ]
    if not missing:
        return outline_text

    for course in sorted(
        missing,
        key=lambda item: (program.track_names.index(item.track), item.order),
    ):
        bounds = _track_section_bounds(lines, course.track)
        if bounds is None:
            continue

        start, end = bounds
        insert_at = end
        for index in range(start + 1, end):
            if match := COURSE_HEADING_RE.match(lines[index]):
                if course.order < int(match.group("order")):
                    insert_at = index
                    break

        block = [render_course_heading(course), ""]
        if insert_at > 0 and lines[insert_at - 1].strip():
            block.insert(0, "")
        lines = [*lines[:insert_at], *block, *lines[insert_at:]]

    return "\n".join(lines).rstrip("\n") + "\n"


def validate_outline_tracks(outline_text: str, repo_root: Path) -> list[str]:
    """Return validation errors for track/order mismatches in the outline."""
    program = load_program_metadata_from_root(repo_root)
    errors: list[str] = []
    current_track: str | None = None
    known_tracks = {track.name for track in program.outline_tracks()}

    for line_no, line in enumerate(outline_text.splitlines(), start=1):
        if track_name := parse_outline_track_name(line):
            current_track = track_name
            if current_track not in known_tracks:
                errors.append(f"{line_no}: unknown outline track {current_track!r}")
            continue

        if not (course_match := COURSE_HEADING_RE.match(line)):
            continue

        title = course_match.group("title").strip()
        try:
            meta = program.course_by_title(title)
        except KeyError:
            errors.append(f"{line_no}: unknown course {title!r}")
            continue

        if current_track is None:
            errors.append(f"{line_no}: course heading outside a track section")
            continue
        if meta.track != current_track:
            errors.append(
                f"{line_no}: {meta.title!r} belongs to track {meta.track!r}, "
                f"not {current_track!r}"
            )
        if meta.order != int(course_match.group("order")):
            errors.append(
                f"{line_no}: {meta.title!r} order is {meta.order}, "
                f"heading shows {course_match.group('order')}"
            )

    return errors


def enrich_outline_body(outline_body: str, repo_root: Path) -> str:
    """Expand Typst course blocks with metadata heading, description, and time."""
    program = load_program_metadata_from_root(repo_root)
    lines = outline_body.splitlines()
    result: list[str] = []
    index = 0

    while index < len(lines):
        line = lines[index]
        match = COURSE_HEADING_RE.match(line)
        if not match:
            result.append(line)
            index += 1
            continue

        try:
            meta = program.course_by_title(match.group("title").strip())
        except KeyError:
            result.append(line)
            index += 1
            continue

        index += 1
        modules: list[str] = []
        while index < len(lines):
            current = lines[index]
            if HEADING_RE.match(current) or TYPST_DIRECTIVE_RE.match(current):
                break
            if MODULE_BULLET_RE.match(current):
                modules.append(re.sub(r"^-\s+", "", current).strip())
            index += 1

        result.append(render_course_section(meta, modules).rstrip("\n"))
        while index < len(lines) and lines[index].strip() == "":
            index += 1
        if index < len(lines):
            result.append("")

    return "\n".join(result).strip("\n")


def enrich_outline_file(outline_text: str, repo_root: Path) -> str:
    """Enrich all course blocks in an outline file, preserving its title line."""
    lines = outline_text.splitlines()
    if lines and DOC_TITLE_RE.match(lines[0]):
        title = lines[0]
        body = strip_outline_title(outline_text)
        enriched = enrich_outline_body(body, repo_root)
        return f"{title}\n\n{enriched}\n"

    return enrich_outline_body(outline_text, repo_root).rstrip("\n") + "\n"


def prepare_outline(outline: str, repo_root: Path) -> tuple[str, list[str]]:
    """Validate and enrich outline course blocks from metadata.yml."""
    outline = ensure_outline_courses(outline, repo_root)
    errors = validate_outline_tracks(outline, repo_root)
    if errors:
        return outline, errors
    return enrich_outline_file(outline, repo_root), []


def outline_typst_to_markdown(outline_text: str, repo_root: Path) -> str:
    """Convert an enriched Typst outline into Markdown for the README.

    Course headings gain a link to their course folder; the document title and
    Typst directives (e.g. ``#pagebreak()``) are dropped.
    """
    program = load_program_metadata_from_root(repo_root)
    result: list[str] = []

    for line in outline_text.splitlines():
        if DOC_TITLE_RE.match(line) or TYPST_DIRECTIVE_RE.match(line):
            continue
        if match := COURSE_HEADING_RE.match(line):
            order = match.group("order")
            title = match.group("title").strip()
            try:
                meta = program.course_by_title(title)
                result.append(f"### {order}. [{title}]({meta.path})")
            except KeyError:
                result.append(f"### {order}. {title}")
            continue
        if HEADING_RE.match(line):
            level = len(line) - len(line.lstrip("="))
            result.append(f"{'#' * level} {line[level:].strip()}")
            continue
        result.append(line)

    collapsed: list[str] = []
    for line in result:
        if not line.strip() and collapsed and not collapsed[-1].strip():
            continue
        collapsed.append(line)
    while collapsed and not collapsed[0].strip():
        collapsed.pop(0)
    while collapsed and not collapsed[-1].strip():
        collapsed.pop()
    return "\n".join(collapsed)
