#!/usr/bin/env python3
"""Download the courses/ folder from the B5 GitHub repo.

Fetches notebooks, assets, and exercises without Typst (.typ) source files,
plus the repo's top-level README.md as an overview.
No third-party dependencies — stdlib only.

Creates an `AAI/` folder containing `README.md` and the `courses/` folder.

Usage:
    python download_courses.py
    python download_courses.py --dest ./my-folder
    python download_courses.py --ref v1.0
"""

from __future__ import annotations

import argparse
import io
import sys
import tarfile
import urllib.error
import urllib.request
from pathlib import Path

API = "https://api.github.com/repos/{repo}/tarball/{ref}"
DEFAULT_REPO = "HassanAlgoz/B5"
DEFAULT_REF = "main"
DEFAULT_DEST = "AAI"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Download the courses/ folder from the B5 GitHub repo "
            "(notebooks, assets, exercises; excludes .typ source files)."
        ),
    )
    parser.add_argument(
        "--repo",
        default=DEFAULT_REPO,
        help=f"GitHub repository in owner/name form (default: {DEFAULT_REPO})",
    )
    parser.add_argument(
        "--ref",
        default=DEFAULT_REF,
        help=f"Branch, tag, or commit SHA (default: {DEFAULT_REF})",
    )
    parser.add_argument(
        "--dest",
        type=Path,
        default=Path(DEFAULT_DEST),
        help=f"Output directory (default: {DEFAULT_DEST})",
    )
    return parser.parse_args()


def download_tarball(repo: str, ref: str) -> bytes:
    url = API.format(repo=repo, ref=ref)
    req = urllib.request.Request(url, headers={"User-Agent": "b5-course-downloader"})
    try:
        with urllib.request.urlopen(req) as resp:
            return resp.read()
    except urllib.error.HTTPError as exc:
        raise SystemExit(f"Failed to download {url}: HTTP {exc.code} {exc.reason}") from exc
    except urllib.error.URLError as exc:
        raise SystemExit(f"Failed to download {url}: {exc.reason}") from exc


def _target_path(rel: str, dest: Path) -> Path | None:
    """Map a tarball-relative path to its output path, or None to skip it.

    Keeps the repo's top-level `README.md` and everything under `courses/`
    (excluding `.typ` sources), preserving the `courses/` prefix so the
    bundle ends up as `dest/README.md` plus `dest/courses/...`.
    """
    if rel == "README.md":
        rel_out = "README.md"
    elif rel.startswith("courses/") and not rel.endswith(".typ"):
        rel_out = rel
    else:
        return None

    if not rel_out or ".." in Path(rel_out).parts:
        return None
    return dest / rel_out


def extract_courses(blob: bytes, dest: Path) -> int:
    count = 0
    dest_resolved = dest.resolve()
    with tarfile.open(fileobj=io.BytesIO(blob), mode="r:gz") as tar:
        for member in tar.getmembers():
            if not member.isfile():
                continue

            # Tarball entries look like "HassanAlgoz-B5-<sha>/courses/..."; drop the top dir.
            _, _, rel = member.name.partition("/")
            out = _target_path(rel, dest)
            if out is None:
                continue

            out = out.resolve()
            if out != dest_resolved and dest_resolved not in out.parents:
                raise SystemExit(f"Refusing to write outside destination: {out}")

            out.parent.mkdir(parents=True, exist_ok=True)
            src = tar.extractfile(member)
            if src is None:
                continue
            out.write_bytes(src.read())
            count += 1
    return count


def main() -> int:
    args = parse_args()
    print(f"Downloading courses/ from {args.repo}@{args.ref} ...")
    blob = download_tarball(args.repo, args.ref)
    count = extract_courses(blob, args.dest)
    if count == 0:
        raise SystemExit(
            f"No files extracted from {args.repo}@{args.ref}. "
            "Does that ref include a courses/ folder and a README.md?"
        )
    print(f"Downloaded {count} files to {args.dest.resolve()}/")
    return 0


if __name__ == "__main__":
    sys.exit(main())
