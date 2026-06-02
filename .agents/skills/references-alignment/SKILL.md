---
name: references-alignment
description: Build an alignment table that cross-maps the tables of contents of multiple reference books, grouping equivalent sections from each book on the same row to ease cross-referencing later. Invoke explicitly when the user asks to "align references", "cross-reference books", or "build a ToC alignment table".
disable-model-invocation: true
---

# References Alignment

You will be given a set of reference materials (books).

1. First, look at the table of contents of each book and memorize it.
2. Since the ordering of the material differs from one book to the other, build an **alignment table** — an intermediary table of contents that groups the corresponding sections from the given books on each row. This makes it easy to cross-reference the material later.

## Input Template

Fill the templates below with the actual book names and ToCs before running the alignment.

Here is the ToC for Book 1: `{book1_name}`

```text
{toc1}
```

Here is the Table of Contents for Book 2: `{book2_name}`

```text
{toc2}
```

## Output

Produce a table whose rows are conceptual topics and whose columns are the books. Each cell is the matching section heading (with chapter/section numbers when available). Leave a cell blank when a book does not cover that topic.
