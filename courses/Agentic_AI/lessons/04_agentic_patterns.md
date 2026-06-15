# Agentic Patterns

In this lesson, we scan through results from papers and comment on working patterns when it comes to building effective LLM-based AI Agents.

We'll learn what reasoning and planning actually mean. How LLMs become Agents (tool use and observation). And see how and why code-writing agents out-perform textual or JSON tool calling agents. Finally, we look at an interesting HuggingGPT case for planning in a higher-level of software abstraction.

We'll focus on what YOU can apply in your work today using the DSPy framework.

## Pattern 1: Chain-of-Thought

Although it may not be obvious, but language models are also used to generate text that mimics the chain of thought that preceeds an answer. The way this is done is by training it on data that doesn't give the answer right away, but first, writes the steps towards doing that.

Here are standard examples of reasoning traces used in instruction-tuning datasets:

**Example 1: Arithmetic Reasoning (from the GSM8K Benchmark)**

* **Input:** "A cafeteria has 23 apples. If they use 20 to make lunch and buy 6 more, how many apples do they have?"
* **Reasoning Trace:** "The cafeteria originally had 23 apples. They used 20 to make lunch, leaving 23 - 20 = 3 apples. They then bought 6 more, resulting in 3 + 6 = 9 apples."
* **Final Answer:** "9"

**Example 2: State Tracking (from the BIG-Bench Hard Benchmark)**

* **Input:** "A coin is heads up. Jason flips the coin. Seth flips the coin. Is the coin still heads up?"
* **Reasoning Trace:** "The coin starts heads up. Jason flips the coin, changing its state to tails up. Seth flips the coin, changing its state back to heads up."
* **Final Answer:** "Yes"

Results from the paper [Chain-of-Thought Prompting Elicits Reasoning in Large Language Models](https://arxiv.org/abs/2201.11903):

-  Chain-of-thought prompting enables large language models to solve challenging math problems.
-  Chain-of-thought benefits bigger models more.

![](../assets/chain-of-thought.png)

We'll use the implementation (within DSPy): [`dspy.ChainOfThought`](https://dspy.ai/getting-started/changing-modules/) to make use of this.

### Why it Works: Thinking or Searching?

One theory says that reasoning traces work because models can better space their storage capacity; since there are more indexing routes available, i.e., tokens. This theory sits on the idea that the underlying technique, used by all Large Language Models today, the _Attention Mechanism_ (composed of Key, Value, Query), is essentially **a multi-step fuzzy search engine**.

The theory explains why such models have limited generalization capacity; i.e., performance drops suddenly for simpler tasks just because they were never seen during training. It also explains why more parameters and more data improves performance on benchmarks.

For details, see: [The Illusion of Thinking Paper](https://machinelearning.apple.com/research/illusion-of-thinking) by Apple's Machine Learning Research.

![Figure 1: Our setup enables verification of both final answers and intermediate reasoning traces, allowing detailed analysis of model thinking behavior.](https://mlr.cdn-apple.com/media/main_figure_f794f49488.png)

## Pattern 2: ReAct

Agents become such when they **interact with an envionment** and observe consequences of their actions.

The paper [ReAct: Synergizing Reasoning and Acting in Language Models](https://arxiv.org/abs/2210.03629) showed a sequence of chain of thoughts: **Reason**, **Act**, **Observe**. For example: "now that everything is cut, I should heat up the pot of water".

[Reason Action Observation](../assets/ReAct.png)

> "Reasoning traces help the model induce, track, and update action plans... while actions allow it to interface with external sources... to gather additional information."

In practice we'll be using [`dspy.ReAct`](https://dspy.ai/getting-started/react-and-tools/) to give our agents tools to use.

## Pattern 3: Reflection

The paper [Reflexion: Language Agents with Verbal Reinforcement Learning](https://arxiv.org/abs/2303.11366), shows AlfWorld performance across 134 tasks showing cumulative proportions of solved tasks using self-evaluation techniques of (Heuristic) and (GPT) for binary classification.

![](../assets/results_reflection.png)

In DSPy, we do it systematically with GEPA. [GEPA uses reflection to improve instructions](https://dspy.ai/getting-started/gepa-optimization/) for LLMs to optimize it based on specific set of metrics and external feedback.

## Pattern 4: Planning

> ""We propose Plan-and-Solve (PS) prompting... to first devise a useful plan to divide the entire task into smaller subtasks, and then carry out the subtasks according to the plan."


The paper is [Plan-and-Solve Prompting: Improving Zero-Shot Chain-of-Thought Reasoning by Large Language Models](https://arxiv.org/abs/2305.04091) showed example inputs and outputs of GPT-3 with (a) Zero-shot-CoT prompting, (b) Plan-and-Solve (PS) prompting:

![](../assets/planning_vs_CoT.png)

Results:

![](../assets/results_planning_vs_CoT.png)

To make use of this in practice, we will have a multi-step workflow, where the LLM first devises a plan.

### Manual Prompt Trail and Error

The same planning paper also shows how providing detailed prompts can greatly influence the output performance:

![](../assets/manual_prompt_evolution.png)

In practice, the GEPA optimizer (mentioned earlier) will take care of automatically refining the prompt, given training and testing data with clearly defined metrics and feedback.

## Pattern 5: CodeAct Makes LLMs Better Agents

> "We propose to use executable Python code to consolidate LLM agents’ actions into a unified space... LLM agents can leverage existing software packages and iteratively adjust their actions through code execution feedback."

The paper [Executable Code Actions Elicit Better LLM Agents](https://arxiv.org/abs/2402.01030) shows that planning, reasoning, and solving tasks through coding is actually way better than writing text, or spitting out JSON to call tools.

![](../assets/CodeAct_1.png)

![](../assets/CodeAct_2.png)

Two results:

- Higher Success Rate (%)
- Lower Average Number of Interaction Turns 

The paper further explains the benfits over JSON tool calling:

![](../assets/CodeAct_3.png)

Then it explains how it works:

![](../assets/CodeAct_4.png)

In practice, we would use [`dspy.CodeAct`](https://dspy.ai/diving-deeper/built-in-module-variants/#6-codeact-is-react-plus-a-code-sandbox) so the LM writes Python rather than outputting JSON-formatted tool calls to act.

### Automatic Feedback from Execution

LLM agents can leverage existing software packages and iteratively adjust their actions through **code execution feedback**.

## Pattern 6: Higher Abstraction

The paper: [HuggingGPT: Solving AI Tasks with ChatGPT and its Friends in Hugging Face](https://arxiv.org/abs/2303.17580) showed the power of higher abstraction code.

> We present HuggingGPT, an LLM-powered agent that leverages LLMs... as a controller to manage existing AI models to solve complicated AI tasks, with language serving as a generic interface to empower this.

![](../assets/huggingGPT.png)

The agent can automatically decide that to carry out this task, it first needs to:

1. Find a **pose determination model** to figure out the pose of the boy
2. Use a **pose-to-image model** to generate a picture of a girl
3. Run **image-to-text** to describe the image
4. Run **text-to-speech** to speak the description

Not all lines of code are equal. Not all tokens are equal.

In practice this means the power we give to our agent is proportional to the level of code we write and give it access to.

## Conclusion and Next Steps

In this course, you learn to actually apply these results from the body of research and make use of the fruits of knowledge.
