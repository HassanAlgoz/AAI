# Python Environments with `uv`

By the end of this lesson, you'll understand why Python projects need isolated environments, how `pip` and PyPI fit in, and how to install and use [`uv`](https://docs.astral.sh/uv/) — a modern tool that handles packages, projects, scripts, tools, and Python versions from the terminal.

---

## 1) The Problem: Packages, Versions, and "Works on My Machine"

When you write Python, you rarely use only the built-in language. You pull in **packages** — reusable libraries like `requests` (for HTTP), `pandas` (for data), or `ruff` (for linting).

### What is `pip`?

**`pip`** is Python's default **package installer**. You run it from the terminal:

```bash
pip install requests
```

It downloads a package and installs it so your code can `import requests`.

### What is PyPI?

**PyPI** (the [Python Package Index](https://pypi.org/)) is the public registry where most Python packages live. Think of it as an app store for Python libraries.

```text
you -> pip -> PyPI -> package lands on your machine
```

When you `pip install requests`, `pip` finds `requests` on PyPI, downloads it, and installs it (along with any dependencies that package needs).

> **Beginner takeaway:** `pip` is the installer; PyPI is the catalog it reads from.

### What is an environment?

An **environment** (usually a **virtual environment**, or **venv**) is an isolated folder of Python + packages for one project.

Without isolation, every project shares one global Python. That leads to **dependency hell**:

- Project A needs `pandas 1.x`
- Project B needs `pandas 2.x`
- You upgrade for B and break A

Or the classic: *"It works on my machine"* — your teammate has different packages installed globally, so the same script fails on their laptop.

```text
WITHOUT environments (one shared Python):

  +---------------------------+
  |  Global Python            |
  |  pandas 2.x               |
  |  django 4.x               |
  |  ??? conflicting stuff    |
  +---------------------------+
         ^           ^
         |           |
    Project A    Project B   (both fight over the same packages)


WITH environments (one venv per project):

  +----------------+     +----------------+
  | Project A      |     | Project B      |
  | .venv/         |     | .venv/         |
  | pandas 1.x     |     | pandas 2.x     |
  | django 3.x     |     | flask 3.x      |
  +----------------+     +----------------+
        isolated              isolated
```

**Where environments matter:**

- Every serious Python project (local dev, CI, servers, cloud VMs)
- When teammates need the **same** dependency versions
- When you switch between courses, clients, or side projects on one machine

### Tools that tried to solve this (and the friction)

Developers have juggled many tools:

| Tool | Role | Friction |
|---|---|---|
| `venv` + `pip` | Built-in isolation + installer | Manual setup; no lockfile by default |
| `virtualenv` | Older venv alternative | Extra tool to learn |
| `pyenv` | Install/switch Python versions | Another tool; doesn't manage packages |
| `pip-tools` | Lock dependency versions | Separate from venv workflow |
| `poetry` | Projects + lockfiles | Heavier; its own workflow |
| `conda` | Packages + environments (great for data science) | Large installs; different ecosystem |

Each solves part of the puzzle. None was a single, fast, beginner-friendly default — until **`uv`**.

---

## 2) Why `uv` Stands Out

[`uv`](https://docs.astral.sh/uv/) is an extremely fast Python package and project manager, written in Rust, backed by [Astral](https://astral.sh/) — the same team behind [**Ruff**](https://docs.astral.sh/ruff/) (the linter you'll use in the next lesson).

Highlights from the [official docs](https://docs.astral.sh/uv/):

- **One tool** to replace `pip`, `pip-tools`, `pipx`, `poetry`, `pyenv`, `twine`, `virtualenv`, and more
- **10–100× faster** than `pip` for installs and resolution
- **Project management** with a universal lockfile (`uv.lock`)
- **Scripts** with inline dependency metadata
- **Tools** (like `pipx`) via `uvx` / `uv tool install`
- **Python versions** — install and pin 3.10, 3.11, 3.12 without a separate version manager
- **Disk-efficient** global cache (shared packages across projects)
- **pip-compatible** interface (`uv pip ...`) for existing workflows

Well-known projects and ecosystems have adopted or integrated `uv` — including [FastAPI](https://fastapi.tiangolo.com/), and first-class guides for [Docker](https://docs.astral.sh/uv/guides/integration/docker/), [GitHub Actions](https://docs.astral.sh/uv/guides/integration/github/), and [PyTorch](https://docs.astral.sh/uv/guides/integration/pytorch/).

For a beginner who barely knows `pip`, `uv` is the shortest path to a professional setup: one command runner, one lockfile, one mental model.

---

## 3) Install `uv`

Official installer ([installation docs](https://docs.astral.sh/uv/#installation)):

```bash
# Linux/macOS
curl -LsSf https://astral.sh/uv/install.sh | sh
```

```powershell
# Windows (PowerShell)
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

> **Safety note:** This is the same pattern as `curl | bash` — convenient, but you are trusting the host. The [curl lesson](06_curl.md) covers why inspecting scripts before running them matters. Here, the source is Astral's official domain (`astral.sh`).

**Alternatives:** `pip install uv`, Homebrew (`brew install uv`), and others — see the [full installation page](https://docs.astral.sh/uv/getting-started/installation/).

Verify the install:

```bash
uv --version
```

---

## 4) Projects: Dependencies, Lockfiles, and `.venv`

`uv` can manage a whole project — similar to Poetry or Rye ([projects docs](https://docs.astral.sh/uv/#projects)).

```bash
uv init example
cd example
uv add ruff
uv run ruff check
uv lock
uv sync
```

What each step does:

| Command | What it does |
|---|---|
| `uv init example` | Creates a new project folder with `pyproject.toml` |
| `uv add ruff` | Adds `ruff` as a dependency; creates `.venv/` if needed |
| `uv run ruff check` | Runs `ruff` **inside** the project's environment |
| `uv lock` | Writes exact resolved versions to `uv.lock` |
| `uv sync` | Installs everything in the lockfile into `.venv/` |

**Key files:**

- **`pyproject.toml`** — declares what your project needs (human-edited)
- **`uv.lock`** — exact versions for reproducible installs (machine-generated)
- **`.venv/`** — the isolated environment for this project only

```text
you -> uv -> PyPI -> .venv/ (this project only)
```

Commit `pyproject.toml` and `uv.lock` to Git so teammates and CI get the same environment.

---

## 5) Which Python Am I Running?

Confusion about *which* Python runs your code causes more bugs than you'd expect. Check it explicitly.

### From the command line

```bash
# Linux/macOS
which python
python --version
```

```powershell
# Windows (PowerShell)
where.exe python
Get-Command python
python --version
```

When you're inside a project managed by `uv`:

```bash
uv run python -c "import sys; print(sys.executable)"
```

That prints the Python inside the project's `.venv/`, not a random global install.

### From Python code

```python
import sys

print(sys.executable)  # full path to the running interpreter
print(sys.version)       # version string, e.g. "3.12.4 ..."
```

### How activation changes the path

If you **activate** a venv (`source .venv/bin/activate` on Linux/macOS, or `.venv\Scripts\Activate.ps1` on Windows), `python` and `pip` point into `.venv/` instead of system Python.

With `uv`, you often **don't need to activate** — `uv run ...` runs commands in the right environment automatically.

```text
Global Python:     /usr/bin/python3
Project .venv:     /home/you/example/.venv/bin/python
After activate:    `python` -> project .venv
With uv run:       same, without manual activation
```

---

## 6) Scripts: One File, Its Own Dependencies

For small scripts, you don't need a full project. `uv` supports [inline script metadata](https://docs.astral.sh/uv/#scripts):

```bash
echo 'import requests; print(requests.get("https://astral.sh"))' > example.py
uv add --script example.py requests
uv run example.py
```

`uv add --script` embeds dependency info in the file. `uv run example.py` creates a temporary environment, installs what's needed, and runs the script.

Useful for one-off utilities, homework scripts, or automation you don't want to turn into a full package.

---

## 7) Tools: `uvx` and `uv tool install`

Python packages often ship **command-line tools** (`ruff`, `black`, `httpie`, …). Running them without polluting your global Python is what **`pipx`** solved. `uv` has the same idea ([tools docs](https://docs.astral.sh/uv/#tools)).

**Run once in an ephemeral environment** (`uvx` is short for `uv tool run`):

```bash
uvx pycowsay 'hello world!'
```

**Install a tool globally** (available on your PATH):

```bash
uv tool install ruff
ruff --version
```

Compare:

| Goal | Old habit | `uv` way |
|---|---|---|
| Try a tool once | `pip install ...` (pollutes global) | `uvx toolname` |
| Keep a CLI tool | `pipx install ...` | `uv tool install ...` |

---

## 8) Python Versions

Different projects need different Python versions. `uv` can install and pin them ([python versions docs](https://docs.astral.sh/uv/#python-versions)) — no separate `pyenv` required.

**Install several versions:**

```bash
uv python install 3.10 3.11 3.12
```

**Create a venv with a specific version:**

```bash
uv venv --python 3.12
```

**Pin the version for a directory** (writes `.python-version`):

```bash
uv python pin 3.11
```

```text
Multiple projects, different Pythons:

  ~/course-a/          ~/course-b/
  .python-version      .python-version
  3.10                 3.12
  .venv/               .venv/
  (older libs)         (newer syntax)
```

---

## 9) The `pip` Interface: Drop-In Speedup

Already have a `requirements.txt` workflow? `uv` offers a [pip-compatible interface](https://docs.astral.sh/uv/#the-pip-interface) — same commands you know, much faster.

**Compile** a lock file from loose requirements:

```bash
uv pip compile requirements.in \
  --universal \
  --output-file requirements.txt
```

**Create a virtual environment:**

```bash
uv venv
# Activate: source .venv/bin/activate  (Linux/macOS)
#           .venv\Scripts\Activate.ps1  (Windows)
```

**Install exactly what's locked:**

```bash
uv pip sync requirements.txt
```

You can migrate gradually: keep `requirements.txt`, swap `pip` for `uv pip`, and move to full `uv` projects when ready.

---

## 10) Recap

You learned:

- **`pip`** installs packages; **PyPI** is where they live
- **Environments** isolate dependencies per project and fix "works on my machine"
- Older tools (`venv`, `pyenv`, `poetry`, `conda`, …) each solve part of the problem
- **`uv`** unifies packages, projects, scripts, tools, and Python versions — fast, from one CLI
- **Projects:** `uv init`, `uv add`, `uv run`, `uv lock`, `uv sync`
- **Check your Python:** `which`/`where`, `python --version`, or `sys.executable` in code
- **Scripts:** `uv add --script` + `uv run`
- **Tools:** `uvx` (try once) and `uv tool install` (keep forever)
- **Python versions:** `uv python install`, `uv venv --python`, `uv python pin`
- **Legacy workflows:** `uv pip compile`, `uv venv`, `uv pip sync`

Next up: [Command Runners](05_command_runners.md) — where you'll wire tools like `ruff` into short, memorable project commands with `just`.
