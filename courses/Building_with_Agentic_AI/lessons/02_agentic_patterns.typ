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
    title: [Agentic AI Patterns],
    subtitle: [Applying the latest research to your workflow],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

#let dspy-practice(body) = box(stroke: 1pt + primary-color, radius: 5pt, inset: 0.6em, body)

= Agentic Patterns

== Introduction

We summarize the latest research on Agentic AI, and how to apply it in practice.

- What *reasoning* and *planning* actually mean.
- How LLMs become Agents (*tool use* and *observation*).
- Why *code-writing agents* out-perform textual or JSON *tool-calling agents*.
- An interesting *HuggingGPT* case for planning in a higher-level of software *abstraction*.

We'll focus on what YOU can apply in your work today using the #link("https://dspy.ai/")[DSPy framework].

== Pattern 1: Chain-of-Thought

Although it may not be obvious, but language models are also used to generate text that mimics the chain of thought that preceeds an answer. The way this is done is by training it on data that doesn't give the answer right away, but first, writes the steps towards doing that.

#dspy-practice[
  Use #link("https://dspy.ai/getting-started/changing-modules/")[`dspy.ChainOfThought`] to apply this pattern.
]

Here are standard examples of reasoning traces used in instruction-tuning datasets:

#pagebreak()

=== Example 1: Arithmetic Reasoning (from the GSM8K Benchmark)

+ *Input:* "A cafeteria has 23 apples. If they use 20 to make lunch and buy 6 more, how many apples do they have?"
+ *Reasoning Trace:* "The cafeteria originally had 23 apples. They used 20 to make lunch, leaving 23 - 20 = 3 apples. They then bought 6 more, resulting in 3 + 6 = 9 apples."
+ *Final Answer:* "9"

=== Example 2: State Tracking (from the BIG-Bench Hard Benchmark)

+ *Input:* "A coin is heads up. Jason flips the coin. Seth flips the coin. Is the coin still heads up?"
+ *Reasoning Trace:* "The coin starts heads up. Jason flips the coin, changing its state to tails up. Seth flips the coin, changing its state back to heads up."
+ *Final Answer:* "Yes"

#pagebreak()

Results from the paper #link("https://arxiv.org/abs/2201.11903")[Chain-of-Thought Prompting Elicits Reasoning in Large Language Models]:

#columns(2, gutter: 8pt)[
  + Chain-of-thought prompting enables large language models to solve challenging math problems.
  + Chain-of-thought benefits bigger models more.

  Chain-of-thought prompting improves performance on challenging math problems, especially for larger models.

  #colbreak()

  #figure(
    image("/courses/Building_with_Agentic_AI/assets/chain-of-thought.png", height: 100%),
    // caption: [],
  )
]

#pagebreak()

=== Why it Works: Thinking or Searching?

One theory says that reasoning traces work because models can better space their storage capacity; since there are more indexing routes available, i.e., tokens. This theory sits on the idea that the underlying technique, used by all Large Language Models today, the _Attention Mechanism_ (composed of Key, Value, Query), is essentially *a multi-step fuzzy search engine*.

The theory explains why such models have limited generalization capacity; i.e., performance drops suddenly for simpler tasks just because they were never seen during training. It also explains why more parameters and more data improves performance on benchmarks.

#pagebreak()

=== The Illusion of Thinking

See: #link("https://machinelearning.apple.com/research/illusion-of-thinking")[The Illusion of Thinking Paper] by Apple's Machine Learning Research.

#figure(
  image("/courses/Building_with_Agentic_AI/assets/illusion_of_thinking_figure.png", width: 60%),
  caption: [Our setup enables verification of both final answers and intermediate reasoning traces, allowing detailed analysis of model thinking behavior.],
)

== Pattern 2: ReAct

Agents become such when they *interact with an envionment* and observe consequences of their actions.


#pagebreak()


#figure(
  image("/courses/Building_with_Agentic_AI/assets/ReAct.png", height: 90%),
  caption: [Reason → Action → Observation loop in ReAct agents.],
)

#pagebreak()


The paper #link("https://arxiv.org/abs/2210.03629")[ReAct: Synergizing Reasoning and Acting in Language Models] showed a sequence of chain of thoughts: *Reason*, *Act*, *Observe*. For example: "now that everything is cut, I should heat up the pot of water".

#quote(block: true)[
  "Reasoning traces help the model induce, track, and update action plans... while actions allow it to interface with external sources... to gather additional information."
]

#dspy-practice[
  Use #link("https://dspy.ai/getting-started/react-and-tools/")[`dspy.ReAct`] to implement this pattern.
]

== Pattern 3: Reflection

The paper #link("https://arxiv.org/abs/2303.11366")[Reflexion: Language Agents with Verbal Reinforcement Learning], shows AlfWorld performance across 134 tasks showing cumulative proportions of solved tasks using self-evaluation techniques of (Heuristic) and (GPT) for binary classification.

