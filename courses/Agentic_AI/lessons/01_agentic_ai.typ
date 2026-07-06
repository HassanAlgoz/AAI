#import "@preview/touying:0.6.1": *
#import "@preview/curryst:0.5.1" as curryst: rule
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#import "/template/theme.typ": *

#show: university-theme.with(
  config-colors(
    primary: primary-color,
    secondary: secondary-color,
    tertiary: tertiary-color,
    neutral-darkest: text-color
  ),
  config-info(
    title: [Agentic AI],
    subtitle: [An introduction to Agentic AI],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

#let bent-edge(from, to, ..args) = {
  let midpoint = (from, 50%, to)
  let vertices = (
    from,
    (from, "|-", midpoint),
    (midpoint, "-|", to),
    to,
  )
  edge(..vertices, "-|>", ..args)
}

= Agentic AI Overview

== Current State of AI Agents

Reading the #link("https://www.langchain.com/state-of-agent-engineering")[State of Agent Engineering 2026], "a survey of 1,300 professionals — from engineers and product managers to business leaders and executives — to uncover the state of AI agents." could give you an idea of what's going on in 2026 with Agentic AI. Notably:

+ It is being used in production by companies of different sizes:
  + small
  + medium
  + large
+ Most usage is:
  + "*Customer Service*" (26.5%)
  + "*Research & Data Analysis*" (24.4%)
  + "*Internal Productivity*" (17.7%)

#pagebreak()

What does "Research & Data Analysis" and "Internal Productivity" mean? To answer this, we have #link("case-studies.qmd")[summarized 30+ case Studies] from companies of various backgrounds using the LangChain ecosystem. Five things stand out:

+ *Customer Support & Triage* (with a hand-off to human-in-the-loop)
  - _CH Robinson_ → parse emails (text, PDF paperwork, and images) requesting shipment and attatchments.
+ *Deep Research & Multi-Hop RAG* (highly structured intelligence report)
  - _Harmonica.ai_ → retrieve and summarize news and articles for startup investors

+ *Domain-Specific Copilots* (a simplification of an overly complex system)
  - _Definely_ → editor assisted with AI, extracting data from docs and pdfs, and shows them and highlights them side-by-side with the editor.

#pagebreak()

+ *Developer Productivity* (high niche)
  - _GitLab_ → planner agent, developer agent, debugger agent, review agent (and security agent). Human-in-the-loop. PR merge.

For more, checkout #link("https://docs.langchain.com/oss/python/langgraph/case-studies")[Case Studies | LangChain].

== Biggest Blockers?

In that same survey, the top 3 issues were:

+ "*Quality of Outputs*" (32.9%)
+ "*Latency / response time*" (20.1%)
+ "*Security and compliance*" (16.0%)

There's a world of difference between building an agent that works and one that doesn't. How can we build agents that fall into the former category? In this course, we're going to talk about best practices for building agents.

= Agentic Workflows

#figure(
  image("/courses/Agentic_AI/assets/humaneval_benchmark_chart.png"),
  caption: [HumanEval coding benchmark: non-agentic vs. agentic workflow performance for GPT-3.5 and GPT-4.],
)

#pagebreak()

Even with today's best LLMs, an agentic workflow lets you get much better performance. What we saw in this example was that the improvement from one generation of model to another—which is huge—is still not as big a difference as implementing an agentic workflow on the previous generation of model.

*Agentic workflow* means we make multiple LLM calls (prompting, reflection, iteration) to improve the performance of the system.

= What's an Agent?

// What is an agentic workflow, and how does it differ from ordinary automation?

== Degree of Autonomy

Today's *AI Agents* are computer programs where LLM outputs control the workflow. The *influence* of the LLM on the code workflow is the level of agency in the system.

#figure(
  image("/courses/Agentic_AI/assets/autonomy_spectrum.png", height: 65%),
  caption: [Degrees of Autonomy.],
)

== Non-LLM Components

An agentic workflow usually consist of non-LLM components, to do API calls, run code, or use other specialized models:

#table(
  columns: (auto, 1fr, 1fr),
  align: (left, left, left),
  table.header(
    [*Building block*], [*Examples*], [*Use cases*],
  ),
  [*Models*],
  [LLMs],
  [Text generation, tool use, information extraction],
  [],
  [Other AI models],
  [PDF-to-text, text-to-speech, image analysis],
  [*Tools*],
  [API],
  [Web search, get real-time data, send email, check calendar, ...],
  [],
  [Information retrieval],
  [Databases, Retrieval Augmented Generation (RAG)],
  [],
  [Code execution],
  [Basic calculator, data analysis],
)

=== Example Agentic Workflow: Invoice Processing

+ Extract required financial entities (biller, amount, date, etc.) from parsed document text.
+ Update the corresponding database records with the extracted data (function/tool).

#figure(
  image("/courses/Agentic_AI/assets/workflow_invoice_processing.png", height: 53%),
  caption: [Agentic invoice processing pipeline.]
)

== Level of Detail in Workflows

A lot of effort in agent workflow design is *looking at the current human or business process*. The more we understand the process, the easier it is to specify:

