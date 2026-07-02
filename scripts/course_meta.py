"""Load program metadata from metadata.yml and shared outline helpers."""

from __future__ import annotations

import re
from dataclasses import dataclass
from pathlib import Path

import yaml

COURSE_H3_RE = re.compile(
    r"^### (\d+)\.\s+(?:\[[^\]]+\]\((?P<path>[^)]+)\)|(?P<plain>.+))\s*$"
)
TRACK_HEADING_RE = re.compile(r"^## Track \d+:\s+(.+)$")
MODULE_BULLET_RE = re.compile(r"^- M\d+\.\s")
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
        """Tracks that appear in `outline.md` (everything except Pre-requisites)."""
        return tuple(
            track for track in self.tracks if track.name != "Pre-requisites"
        )

    def course_by_path(self, course_path: str) -> CourseMeta:
        normalized = normalize_course_path(course_path)
        try:
            return self.courses_by_path[normalized]
        except KeyError as exc:
            raise KeyError(f"no course metadata for path {course_path!r}") from exc


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
    return f"### {meta.order}. [{meta.title}]({meta.path})"


def render_course_section(meta: CourseMeta, modules: list[str]) -> str:
    """Render a full course block for README output."""
    lines = [
        render_course_heading(meta),
        "",
        meta.description,
        "",
        *[f"- {module}" for module in modules],
        "",
        f"Time Estimate: {meta.time_estimate}.",
    ]
    return "\n".join(lines)


def render_track_heading(index: int, track: TrackMeta) -> list[str]:
    lines = [f"## Track {index}: {track.name}", ""]
    if track.time_estimate:
        lines.append(f"Time Estimate: {track.time_estimate}.")
        lines.append("")
    return lines


def strip_outline_title(text: str) -> str:
    """Drop the outline's own top-level `# ...` title and following blank lines."""
    lines = text.splitlines()
    body: list[str] = []
    skipped_title = False
    for line in lines:
        if not skipped_title:
            if line.startswith("# "):
                skipped_title = True
            continue
        body.append(line)
    while body and not body[0].strip():
        body.pop(0)
    return "\n".join(body).strip("\n")


def validate_outline_tracks(outline_text: str, repo_root: Path) -> list[str]:
    """Return validation errors for track/order mismatches in the outline."""
    program = load_program_metadata_from_root(repo_root)
    errors: list[str] = []
    current_track: str | None = None

    for line_no, line in enumerate(outline_text.splitlines(), start=1):
        if track_match := TRACK_HEADING_RE.match(line):
            current_track = track_match.group(1).strip()
            if current_track not in {track.name for track in program.outline_tracks()}:
                errors.append(f"{line_no}: unknown outline track {current_track!r}")
            continue

        if not (course_match := COURSE_H3_RE.match(line)):
            continue

        course_path = course_match.group("path")
        if not course_path:
            errors.append(f"{line_no}: course heading missing link path")
            continue

        meta = program.course_by_path(course_path)

        if current_track is None:
            errors.append(f"{line_no}: course heading outside a track section")
            continue
        if meta.track != current_track:
            errors.append(
                f"{line_no}: {meta.path} belongs to track {meta.track!r}, "
                f"not {current_track!r}"
            )
        if meta.order != int(course_match.group(1)):
            errors.append(
                f"{line_no}: {meta.path} order is {meta.order}, "
                f"heading shows {course_match.group(1)}"
            )

    return errors


def sync_outline_course_headings(outline_text: str, repo_root: Path) -> str:
    """Replace `### N. ...` course headings using metadata.yml."""
    program = load_program_metadata_from_root(repo_root)
    lines = outline_text.splitlines()
    result: list[str] = []

    for line in lines:
        match = COURSE_H3_RE.match(line)
        if not match:
            result.append(line)
            continue

        course_path = match.group("path")
        if not course_path:
            result.append(line)
            continue

        meta = program.course_by_path(course_path)
        result.append(render_course_heading(meta))

    return "\n".join(result).rstrip("\n") + "\n"


def enrich_outline_body(outline_body: str, repo_root: Path) -> str:
    """Expand course blocks with metadata heading, description, and time."""
    program = load_program_metadata_from_root(repo_root)
    lines = outline_body.splitlines()
    result: list[str] = []
    index = 0

    while index < len(lines):
        line = lines[index]
        match = COURSE_H3_RE.match(line)
        if not match or not match.group("path"):
            result.append(line)
            index += 1
            continue

        meta = program.course_by_path(match.group("path"))

        index += 1
        modules: list[str] = []
        while index < len(lines):
            current = lines[index]
            if current.startswith("## ") or COURSE_H3_RE.match(current):
                break
            if MODULE_BULLET_RE.match(current):
                modules.append(current.removeprefix("- ").strip())
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
    if lines and lines[0].startswith("# "):
        title = lines[0]
        body = strip_outline_title(outline_text)
        enriched = enrich_outline_body(body, repo_root)
        return f"{title}\n\n{enriched}\n"

    return enrich_outline_body(outline_text, repo_root).rstrip("\n") + "\n"


def prepare_outline(outline: str, repo_root: Path) -> tuple[str, list[str]]:
    """Validate and enrich outline course blocks from metadata.yml."""
    errors = validate_outline_tracks(outline, repo_root)
    if errors:
        return outline, errors
    return enrich_outline_file(outline, repo_root), []