#figure(
  image("/courses/Building_with_Agentic_AI/assets/results_reflection.png", height: 50%),
  caption: [AlfWorld results: cumulative proportion of solved tasks with heuristic and GPT-based self-evaluation.],
)

#pagebreak()

#dspy-practice[
  #link("https://dspy.ai/getting-started/gepa-optimization/")[In DSPy, do this systematically with GEPA which uses reflection to improve instructions] for LLMs based on a specific set of metrics and external feedback.
]

== Pattern 4: Planning

#quote(block: true)[
  "We propose Plan-and-Solve (PS) prompting... to first devise a useful plan to divide the entire task into smaller subtasks, and then carry out the subtasks according to the plan."
]

The paper #link("https://arxiv.org/abs/2305.04091")[Plan-and-Solve Prompting: Improving Zero-Shot Chain-of-Thought Reasoning by Large Language Models] showed example inputs and outputs of GPT-3 with (a) Zero-shot-CoT prompting, (b) Plan-and-Solve (PS) prompting:

#pagebreak()

#figure(
  image("/courses/Building_with_Agentic_AI/assets/planning_vs_CoT.png", height: 80%),
  caption: [Zero-shot-CoT vs. Plan-and-Solve prompting examples.],
)

#pagebreak()

Results:

#figure(
  image("/courses/Building_with_Agentic_AI/assets/results_planning_vs_CoT.png", height: 80%),
  caption: [Plan-and-Solve prompting improves over zero-shot chain-of-thought.],
)

#dspy-practice[
  In practice, use a multi-step workflow where the LLM first devises a plan, then carries out each subtask.
]

#pagebreak()

=== Manual Prompt Trail and Error

#figure(
  image("/courses/Building_with_Agentic_AI/assets/manual_prompt_evolution.png", height: 85%),
  caption: [Manual prompt evolution can greatly influence planning performance.],
)

#pagebreak()

#dspy-practice[
  In practice, the GEPA optimizer (mentioned earlier) automatically refines prompts given training and testing data with clearly defined metrics and feedback.
]

== Pattern 5: CodeAct Makes LLMs Better Agents

#quote(block: true)[
  "We propose to use executable Python code to consolidate LLM agents' actions into a unified space... LLM agents can leverage existing software packages and iteratively adjust their actions through code execution feedback."
]

The paper #link("https://arxiv.org/abs/2402.01030")[Executable Code Actions Elicit Better LLM Agents] shows that planning, reasoning, and solving tasks through coding is actually way better than writing text, or spitting out JSON to call tools.

#pagebreak()

#figure(
  image("/courses/Building_with_Agentic_AI/assets/CodeAct_1.png", width: 100%),
  caption: [CodeAct consolidates agent actions into executable Python.],
)

#figure(
  image("/courses/Building_with_Agentic_AI/assets/CodeAct_2.png", width: 100%),
  caption: [CodeAct vs. text and JSON tool-calling approaches.],
)

#pagebreak()

#figure(
  image("/courses/Building_with_Agentic_AI/assets/CodeAct_3.png", width: 100%),
  caption: [Benefits of CodeAct over JSON tool calling.],
)

#pagebreak()

#figure(
  image("/courses/Building_with_Agentic_AI/assets/CodeAct_4.png", width: 100%),
  caption: [How CodeAct works in practice.],
)

#pagebreak()

#dspy-practice[
  Use #link("https://dspy.ai/diving-deeper/built-in-module-variants/#6-codeact-is-react-plus-a-code-sandbox")[`dspy.CodeAct`] so the LM writes Python rather than outputting JSON-formatted tool calls to act.
]

== Pattern 6: Higher Abstraction

The paper: #link("https://arxiv.org/abs/2303.17580")[HuggingGPT: Solving AI Tasks with ChatGPT and its Friends in Hugging Face] showed the power of using higher-level abstraction.

#quote(block: true)[
  "We present HuggingGPT, an LLM-powered agent that leverages LLMs... as a controller to manage existing AI models to solve complicated AI tasks, with language serving as a generic interface to empower this."
]

#pagebreak()

#figure(
  image("/courses/Building_with_Agentic_AI/assets/huggingGPT.png", width: 100%),
  caption: [HuggingGPT uses an LLM controller to orchestrate specialized AI models.],
)

#pagebreak()

The agent can automatically decide that to carry out this task, it first needs to:

+ Find a *pose determination model* to figure out the pose of the boy
+ Use a *pose-to-image model* to generate a picture of a girl
+ Run *image-to-text* to describe the image
+ Run *text-to-speech* to speak the description

Not all lines of code are equal. Not all tokens are equal.

#dspy-practice[
  In practice, the power you give your agent is proportional to the level of code you write and give it access to.
]

== Conclusion

In this course, you learn to actually apply these results from the body of research and make use of the fruits of knowledge.
