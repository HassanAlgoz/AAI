# Applied Artifical Intelligence (AAI)

Welcome: [introduction to the Applied Artificial Intelligence Bootcamp](https://github.com/HassanAlgoz/AAI/releases/latest/download/Intro_01_bootcamp_intro.pdf) (1hr 30m).

PDF material can be downloaded from the [releases page](https://github.com/HassanAlgoz/AAI/releases).

The program consists of two tracks each aimed at a specific career path:

1. Data Scientist
2. AI Engineer

## Pre-requisites

Both tracks presume the following about the learner to get started:

+ English B2 level: IELTS 6.0 or TOEFL 4.0 (71).
+ Algorithmic thinking and problem-solving skills.
+ Good foundation in programming.
+ Working laptop with internet access.

### 1. [Terminal](/courses/Terminal/)

Command and conquer your machine. Fear not the black box. Protect yourself from malicious code.

Time Estimate: 1 day x 3 hours.

## Track 1: Data Scientist

Time Estimate: 5-6 weeks at 30 hrs/week.

### 1. [Data Wrangling](/courses/Data_Wrangling/)

Fundamentals of data wrangling and analysis in Python via pandas, matplotlib and seaborn.

- M1. Filtering, Sorting, and Aggregation
- M2. Data Wrangling
- M3. Data Vizualization
- M4. Timeseries Analysis

Time Estimate: 5 days x 6 hours.

### 2. [Data Science](/courses/Data_Science/)

Calculate, analyze, visualize, and extract insights from data. Formulate hypotheses and draw conclusions.

- M1. Introductions
- M2. Univariate Analysis
- M3. Bivariate Analysis
- M4. Inferential Statistics

Time Estimate: 5 days x 6 hours.

### 3. [Applied Machine Learning](/courses/Machine_Learning/)

Build reliable predictive modeling pipelines, debug its issues, evaluate and compare alternatives.

- M1. Supervised ML: Regression and Classification
- M2. Estimating and Improving Model Generalization Performance
- M3. Pipeline: Building Reliable Predictive Models
- M4. Decision Trees and Ensembles
- M5. AutoML

Time Estimate: 10 days x 6 hours.

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

## Track 2: AI Engineer

Time Estimate: 4-5 weeks at 30 hrs/week.

### 1. [Agentic Engineering](/courses/Agentic_Engineering/)

Work effectively and efficiently with AI in software engineering projects.

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

### 2. [Building Agentic AI Software](/courses/Agentic_AI/)

Develop, debug, evaluate, deploy, and monitor LLM-driven AI Agents to automate tasks involving unstructured data.

- M1. Signatures and Modules
- M2. Agents, Tools, and Code
- M3. Optimization
- M4. Deployment
- M5. Retrieval Augmented Generation (RAG)

Time Estimate: 10 days x 6 hours.

### 3. [Applied Deep Learning](/courses/Deep_Learning/)

Select, use, compose, fine-tune, and deploy open-weight deep learning models on various unstructured data tasks.

- M1. HuggingFace
- M2. Large Language Models
- M3. Applied Computer Vision

Time Estimate: 5 days x 6 hours.

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
