#import "@preview/touying:0.6.1": *
#import "@preview/curryst:0.5.1" as curryst: rule

#import "/template/theme.typ": *

#show: university-theme.with(
  config-colors(
    primary: primary-color,
    secondary: secondary-color,
    tertiary: tertiary-color,
    neutral-darkest: text-color
  ),
  config-info(
    title: [Git Basics & VS Code SCM],
    subtitle: [Branching strategies, upstreams, and review diffs],
    author: [Hassan Algoz],
    date: datetime.today(),
    institution: [Alsun AI],
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Core Git Motivation

== Why Git?

- Git tracks changes to your files over time.
- It helps you safely experiment without losing working code.
- It makes teamwork easier by combining work from multiple people.
- It gives you a history you can inspect, compare, and restore.
- It supports both command-line and editor workflows.

== Setup Git

#set text(size: 16pt)
#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  block(fill: rgb("#f8fafc"), inset: 0.8em, radius: 0.4em)[
    *Windows & macOS:*
    - Win: Install from `git-scm.com`.
    - Mac: `xcode-select --install`.
    - Verify: `git --version`
  ],
  block(fill: rgb("#f1f5f9"), inset: 0.8em, radius: 0.4em)[
    *Linux:*
    ```bash
    # Debian/Ubuntu
    sudo apt update && sudo apt install git -y
    ```
  ]
)

== First-Time Git Configuration

Set your identity once (used in commit history):

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

```

= Common Git Scenarios

== Scenario 1: Regular Commits

Initialize a folder as a git repository:

```bash
mkdir my-project && cd my-project
git init

```

Make a change, stage it, and save it locally:

```bash
echo "My first draft" > report.txt
git add report.txt
git commit -m "first draft"

```

Push to remote repository:

```bash
git push

```

== Scenario 2: Feature Branches

- Feature branching isolates unstable modifications from the production baseline.
- Usually multiple commits are done on a separate branch, then merged into main.

```bash
# Switch branch and make a change
git checkout -b feature/new-header
echo "New header section" >> report.txt

# Stage and commit
git add report.txt
git commit -m "add new header draft"

```

== Scenario 2.A: Merge

```sh
# Switch back to the main branch and
# merge the feature branch into it
git checkout main
git merge feature/new-header

```

== Scenario 2.B: Open Pull Request (PR)

1. Navigate to your repository on the web platform.
2. Click "Compare & pull request."
3. Ensure *base branch* is main and *compare branch* is your feature branch.
4. Add structural descriptive summaries.
5. Click Create Pull Request.

== Figure: Open a Pull Request

#align(center + horizon)[
#image("../assets/pr.png", width: 85%)
]

= Upstream Management

== Scenario 3: Pull Content Updates

- Bootcamp content is served on GitHub.
- You are required to *fork* it (create a cloud clone pointing to it).
- The original repository is labeled the *upstream*.

== Image showing upstream in context

#align(center + horizon)[
#image("../assets/upstream.png", width: 85%)
]

== Scenario 3: Pull Content Updates (The Process)

1. Fork the GitHub repo `HassanAlgoz/B5`
2. Clone your own fork locally.
3. Setup the upstream connection target source.
4. Fetch structural changes from upstream.
5. Merge updating changes into local branches.

== Figure: The Fork Button

#align(center + horizon)[
#image("../assets/fork_button.png", width: 85%)
]

== Scenario 3: Pull Content Updates (Git Commands)

Connect to the original repository (only needs to be done once):

```bash
git remote add upstream [https://github.com/HassanAlgoz/B5.git](https://github.com/HassanAlgoz/B5.git)

```

Bring the latest changes into your local machine:

```bash
git fetch upstream
git checkout main
git merge upstream/main

```

*Alternative 1-step pattern:* `git pull upstream main`

= Source Control UI in VS Code

== Source Control overview screenshot

#align(center + horizon)[
#image("../assets/vscode/overview.png", width: 85%)
]

== Prerequisites

To use Git features in VS Code, you need:

- Git installed on your machine (2.0.0 or later)
- Configured identity parameters (`user.name` and `user.email`)

Useful learning materials:

- #link("https://git-scm.com/doc")[git-scm documentation]
- #link("https://git-scm.com/book")[Git Book]

== Get Started with a Repository

VS Code automatically detects tracking environments. From the SCM panel, you can:

- Initialize new repositories
- Clone remote architectures
- Directly publish modules onto platforms like GitHub

== Source Control Interface: Source Control Graph

#align(center)[
#image("../assets/vscode/source-control-graph.png", width: 85%)
]

== Source Control Interface: Diff editor

#align(center)[
#image("../assets/vscode/diff.png", width: 85%)
]

== Source Control Interface: Git blame / UI indicators

#align(center)[
#image("../assets/vscode/git-blame-status-bar.png", width: 85%)
]

= Common Workflows

== Common Workflows: Review and Commit

Before committing, review your changes for accuracy and quality. Stage whole files or explicit lines within the layout.

VS Code can also leverage integrated systems to suggest commit message parameters based on changes.

== Common Workflows: Review and Commit (Staging changes)

#align(center)[
#image("../assets/vscode/stage-changes.png", width: 85%)
]

== Common Workflows: Sync, Merge, Branches, History

- Sync layouts trace incoming and outgoing snapshots.
- Resolve merge conflicts with inline indicators or the 3-way editor layout.
- Swap branches easily using internal menus or stash parameters.

== Common Workflows: Sync (Incoming / outgoing changes)

#align(center)[
#image("../assets/vscode/incoming-outgoing-changes.png", width: 85%)
]

== Common Workflows: Merge conflicts (3-way merge editor)

#align(center)[
#image("../assets/vscode/merge-editor-overview.png", width: 85%)
]

== Common Workflows: Branches (Switching branches)

#align(center)[
#image("../assets/vscode/gitbranches.png", width: 85%)
]

== Common Workflows: History (Timeline view for a file)

#align(center)[
#image("../assets/vscode/timeline-view.png", width: 85%)
]

== GitHub Pull Requests and Issues

Install the official GitHub Pull Requests extension to manage code reviews right from your editor:

- Create, inspect, review, and merge structural pull requests.
- Comment, annotate, and approve tracking commits.
- Check out PR branch paths to debug conflicts locally.
