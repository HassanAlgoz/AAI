#!/usr/bin/env python3
"""
A harmless "surprise video" demo for the curl lesson.

This script is intentionally simple and benign: it downloads a small Creative
Commons video from Wikimedia Commons, stores it in the system temp directory,
and opens it with the user's default browser/media player.

The teaching point is not that this script is dangerous. The teaching point is
that `curl ... | python3` or `curl ... | python` runs whatever code came from
the internet before the learner has inspected it.
"""

from __future__ import annotations

import os
import subprocess
import sys
import tempfile
import urllib.error
import urllib.request
import webbrowser
from pathlib import Path


# "Me at the zoo" is a short WebM file hosted on Wikimedia Commons.
# License: Creative Commons Attribution 3.0 Unported.
# File page: https://commons.wikimedia.org/wiki/File:Me_at_the_zoo.webm
VIDEO_URL = "https://commons.wikimedia.org/wiki/Special:FilePath/Me_at_the_zoo.webm"
VIDEO_NAME = "curl-demo-surprise-video.webm"


def should_skip_opening() -> bool:
    """Allow tests to verify the download without launching a player/browser."""
    return "--no-open" in sys.argv


def download_video(destination: Path) -> None:
    """Download the demo video once, then reuse the cached copy."""
    if destination.exists() and destination.stat().st_size > 0:
        print(f"Using cached video: {destination}")
        return

    print("Downloading a small Creative Commons video from Wikimedia Commons...")

    # urllib is part of Python's standard library, so this works without pip.
    # Wikimedia blocks anonymous clients with no User-Agent header.
    request = urllib.request.Request(
        VIDEO_URL,
        headers={"User-Agent": "B5-curl-lesson-demo/1.0 (educational script)"},
    )
    with urllib.request.urlopen(request, timeout=20) as response:
        destination.write_bytes(response.read())

    print(f"Saved video to: {destination}")


def open_video(path: Path) -> None:
    """Open the video using a cross-platform standard-library path first."""
    video_uri = path.resolve().as_uri()

    # A browser is often the most reliable cross-platform way to play WebM.
    if webbrowser.open(video_uri):
        print("Opened the video in your default browser.")
        return

    # If Python cannot find a browser, try common OS-level file open commands.
    if sys.platform.startswith("win"):
        os.startfile(path)  # type: ignore[attr-defined]
    elif sys.platform == "darwin":
        subprocess.run(["open", str(path)], check=False)
    else:
        subprocess.run(["xdg-open", str(path)], check=False)

    print("Asked the operating system to open the video.")


def main() -> int:
    temp_dir = Path(tempfile.gettempdir())
    video_path = temp_dir / VIDEO_NAME

    print("Surprise! This is why we inspect scripts before running them.")

    try:
        download_video(video_path)
        if should_skip_opening():
            print("Downloaded video successfully. Skipping playback for this run.")
        else:
            open_video(video_path)
    except (OSError, urllib.error.URLError) as error:
        print(f"Could not download or open the video: {error}", file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
