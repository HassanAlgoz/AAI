# Applied Artifical Intelligence (AAI)

Welcome: [introduction to the Applied Artificial Intelligence Bootcamp](https://github.com/HassanAlgoz/AAI/releases/latest/download/Intro_01_bootcamp_intro.pdf) (1hr 30m).

PDF material can be downloaded from the [releases page](https://github.com/HassanAlgoz/AAI/releases).

The program has a shared **Core**, two career tracks (**Analysts** and **Engineers**), a shared **merge** course, and optional **Level 3** advanced work.

![AAI Bootcamp track dependency graph](assets/aai_roadmap.png)

- **Blue** — Analysts Track
- **Green** — Engineers Track (Terminal and Python sit here visually because Core is taught with an engineering orientation; they are Core to both tracks)
- **Yellow** — merge point between tracks
- **Red** — Level 3 (advanced)

## Pre-requisites

Both tracks presume the following about the learner to get started:

+ English B2 level: IELTS 6.0 or TOEFL 4.0 (71).
+ Algorithmic thinking and problem-solving skills.
+ Good foundation in programming.
+ Working laptop with internet access.

## Core

Shared foundation for both tracks. Order: Terminal → Python.

### 1. [Terminal](/courses/Terminal/)

Command and conquer your machine. Fear not the black box. Protect yourself from malicious code.

Time Estimate: 1 day x 3 hours.

### 2. [Python](/courses/Python/)

Programming foundations in Python (external material).

Time Estimate: self-paced.

## Analysts Track

Time Estimate: 5-6 weeks at 30 hrs/week.

Path: Data Analysis → Statistical Analysis → {Inferential Statistics, Applied Timeseries Analysis, Applied Machine Learning}.

### 1. [Data Analysis](/courses/Data_Analysis/)

Fundamentals of data wrangling and analysis in Python via pandas, matplotlib and seaborn.

- M1. Filtering, Sorting, and Aggregation
- M2. Data Wrangling
- M3. Data Vizualization
- M4. Timeseries Analysis

Time Estimate: 5 days x 6 hours.

### 2. [Statistical Analysis](/courses/Statistical_Analysis/)

Calculate, analyze, visualize, and extract insights from data. Formulate hypotheses and draw conclusions.

- M1. Introductions
- M2. Univariate Analysis
- M3. Bivariate Analysis

Time Estimate: 5 days x 6 hours.

### 3. [Inferential Statistics](/courses/Inferential_Statistics/)

Systematically generalize results from drawn samples onto a target population.

- M1. Inferential Statistics

Time Estimate: 2 days x 6 hours.

### 4. [Applied Timeseries Analysis](/courses/Timeseries/)

Visualize, analyze, and characterize time series -- then build forecasting models.

- M1. Visualizing Time Series
- M2. Correlation and Autocorrelation
- M3. Time Series Decomposition
- M4. Time Series Features
- M5. Forecasting
- M6. Model Evaluation and Tuning
- M7. Judgemental Forecasting

Time Estimate: 5 days x 6 hours.

## Engineers Track

Time Estimate: 4-5 weeks at 30 hrs/week.

Path: Software Engineering → {Agentic Engineering, Building with Deep Learning, Building with Agentic AI, Applied Machine Learning}.

### 1. [Software Engineering](/courses/Software_Engineering/)

Software design, systems, and construction fundamentals for building reliable applications.

Time Estimate: TBD.

### 2. [Agentic Engineering](/courses/Agentic_Engineering/)

Work effectively and efficiently with AI in software engineering projects.

*Depends on*: Software Engineering.

*Learning Outcomes*:

+ Differentiate between Vibe Coding and Agentic Engineering.
+ Differentiate between Models and Harnesses.
+ Understand the tradeoffs between probabilistic and deterministic methods of editor features, and when to use each for the best results.
+ Understand when to use Ask, Plan, Agent, Multi-task, and Debugging Modes of Coding Agents.
+ Make your own codebases agentic and ready for coding agents.
+ Understand the limitations of AI and the necessity for Software Engineering Fundamentals.

*Modules*:

- M1. Pushing the Limits of AI Agents

Time Estimate: 5 days x 6 hours.

### 3. [Building with Deep Learning](/courses/Building_with_Deep_Learning/)

Select, use, compose, fine-tune, and deploy open-weight deep learning models on various unstructured data tasks.

*Depends on*: Software Engineering.

- M1. HuggingFace
- M2. Large Language Models
- M3. Applied Computer Vision

Time Estimate: 5 days x 6 hours.

### 4. [Building with Agentic AI](/courses/Building_with_Agentic_AI/)

Develop, debug, evaluate, deploy, and monitor LLM-driven AI Agents to automate tasks involving unstructured data.

*Depends on*: Software Engineering.

- M1. Signatures and Modules
- M2. Agents, Tools, and Code
- M3. Optimization
- M4. Deployment
- M5. Retrieval Augmented Generation (RAG)

Time Estimate: 10 days x 6 hours.

## Shared (merge)

### 1. [Applied Machine Learning](/courses/Machine_Learning/)

Build reliable predictive modeling pipelines, debug its issues, evaluate and compare alternatives.

Reached from Statistical Analysis (Analysts) or Software Engineering (Engineers).

- M1. Supervised ML: Regression and Classification
- M2. Estimating and Improving Model Generalization Performance
- M3. Pipeline: Building Reliable Predictive Models
- M4. Decision Trees and Ensembles
- M5. AutoML

Time Estimate: 10 days x 6 hours.

## Level 3

### 1. [Building Machine Learning Systems](/courses/Building_Machine_Learning_Systems/)

Design and operate production machine learning systems (advanced).

*Depends on*: Applied Machine Learning.

Time Estimate: TBD.

## AI Policy

Good use of AI means it **augments, rather than replaces, thinking** — used for feedback, hints, explanations, practice, or extra resources, while **you still do the core reasoning, writing, and problem-solving**.

**Forbidden use**: treating course material as "work" and AI as an assistant to get it done "faster" or "easier" or "better". Don't mix productivity (output) with learning (you).

See [the research and findings that made up our AI Policy](docs/ai_policy.md).

## Assigned Exercises

- Due Thursday 11:59 PM (end of same week).
- Work must have been pushed to GitHub.
- Marked as done (in Google Classroom) before then.
- Commit history **MUST** follow the [proof-of-work](/docs/proof-of-work.md) system.

---

## Contribution (Course Development)

- Local dev unchanged: `just compile` / `just watch` still produce ignored local PDFs.
- To publish: `git tag v1.0 && git push origin v1.0` -> workflow builds and attaches PDFs to the v1.0 release, which becomes latest.