#table(
  columns: (1fr, 1fr, 1fr),
  align: (left, left, left),
  table.header(
    [*Direct generation*], [*3-step workflow*], [*5-step workflow*],
  ),
  [1. Write an essay on topic X],
  [1. Write an essay outline on topic X],
  [1. Write an essay outline on topic X],
  [],
  [2. Search web],
  [2. Search web],
  [],
  [3. Write the essay],
  [3. Write the first draft],
  [],
  [],
  [4. Consider what parts need revision],
  [],
  [],
  [5. Revise your draft],
)

Flexibility is not always a good thing. The more defined the process is, the less room for error. However, some processes are not well-defined.

= Large and Small Language Models

== Lanuage Models

Current Agentic workflows are driven by *LMs (Language Models)*. So we'll need to understand how they work, to build systems, debug their issues, and optimize their performance.

Remember that *Artificial Intelligence* is a field of Computer Science, studying how to automate decision making; whether we're using language models or non-generative methods.

An *alternative path to autonomy* was proposed by Turing Award winner and former Meta chief scientist Yann LeCun—World Models (JEPA). See: #link("https://youtu.be/kYkIdXwW2AE?si=Yx5U4p1Z3qux14j6")[Yann LeCun's \$1B Bet Against LMs [Part 1]] for more details.

== Large and Small Language Models

*Language Model (LM)*; generate text, which were later then used to *perform tasks* by mimicing what people would write in response to a given textual input:

*Large Language Models (LMs)* are a powerful subset of deep neural NLP models characterized by:

1. massive size (billions of parameters)
2. extensive training data (trillions of tokens)
3. ability to perform a wide range of language tasks

#pagebreak()

*Small Language Models (SLMs)* are LMs with far fewer parameters and lower compute requirements, energy consumption, and inference speed, allowing a set of use-cases that are impossible with large models:

- *Cheaper Deployment* – Lower hardware and cloud costs make AI more accessible to startups and developers.
- *Customizability*: Easily fine-tuned for domain-specific tasks (e.g., legal document analysis).
- *On-Device AI* – No need for an internet connection or cloud services, enhancing privacy and security.

== Multi-modal Models

A _modality_ means a medium or a way in which something exists or is done.

We use our 5 sense organs to recieve sensory inputs in multiple ways (modalities):

1. 👀 eyes to see
2. 👂️ ears to hear
3. 🤝 skin to touch
4. 👃 nose to smell
5. 👅 tongue to taste

#pagebreak()

Today's LMs moved beyond language as well. Sometimes called *VLMs (Vision-language models)* and sometimes called *Multi-modal Models (MMMs)*. Searchin through #link("https://openrouter.ai/models")[OpenRouter Models] you can find the left-pane (and the top buttons) to filter for specific modalities.

#figure(
  image("/courses/Agentic_AI/assets/openrouter_input_modalities.png", height: 55%),
  caption: [OpenRouter input modalities.],
)

== Examples of "Small" Models (2026)

Twelve models worth knowing in 2026, each with one standout strength.

1. #link("https://openrouter.ai/models?q=llama+4+scout")[Llama 4 Scout]: Meta's first natively multimodal open-weight model.

2. #link("https://openrouter.ai/models?q=deepseek+v4")[DeepSeek V4]: A Mixture-of-Experts model under MIT license with a native million-token context window. Near-frontier performance at a fraction of the cost per token.

3. #link("https://openrouter.ai/models?q=qwen3")[Qwen3]: Alibaba's flagship open-weight model with switchable thinking and non-thinking modes, all under Apache 2.0.

4. #link("https://openrouter.ai/models?q=gemma+4")[Gemma 4]: Google's open-weight family released under Apache 2.0, with the widest language coverage of any model on this list.

5. #link("https://openrouter.ai/models?q=phi+4")[Phi 4]: Microsoft’s compact model trained almost entirely on synthetic, curated data. A practical choice for edge and on-device deployment.

6. #link("https://openrouter.ai/models?q=mistral+small+3.1")[Mistral Small 3.1]: A VLM with a long context window that fits on a consumer laptop.

7. #link("https://openrouter.ai/models?q=nemotron+3+super")[Nemotron 3 Super]: NVIDIA’s hybrid MoE with a million-token context window. Fully open weights, datasets, and recipes, with strong results on agentic coding benchmarks.

8. #link("https://openrouter.ai/models?q=glm+5.1")[GLM 5.1]: The first open-weight model to top SWE-Bench Pro. Released under MIT with no commercial restrictions.

9. #link("https://openrouter.ai/models?q=kimi+k2.6")[Kimi K2.6]: Competitive with leading closed models on coding while costing far less per million tokens. Available on Hugging Face under a Modified MIT license.

10. #link("https://openrouter.ai/models?q=starcoder2")[StarCoder2]: One of the most transparent code models available.

11. #link("https://openrouter.ai/models?q=olmo+2")[OLMo 2 (AI2)]: The most complete example of open-source reproducibility on this list. Weights, training data, code, and full recipes all released under Apache 2.0.

12. #link("https://openrouter.ai/models?q=falcon+3")[Falcon 3]: A family of lightweight open-weight models built to run on a single GPU.

= What You Will Learn

== What You Will Learn

+ How to build agentic workflows made of swappable, debuggable, and composable modules.
+ How to evaluate the performance of AI workflows in terms of latency, cost, and accuracy.
+ How to optimize modules and workflows using training data; rather than manual prompt engineering.
+ How to utilize the results of tried and tested methods as evident by research on Agentic AI including: _Reasoning_, _Reflection_, _Planning_, and _CodeAct_.
