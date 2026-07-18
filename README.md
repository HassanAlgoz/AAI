# Applied Artifical Intelligence (AAI)

## Roadmap

![AAI Roadmap](assets/aai_roadmap.png)

The roadmap was design with career paths in mind, to help you land a job (Insha' Allah).

You can read this roadmap from the end (bottom to top) if you want to start from **job roles**; going back to the required courses that help you learn the necessary knowlede, skills, and mindset; to get your foot in the door.

### Corresponding **Job Titles**

Here we just list them down (as shown in the fiure above).

**Analysts Track**:

1. **Inferential Statistics** — Data Analyst, Statistician, Quantitative Researcher, Biostatistician, Market Researcher
2. **Applied Timeseries Analysis** — Data Analyst, Financial Analyst, Quantitative Analyst, Business Intelligence Analyst, Supply Chain Analyst

**Engineers Track**:

1. **Building with Deep Learning** — AI Engineer, Applied Machine Learning Engineer, Computer Vision Engineer, Generative AI Developer, Full-Stack AI Engineer, Machine Learning Developer
1. **Building with Agentic AI** — AI Engineer, Generative AI Engineer, LLM Engineer, Applied AI Developer, Full-Stack AI Engineer

**Mid-level**:

1. **Applied Machine Learning** — Data Scientist, Machine Learning Scientist, Tabular ML Engineer, Quantitative Data Scientist, Applied Statistician, Predictive Modeler, Analytics Engineer

**Senior-level**:

1. **Building Machine Learning Systems** — Machine Learning Engineer, MLOps Engineer, AI Engineer, Machine Learning Infrastructure Engineer, ML Systems Engineer, Platform Engineer (AI/ML)

## Course Material

PDF material can be downloaded from the [releases page](https://github.com/HassanAlgoz/AAI/releases).

Link to introductory slides: [introduction to the Applied Artificial Intelligence Roadmap](https://github.com/HassanAlgoz/AAI/releases/latest/download/Intro_01_bootcamp_intro.pdf).

## Pre-requisites

Both tracks presume the following about the learner to get started:

+ **English B2 level**: IELTS 6.0 or TOEFL 4.0 (71).
+ Algorithmic thinking and problem-solving skills.
+ Good foundation in programming.
+ Working laptop with internet access.

## Core

Shared foundation for both tracks.

### 1. [Python](/courses/Python/)

Programming foundations in Python (external material).

Time Estimate: self-paced (about 2-5 weeks; take your time).

### 2. [Terminal](/courses/Terminal/)

Understanding how to command your computer is essential for using it effectively and responsibly.

Command and conquer your machine. Fear not the black box. Protect yourself from malicious code.

Time Estimate: 1 day x 3 hours.

## Analysts Track

Time Estimate: 5-6 weeks at 30 hrs/week.

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

---

### 3.A [Inferential Statistics](/courses/Inferential_Statistics/)

Systematically generalize results from drawn samples onto a target population.

- M1. Inferential Statistics

Time Estimate: 2 days x 6 hours.

### 3.B [Applied Timeseries Analysis](/courses/Timeseries/)

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

### 2.A [Agentic Engineering](/courses/Agentic_Engineering/)

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

### 2.B [Building with Deep Learning](/courses/Building_with_Deep_Learning/)

Select, use, compose, fine-tune, and deploy open-weight deep learning models on various unstructured data tasks.

*Depends on*: Software Engineering.

- M1. HuggingFace
- M2. Large Language Models
- M3. Applied Computer Vision

Time Estimate: 5 days x 6 hours.

### 2.C [Building with Agentic AI](/courses/Building_with_Agentic_AI/)

Develop, debug, evaluate, deploy, and monitor LLM-driven AI Agents to automate tasks involving unstructured data.

*Depends on*: Software Engineering.

- M1. Signatures and Modules
- M2. Agents, Tools, and Code
- M3. Optimization
- M4. Deployment
- M5. Retrieval Augmented Generation (RAG)

Time Estimate: 10 days x 6 hours.

---

## Level 2 $\rArr$ Level 3 Courses

This track is a merge that requires both engineering and analysis.

### 1. [Applied Machine Learning](/courses/Machine_Learning/)

Build reliable predictive modeling pipelines, debug its issues, evaluate and compare alternatives.

- M1. Supervised ML: Regression and Classification
- M2. Estimating and Improving Model Generalization Performance
- M3. Pipeline: Building Reliable Predictive Models
- M4. Decision Trees and Ensembles
- M5. AutoML

Time Estimate: 10 days x 6 hours.

### 2. [Building Machine Learning Systems](/courses/Building_Machine_Learning_Systems/)

Design and operate production machine learning systems (advanced).

*Depends on*: Applied Machine Learning.

Time Estimate: TBD.

---

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
