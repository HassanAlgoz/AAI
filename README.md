# Applied Artifical Intelligence (AAI)

Welcome: [introduction to the Applied Artificial Intelligence Bootcamp](https://github.com/HassanAlgoz/AAI/releases/latest/download/Intro_01_bootcamp_intro.pdf) (1hr 30m).

| #  | Course                                  | Description                                                                                               | Lessons (Time) | Exercises (Time) |
|----|-----------------------------------------|-----------------------------------------------------------------------------------------------------------|----------------|------------------|
| 1  | [Terminal](/courses/Terminal/)          | Command and conquer your machine. Fear not the black box. Protect yourself from malicious code.          | 1 (~30m)       | 5 (~2hr 40m)     |
| 2  | [Data Wrangling](/courses/Data_Wrangling/) | Fundamentals of data wrangling and analysis in Python via pandas, matplotlib and seaborn.                 | 11 (~4hr 24m)  | 7 (~3hr 17m)     |
| 3  | [Applied Data Science](/courses/Data_Science/) | Calculate, analyze, visualize, and extract insights from data. Formulate hypotheses and draw conclusions. | 13 (~8hr 50m)  | 4 (~1hr 37m)     |
| 4  | Applied Machine Learning                | Build reliable predictive modeling pipelines, debug its issues, evaluate and compare alternatives.        |                |                  |
| 5  | Applied Deep Learning                   | Use DL solution frameworks / libraries to apply AI to specific problems in NLP (language) and Computer Vision.   |                |                  |
| 6  | Agentic AI                              | Develop, debug, evaluate, deploy, and monitor LLM-driven AI Agents to automate tasks involving unstructured data. |                |                  |
| 7  | [Agentic Engineering](/courses/Agentic_Engineering/) | Work effectively and efficiently with AI in software engineering projects.                                | 4 (~41m)       | 0                |
|    | **Total**                               |                                                                                                           | **29 (~14hr 25m)** | **16 (~7hr 34m)** |


- **Estimated Duration**: 8 weeks.
- **Estimated hands-on content**: ~22hr (lessons ~14hr 25m + exercises ~7hr 34m), excluding the 1hr intro. Per-lesson estimates live in each course's `README.md`.

## Bootcamp Pre-requisites

+ English B2 (Upper-Intermediate) level: IELTS 6.5 or TOEFL 80.
+ Algorithmic thinking and problem-solving skills.
+ Strong foundation in programming.
+ Working laptop with internet access.

## AI Policy

**Punishment**: *expulsion from the bootcamp.*

- **Allowed use**: for feedback, hints, explanations, practice, or extra resources, while you still do the core reasoning, writing, and problem-solving.
  - [Gemini Guided Learning](https://blog.google/products-and-platforms/products/gemini/guided-learning-google-gemini/#:~:text=%E2%80%9CThe%20idea%20is%20to%20help,to%20get%20to%20the%20result).
  - [ChatGPT Study Mode](https://openai.com/index/chatgpt-study-mode/).
- **Forbidden use**: treating course material as "work" and AI as an assistant to get it done "faster" or "easier" or "better". Don't mix productivity (output) with learning (you).

See [the research and findings that made up our AI Policy](docs/ai_policy.md).

## Assigned Exercises

- Due Thursday 11:59 PM (end of same week).
- Work must have been pushed to GitHub.
- Marked as done (in Google Classroom) before then.
- Commit history **MUST** follow the [proof-of-work](/docs/proof-of-work.md) system.

## Resources

- [The Art of Reading Docs](docs/the_art_of_reading_docs.md)
- [Never expose API Keys](docs/never_expose_api_keys.qmd)
- [Pythonia: المقدمة البايثونية للبرمجة](https://halgoz.quarto.pub/pythonia/) (الشرح باللغة العربية)

---

## Development

- Local dev unchanged: `just compile` / `just watch` still produce ignored local PDFs.
- To publish: `git tag v1.0 && git push origin v1.0` -> workflow builds and attaches PDFs to the v1.0 release, which becomes latest.