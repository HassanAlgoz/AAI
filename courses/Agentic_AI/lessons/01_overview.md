# Overview

## Current State of AI Agents

Reading the [State of Agent Engineering 2026](https://www.langchain.com/state-of-agent-engineering), "a survey of 1,300 professionals — from engineers and product managers to business leaders and executives — to uncover the state of AI agents." could give you an idea of what's going on in 2026 with Agentic AI. Notably:

1. It is being used in production by companies of different sizes (small, medium and large)
2. Most usage is:
   1. "**Customer Service**" (26.5%)
   2. "**Research & Data Analysis**" (24.4%)
   3. "**Internal Productivity**" (17.7%)

What does "Research & Data Analysis" and "Internal Productivity" mean? To answer this, we have [summarized 30+ case Studies](./case-studies.qmd) from companies of various backgrounds using the LangChain ecosystem. Five things stand out:

1. **Customer Support & Triage** (with a hand-off to human-in-the-loop)
    - *CH Robinson* -> parse emails (text, PDF paperwork, and images) requesting shipment and attatchments.
2. **Deep Research & Multi-Hop RAG** (highly structured intelligence report)
    - *Harmonica.ai* -> retrieve and summarize news and articles for startup investors
3. **Domain-Specific Copilots** (a simplification of an overly complex system)
    - *Definely* -> editor assisted with AI, extracting data from docs and pdfs, and shows them and highlights them side-by-side with the editor.
4. **Developer Productivity** (high niche)
   - *GitLab* -> planner agent, developer agent, debugger agent, review agent (and security agent). Human-in-the-loop. PR merge.

For more, checkout [Case Studies | LangChain](https://docs.langchain.com/oss/python/langgraph/case-studies).

### Biggest Blockers?

In that same survey, the top 3 issues were:

1.  "**Quality of Outputs**" (32.9%)
2. "**Latency / response time**" (20.1%)
3. "**Security and compliance**" (16.0%)

There’s a world of difference between building an agent that works and one that doesn’t. How can we build agents that fall into the former category? In this course, we’re going to talk about best practices for building agents.

## AI Agent $=$ Agentic Workflow

Rather than relying on: a **single monolithic language model** as a black-box, developers should build **modular systems** where LLMs play specialized, composable roles.

Andrew Ng's team collected data on a coding benchmark that tests the ability of different LLMs to write code to carry out certain tasks. The benchmark used in this case is called **HumanEval**.

If asked to write code directly—to just type out the computer program—**GPT-3.5** (the model the first publicly available version of ChatGPT was based on) gets **48%** right on this benchmark in a non-agentic workflow. **GPT-4** is a much better model: its performance leaps to **67%** with this also non-agentic workflow.

But as large as the improvement was from GPT-3.5 to GPT-4, that improvement is dwarfed by what you can achieve by wrapping GPT-3.5 within an agentic workflow. Using different agentic techniques—which you learn about later in this course—you can prompt GPT-3.5 to write code and then reflect on the code and figure out if you can improve it. Using techniques like that, GPT-3.5 can reach much higher levels of performance. Similarly, GPT-4 used in the context of an agentic workflow also does much better.

![Figure 1. HumanEval coding benchmark: non-agentic vs. agentic workflow performance for GPT-3.5 and GPT-4.](../assets/humaneval_benchmark_chart.png)

| Model | Non-agentic | Agentic workflows (examples from slide) |
| --- | --- | --- |
| GPT-3.5 | 48% | Intervenor (74%), ANPL (75%), Language Agent Tree Search (83%), LDB + Reflexion (95%) |
| GPT-4 | 67% | CodeT (81%), MetaGPT (82%), ANPL (83%), Reflexion (91%), Language Agent Tree Search (93%), AgentCoder (94%) |

Even with today's best LLMs, an agentic workflow lets you get much better performance. What we saw in this example was that the improvement from one generation of model to another—which is huge—is still not as big a difference as implementing an agentic workflow on the previous generation of model.

## What you will learn

1. How to build agentic workflows made of swappable, debuggable, and composable modules.
2. How to evaluate the performance of AI workflows in terms of latency, cost, and accuracy.
3. How to optimize modules and workflows using training data; rather than manual prompt engineering.
4. How to utilize the results of tried and tested methods as evident by research on Agentic AI including: _Reasoning_, _Reflection_, _Planning_, and _CodeAct_.
