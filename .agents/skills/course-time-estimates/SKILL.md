---
name: course-time-estimates
description: Estimate and apply hands-on time annotations for bootcamp courses using report-only scripts (reading + exercises), then edit README files as the agent. Use when updating course README.md time estimates, estimating lesson or exercise duration, rolling up totals to the root README.md, or when the user mentions reading time, exercise time, or course duration estimates.
---

# Course Time Estimates

Scripts compute **deterministic numbers only**. The **agent edits markdown** — never use `--annotate` or regex rewrites on README files.

## Scripts

Run from repo root (adjust `python3` path as needed):

```bash
SKILL=.agents/skills/course-time-estimates/scripts

# Step 1 — lessons (linked .ipynb / .md / .txt in course README)
python3 $SKILL/estimate_reading_time.py --course courses/Data_Wrangling
python3 $SKILL/estimate_reading_time.py --course courses/Data_Wrangling --json

# Step 2 — exercise sets (exset_* dirs or Ex* links)
python3 $SKILL/estimate_exercise_time.py --course courses/Data_Wrangling
python3 $SKILL/estimate_exercise_time.py --course courses/Data_Wrangling --json

# Scoped to one lesson or one exset
python3 $SKILL/estimate_reading_time.py courses/Data_Wrangling/L1/02_select.ipynb
python3 $SKILL/estimate_exercise_time.py courses/Data_Wrangling/L1/exset_1
```

## Three-step workflow (agent-driven)

Execute only the steps the user asks for.

### Step 1 — Lesson reading time → `courses/<Course>/README.md`

1. Run `estimate_reading_time.py --course courses/<Course> [--json]`.
2. For each linked lesson, add or refresh **`(~Xm)`** immediately after the markdown link.
3. **If a time is already present** and the user did not ask to refresh, leave it unless the new estimate differs by more than ~20% (then mention the delta and ask, or refresh if they said “update all”).
4. `.typ` slide decks (Touying) ARE estimated (slides + prose + images). Skip external URLs and remaining non-countable targets (`.pdf`, directories). Report those as “manual estimate needed”.
5. Preserve existing README structure, numbering, and wording.

**Annotation format:** `[Lesson title](path/to/lesson.ipynb) (~14m)`

### Step 2 — Exercise time → same course README

1. Run `estimate_exercise_time.py --course courses/<Course> [--json]`.
2. Apply **`(~Xm)`** after each exercise-set link (`exset_*` dirs, `L*.Ex*` labels, quiz `.md` under exset).
3. Same “already set” rule as Step 1.

### Step 3 — Course total → root `README.md`

1. Sum Step 1 `TOTAL` + Step 2 `TOTAL` for the course (or use `--json` `total_minutes` from both runs).
2. Convert to a human duration for the catalog table, e.g. `~4hr` or `(3hr 45m)`.
3. Update the matching row in the root README course table — typically the duration in parentheses after the course link.
4. Do **not** change course descriptions unless the user asks.

**Example rollup line to print for the user:**

```text
Data Wrangling: lessons ~187m + exercises ~210m => ~6hr 37m (suggest ~6–7hr in catalog)
```

## Natural-language control

| User says | Do |
|-----------|-----|
| “estimate reading for Data Wrangling” / “step 1 only” | Step 1 only |
| “exercise times for L1” | `estimate_exercise_time.py` on `L1/exset_*` paths; edit README links for L1 exsets |
| “full time pass on Terminal” | Steps 1 → 2 → 3 for that course |
| “totals only, don’t edit READMEs” | Run both scripts with `--json`; print rollup; no file edits |
| “update root README durations” | Step 3 (requires totals; run scripts if not already done) |
| “one lesson: 02_select” | Single-file reading script + edit that one link |

## Models (do not change without recalibration)

**Reading (lessons):** `setup_min` + prose/wpm + code_lines×code_sec + output_lines×out_sec + images×img_sec + slides×slide_sec  
Defaults: 3m setup, 200 wpm, 8.6 s/code line, 2.5 s/output line, 18 s/image, 105 s/slide. Notebook/markdown lessons anchored to L3 census/Riyadh notebooks; `.typ` slide pricing anchored to `01_story_cholera_outbreak.typ` (~25m). For `.typ`, slides = title slide + headings (`=`/`==`) + `#pagebreak()`; tune with `--slide-sec`.

**Exercises:** `setup_min` + prose/wpm + tasks×task_sec  
Defaults: 5m setup per set, 200 wpm, 60 s per code cell (task). Anchored to Data Wrangling `exset_1` (~45m).

**Where the numbers live:** All parameters are config, not code, in `config.toml` next to this `SKILL.md` (`[reading]` and `[exercise]` sections, with inline comments). Edit that file to retune persistently; the scripts fall back to built-in defaults if a key or the file is missing. Point at another file with the `COURSE_TIME_ESTIMATES_CONFIG` env var. Override for a single run via script flags (`--setup-min`, `--code-sec`, `--task-sec`, etc.).

## Agent edit checklist

```
- [ ] Run script(s); capture stdout or --json
- [ ] Map each `target` path to the correct README link line
- [ ] Add/replace (~Xm) — one annotation per link, no duplicates
- [ ] Print per-course TOTALS for manual use
- [ ] Step 3: update root README.md table duration if requested
```

## Limitations

- `.pdf` / external slides: not analyzed; keep or set human estimates.
- `.typ` slide decks ARE analyzed (slide count + prose + images). Heuristic Typst parsing: reveal steps (`#pause`, `#colbreak`) are not separate slides; quoted strings (paths/URLs) and function calls are stripped from prose, so unusual macros may over- or under-count slightly.
- Empty or missing linked files: report `skip (missing)`; do not invent times.
- Exercise model counts **all** code cells in exset notebooks as tasks (including empty stubs).
