# How to Read Documentation Like a Data Scientist

Most junior developers treat documentation as a dictionary: they search for a function name, copy an example, and move on.

Strong developers treat documentation as a map. They first build an understanding of the system, then use the reference material to answer specific questions.

Documentation is one of the highest-leverage skills you can develop because every library, framework, API, and tool you use comes with documentation.

---

# Understanding Sources of Information

Before learning how to read documentation, it's important to understand where information comes from.

## Primary Sources

Primary sources are the authoritative source of truth.

Examples:

* Pandas documentation
* NumPy documentation
* Scikit-Learn documentation
* Seaborn documentation
* PyTorch documentation

Primary sources usually contain three layers:

### Conceptual Documentation

Explains the big picture.

Examples:

* What is a DataFrame?
* What is vectorization?
* Why does Seaborn exist if Matplotlib already exists?

### Tutorials and Guides

Shows common workflows.

Examples:

* Loading datasets
* Creating visualizations
* Training machine learning models

### API Reference

The most detailed and precise layer.

Examples:

```python
pd.read_csv()
```

```python
sns.scatterplot()
```

```python
sklearn.model_selection.train_test_split()
```

Reference documentation answers questions like:

* What parameters are available?
* What type should each parameter be?
* What is returned?
* What edge cases exist?

---

## Secondary Sources

Secondary sources explain primary sources.

Examples:

* GeeksforGeeks
* Real Python
* Towards Data Science
* DataCamp tutorials
* YouTube videos
* Blog posts

These resources are useful because they often provide:

* Simpler explanations
* Practical examples
* Alternative perspectives

However, they are interpretations of the original source.

If a GeeksforGeeks article says one thing and the Pandas documentation says another, trust the Pandas documentation.

---

## Tertiary Sources

Tertiary sources synthesize information from primary and secondary sources.

Examples:

* ChatGPT
* Claude
* Gemini
* Copilot
* Perplexity

These tools are useful because they can:

* Summarize information
* Explain concepts
* Connect ideas across multiple sources
* Offer guided learning

However, they have an important limitation:

They are usually not the source of the information.

They are describing information that originated elsewhere.

For example, if you ask:

> How does `groupby()` work in Pandas?

An AI system may generate an explanation based on:

* Pandas documentation
* Tutorials
* Community discussions
* Training data

AI-generated summaries can be helpful, but you should be aware of their limitations. Here are some reasons why they might be misleading:

1. **Loss of nuance:** AI can oversimplify important details, missing subtle behaviors or edge cases described in official documentation.
2. **Outdated information:** AI models may be trained on old data and might summarize outdated API versions or features that no longer exist.
3. **Conflicting sources:** AI may combine information from sources that disagree, presenting an answer with internal contradictions or errors.
4. **Unverifiable sources:** AI usually doesn’t cite precise version numbers or official links, leaving you unable to confirm the information.
5. **Context loss:** AI won’t always know which library version or situation applies to your question, potentially giving you a summary that doesn’t fit your actual problem.

A useful rule:

```text
Primary source = defines
Secondary source = explains
Tertiary source = summarizes
```

# Start With a Question

Never read documentation aimlessly.

Bad:

> I'm going to learn Pandas.

Good:

> How do I aggregate sales data by month using Pandas?

Questions create context.

Context determines what parts of the documentation are relevant.

---

# Example 1: Learning Pandas

Suppose you encounter this code:

```python
sales.groupby("month")["revenue"].mean()
```

You understand Python, but you don't understand Pandas.

Your question becomes:

> What is groupby and how does it work?

Many beginners immediately search:

```text
pandas groupby example
```

and start reading random blog posts.

A better approach:

1. Open the Pandas documentation.
2. Search for "groupby".
3. Read the conceptual explanation.
4. Read the examples.
5. Run the examples yourself.

Notice the order:

```text
Question
    ↓
Official docs
    ↓
Examples
    ↓
Experimentation
```

not

```text
Question
    ↓
Random blog
    ↓
Copy code
```

---

# Example 2: Learning Seaborn

Suppose you want to visualize the relationship between study hours and exam scores.

Someone suggests using Seaborn.

Your question becomes:

> How does Seaborn help me create statistical visualizations?

Start with the documentation homepage.

