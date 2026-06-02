---
name: notebook-rewrite
description: Apply pedagogical conventions when rewriting or refactoring Jupyter notebooks for course material — OOP plotting with seaborn, breaking up dense one-liners, multi-line keyword arguments, ToC-friendly headings, `pathlib` over string paths, links to library docs, and bullet-point prose. Use when editing `.ipynb` files for the bootcamp courses or when asked to rewrite/clean up a notebook.
---

# Notebook Rewrite

Apply these conventions when rewriting a Jupyter notebook for the courses:

- Use the OOP API for plotting, and use seaborn (`sns`) instead of raw matplotlib.
- Break down complex statements with 3 or more consecutive method calls (two dots).
- Break down complex statements with 3 or more parentheses (nesting).
- Add pedagogical comments for a first-timer to learn what statements do, in *that* context specifically. Avoid generic commentary.
- Prefer keyword arguments over positional arguments. When a call includes more than 3 values, make it multi-line, with a comment on each argument explaining what the value set there means.
- Make the notebook easily navigable from a ToC by including proper headings and sub-headings.
- Whenever there is an import of a third-party library, include a link to its docs.
- Use `from pathlib import Path` instead of raw string concatenation for paths.
- Break down multi-sentence paragraphs into bullet points.