You might discover that Seaborn focuses on:

* Statistical graphics
* Dataset-oriented plotting
* Higher-level abstractions over Matplotlib

Then you encounter:

```python
sns.scatterplot(
    data=df,
    x="hours_studied",
    y="exam_score"
)
```

Before reading every parameter, ask:

> What problem is this function solving?

Once you understand that it creates a scatter plot from a DataFrame, the API reference becomes easier to understand.

---

# Read Documentation in This Order

Most documentation follows a structure like:

```text
Introduction
    ↓
Tutorials
    ↓
Guides
    ↓
API Reference
```

Beginners often jump directly to:

```python
sns.scatterplot()
```

without understanding:

* Why it exists
* When to use it
* What alternatives exist

The result is shallow knowledge.

A better approach:

```text
Introduction
    ↓
Quickstart
    ↓
Common workflows
    ↓
Reference docs
```

---

# Code First, Docs Second

This sounds backwards but is surprisingly effective.

Instead of reading:

> A GroupBy object enables split-apply-combine operations...

Run some code first.

```python
import pandas as pd

df = pd.DataFrame({
    "team": ["A", "A", "B", "B"],
    "score": [10, 20, 15, 25]
})

df.groupby("team")["score"].mean()
```

Observe the result.

Then read the documentation.

Now the terminology connects to something you've already experienced.

A useful pattern:

```text
Run
    ↓
Observe
    ↓
Read
    ↓
Understand
```

rather than

```text
Read
    ↓
Read
    ↓
Read
    ↓
Forget
```

---

# Learn the Vocabulary

Documentation is organized around concepts, not beginner language.

Suppose your thought is:

> I want to calculate averages for each category.

You might search:

```text
calculate average for each group
```

The documentation may use:

```text
aggregation
groupby
split-apply-combine
```

Similarly:

| What You Think            | Documentation Term |
| ------------------------- | ------------------ |
| Remove missing values     | imputation         |
| Average each category     | aggregation        |
| Loop over rows            | iteration          |
| Normalize values          | scaling            |
| Convert labels to numbers | encoding           |

The more vocabulary you learn, the faster you can find answers.

---

# Read Wide Before Reading Deep

When learning a new library:

Don't spend an hour reading a single function page.

Instead, spend twenty minutes understanding:

* What the library does
* Major features
* Common workflows
* Core terminology

For a library like Pandas, you might skim:

* Getting Started
* Data Structures
* Missing Data
* GroupBy
* Merging
* Time Series

The goal isn't memorization.

The goal is building a mental map.

Later, when a problem appears, you'll know where to look.

---

# Use Search Effectively

Documentation search is often the fastest path.

For example:

```text
site:pandas.pydata.org groupby transform
```

```text
site:seaborn.pydata.org scatterplot hue
```

This restricts results to the official documentation.

You can also use:

DevDocs

for a unified search experience across multiple technologies.

---

# Treat Examples as Executable Documentation

Examples are not decorations.

They are documentation.

If you see:

```python
sns.scatterplot(
    data=df,
    x="hours",
    y="score"
)
```

Don't just read it.

Run it.

Then modify it:

```python
sns.scatterplot(
    data=df,
    x="hours",
    y="score",
    hue="gender"
)
```

Then:

```python
sns.scatterplot(
    data=df,
    x="hours",
    y="score",
    style="gender"
)
```

Observe what changes.

Examples become significantly more valuable when you interact with them.

---

# Take Notes on Concepts, Not Syntax

Bad notes:

```python
df.groupby(col).mean()
```

Good notes:

```text
GroupBy:
- partitions data into groups
- performs aggregation per group
- combines results into a new structure
```

Concepts transfer across tools.

Syntax does not.

---

# The Core Skill

Strong developers do not memorize documentation.

They develop three abilities:

1. Formulate precise questions.
2. Translate those questions into the vocabulary used by the documentation.
3. Navigate efficiently between concepts, guides, and references.

A useful mental model is:

```text
Problem
    ↓
Question
    ↓
Documentation Vocabulary
    ↓
Concepts
    ↓
Guides
    ↓
Reference
    ↓
Code
```

Documentation is not something you read once and finish.

It is a system you repeatedly return to, each time with a better question and a deeper understanding.
