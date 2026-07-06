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
    title: [Introduction to the DSPy Framework],
    subtitle: [Declarative Self-Improving Language Programs in Python.],
    author: [Leonie Monigatti · adapted by Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

= DSPy Overview

== Introduction

Source: #link("https://www.leoniemonigatti.com/papers/dspy.html")[DSPy: Compiling Declarative Language Model Calls into Self-Improving Pipelines] by Leonie Monigatti (February 27, 2024).

#figure(
  image("/courses/Agentic_AI/assets/dspy_article/dspy_hero.jpg", height: 70%),
)

#pagebreak()

Currently, building applications using large language models (LLMs) can be not only *complex* but also *fragile*.

Typical pipelines are often implemented using prompts, which are hand-crafted through trial and error because *LLMs are sensitive to how they are prompted*. Thus, when you change a piece in your pipeline, such as the LLM or your data, you will likely weaken its performance – unless you adapt the *prompt* (or *fine-tuning steps*).

=== Solution

#link("https://arxiv.org/abs/2310.03714")[DSPy] is a framework that aims to solve the fragility problem in language model (LM)-based applications *by prioritizing programming over prompting*. It allows you to recompile the entire pipeline to optimize it to your specific task – instead of repeating manual rounds of prompt engineering – whenever you change a component.

== What is DSPy

*DSPy* ("#strong[D]eclarative #strong[S]elf-improving Language #strong[P]rograms (in Python)", pronounced "dee-es-pie") #link("https://arxiv.org/abs/2310.03714")[1] is a framework for _"programming with foundation models"_ developed by researchers at Stanford NLP.

DSPy also provides a more systematic approach to building LM-based applications by separating the information flow of your program from the parameters (prompts and LM weights) of each step. DSPy will then take your program and automatically optimize how to prompt (or finetune) LMs for your particular task.

#pagebreak()

For this purpose, DSPy introduces a set of the following concepts:

+ Hand-written prompts and fine-tuning are abstracted and replaced by *signatures*
+ Prompting techniques, such as Chain of Thought or ReAct, are abstracted and replaced by *modules*
+ Manual prompt engineering is automated with *optimizers* (teleprompters) and a DSPy *Compiler*

#pagebreak()

The workflow of building an LM-based application with DSPy, will remind you of the workflow for training a neural network:

#figure(
  image("/courses/Agentic_AI/assets/dspy_article/dspy_workflow.jpg", height: 75%),
  caption: [Workflow of building an LLM-based app with DSPy],
)

#pagebreak()

+ *Collect dataset*: Collect a few examples of the inputs and outputs of your program (e.g., question and answer pairs), which will be used to optimize your pipeline.
+ *Write DSPy program*: Define your program's logic with signatures and modules and the information flow among the components to solve your task.
+ *Define validation logic*: Define a logic to optimize your program for using a validation metric and an optimizer (teleprompter).
+ *Compile DSPy program*: The DSPy compiler takes the training data, program, optimizer, and validation metric into account to optimize your program (e.g., prompts or finetunes).
+ *Iterate*: Repeat the process by improving your data, program, or validation until you are happy with your pipeline's performance.

#pagebreak()

Similarly to *PyTorch*, where general-purpose layers can be composed in any model architecture, in DSPy general-purpose modules can be composed in any LM-based application. Additionally, compiling a DSPy program, where the parameters in the DSPy modules are automatically optimized, is similar to training a neural network in PyTorch, where the model weights are trained using optimizers. 

#table(
  columns: (1fr, 1fr),
  align: (left, left),
  table.header([*PyTorch*], [*DSPy*]),
  [Model architecture with general-purpose layers (e.g., Dense, Conv, Pooling, Dropout)],
  [DSPy Program with general.purpose modules (e.g., Predict, ChainOfThought)],
  [Model training],
  [Compiling],
  [Training data (large dataset)],
  [Training data (small dataset)],
  [Loss function],
  [Evaluation metric],
  [Optimizer (e.g. SGD, Adam, RMSProp)],
  [Teleprompter (e.g., BootstrapFewShot, Ensemble)],
)

= DSPy Programming Model

== Overview

This section discusses the following three core concepts introduced by DSPy:

+ *Signatures*: Abstracting prompting and fine-tuning
+ *Modules*: Abstracting prompting techniques
+ *Teleprompters*: Automating prompting for arbitrary pipelines

#pagebreak()

== Signatures

Every call to the LM in a DSPy program must have a natural language signature, which replaces the traditional hand-written prompt. A signature is a short function that specifies what a transformation does rather than how to prompt the LM to do it (e.g., "consume questions and context and return answers").


#figure(
  image("/courses/Agentic_AI/assets/dspy_article/dspy_signature.png", height: 45%),
  caption: [DSPy signatures replace hand-written prompts],
)

#pagebreak()

A signature is a tuple of input and output fields in its minimal form.

#figure(
  image("/courses/Agentic_AI/assets/dspy_article/dspy_signature_structure.png", height: 40%),
  caption: [Structure of a minimal DSPy signature],
)

Below, you can see a few examples of shorthand syntax signatures:

```text
"question -> answer"
"long_document -> summary"
"context, question -> answer"
```

#pagebreak()

In many cases, these shorthand syntax signatures are sufficient. However, in cases where you need more control, you also define signatures with the following notation. In this case, a signature consists of three elements:

+ A minimal description of the *sub-task* the LM is supposed to solve,
+ a description of the *input fields* and
+ a description of the *output fields*.

#pagebreak()

Below, you can see the complete notation for the signature: `context, question -> answer`:

```python
class GenerateAnswer(dspy.Signature):
    """Answer questions with short factoid answers."""
    context = dspy.InputField(desc="may contain relevant facts")
    question = dspy.InputField()
    answer = dspy.OutputField(desc="often between 1 and 5 words")
```

In contrast to hand-written prompts, signatures can be compiled into self-improving and pipeline-adaptive prompts or finetunes by bootstrapping examples for each signature.

== Modules

You are probably familiar with a few different prompting techniques, such as adding sentences like `"Your task is to ..."` or `"You are a ..."` at the beginning of a prompt, Chain of Thought (`"Let's think step by step"`), or adding sentences like `"Don't make anything up"` or `"Only use the provided context"` at the end of the prompt.

*Modules* in DSPy are templated and parameterized to abstract these prompting techniques. This means that they are used to adapt DSPy signatures to a task by applying prompting, fine-tuning, augmentation, and reasoning techniques.

#pagebreak()

Below, you can see how a signature can be passed to a `ChainOfThought` module and then called with values for the input fields `context` and `question`.

```python
# Option 1: Pass minimal signature to ChainOfThought module
generate_answer = dspy.ChainOfThought("context, question -> answer")

# Option 2: Or pass full notation signature to ChainOfThought module
generate_answer = dspy.ChainOfThought(GenerateAnswer)

# Call the module on a particular input.
pred = generate_answer(context = "Which meant learning Lisp, since in those days Lisp was regarded as the language of AI.",
                       question = "What programming language did the author learn in college?")
```

#pagebreak()

Below, you can see how the `ChainOfThought` module initially implements the signature `"context, question -> answer"`. If you want to try it yourself, you can use `lm.inspect_history(n=1)` to print the last prompt.

#figure(
  image("/courses/Agentic_AI/assets/dspy_article/dspy_chainofthought_module.png", height: 60%),
  caption: [Initial implementation of the signature 'context, question -> answer' with a ChainOfThought module],
)

#pagebreak()

At the time of writing, DSPy implements the following modules (see #link("https://dspy.ai/api/modules/")[API reference]):

+ #link("https://dspy.ai/api/modules/Module/")[dspy.Module]: Base class for all DSPy modules (programs).
+ #link("https://dspy.ai/api/modules/Predict/")[dspy.Predict]: Basic module that maps inputs to outputs using a language model.
+ #link("https://dspy.ai/api/modules/ChainOfThought/")[dspy.ChainOfThought]: Reasons step by step in order to predict the output of a task.
+ #link("https://dspy.ai/api/modules/BestOfN/")[dspy.BestOfN]: Runs a module up to `N` times and returns the best prediction or the first that passes a reward threshold.
+ #link("https://dspy.ai/api/modules/MultiChainComparison/")[dspy.MultiChainComparison]: Generates multiple reasoning chains and compares them to select an answer.
+ #link("https://dspy.ai/api/modules/Refine/")[dspy.Refine]: Runs a module up to `N` times and returns the best prediction, using feedback when no threshold is met.
+ #link("https://dspy.ai/api/modules/ReAct/")[dspy.ReAct]: Builds tool-using agents through interleaved reasoning, acting, and observation.

#pagebreak()

8. #link("https://dspy.ai/api/modules/Parallel/")[dspy.Parallel]: Parallel, multi-threaded execution of (module, example) pairs.
+ #link("https://dspy.ai/api/modules/CodeAct/")[dspy.CodeAct]: Utilizes a code interpreter and predefined tools to solve the problem.
+ #link("https://dspy.ai/api/modules/ProgramOfThought/")[dspy.ProgramOfThought]: Runs Python programs to solve a problem.
+ #link("https://dspy.ai/api/modules/RLM/")[dspy.RLM]: Lets LLMs programmatically explore large contexts via a sandboxed Python REPL and recursive sub-LLM calls.

#pagebreak()

You can chain these modules together in classes that are inherited from `dspy.Module` and take two methods. You might already notice a syntactic similarity to PyTorch:

```python
class RAG(dspy.Module):
    # Declares the used submodules.
    def __init__(self, num_passages=3):
        super().__init__()

        self.retrieve = dspy.Retrieve(k=num_passages)
        self.generate_answer = dspy.ChainOfThought(GenerateAnswer)
```

#pagebreak()

```python
    # Describes the control flow among the defined sub-modules.
    def forward(self, question):
        context = self.retrieve(question).passages
        prediction = self.generate_answer(
          context=context, question=question)
        return dspy.Prediction(context=context, answer=prediction.answer)
```


#pagebreak()

The above piece of code creates the following information flow among the defined modules in the `RAG()` class:

#figure(
  image("/courses/Agentic_AI/assets/dspy_article/dspy_naive_rag_pipeline.jpg", height: 65%),
  caption: [Example code for naive RAG pipeline and resulting information flow among modules],
)

== Optimizers

*Optimizers* automatically enhance the quality and performance of your applications. They take a metric and, together with the DSPy compiler, learn to bootstrap and select effective prompts for a DSPy program's modules.

```python
from dspy.optimizers import BootstrapFewShot

# Simple optimizer example
optimizer = BootstrapFewShot(metric=dspy.evaluate.answer_exact_match)
```

#pagebreak()

At the time of writing, DSPy implements the following optimizers (see #link("https://dspy.ai/api/optimizers/")[API reference]):

+ #link("https://dspy.ai/api/optimizers/BetterTogether/")[dspy.BetterTogether]: Meta-optimizer that combines prompt and weight optimization in configurable sequences.
+ #link("https://dspy.ai/api/optimizers/BootstrapFewShot/")[dspy.BootstrapFewShot]: Composes demos/examples for a predictor's prompt from labeled and bootstrapped examples.
+ #link("https://dspy.ai/api/optimizers/BootstrapFewShotWithRandomSearch/")[dspy.BootstrapFewShotWithRandomSearch]: Bootstraps few-shot demos and runs random search over candidate programs.
+ #link("https://dspy.ai/api/optimizers/BootstrapFinetune/")[dspy.BootstrapFinetune]: Fine-tunes model weights using bootstrapped examples.
+ #link("https://dspy.ai/api/optimizers/BootstrapRS/")[dspy.BootstrapRS]: Alias for `BootstrapFewShotWithRandomSearch`.
+ #link("https://dspy.ai/api/optimizers/COPRO/")[dspy.COPRO]: Optimizes predictor signatures and instructions via coordinate ascent over prompt candidates.
+ #link("https://dspy.ai/api/optimizers/Ensemble/")[dspy.Ensemble]: Creates ensembled versions of multiple programs; a common `reduce_fn` is `dspy.majority`.

#pagebreak()

8. #link("https://dspy.ai/api/optimizers/GEPA/")[dspy.GEPA]: Reflective prompt optimizer that adaptively evolves textual components using metric scores and textual feedback.
+ #link("https://dspy.ai/api/optimizers/InferRules/")[dspy.InferRules]: Bootstraps few-shot examples and infers rules to improve predictor behavior.
+ #link("https://dspy.ai/api/optimizers/KNN/")[dspy.KNN]: k-nearest neighbors retriever that finds similar examples from a training set.
+ #link("https://dspy.ai/api/optimizers/KNNFewShot/")[dspy.KNNFewShot]: Attaches the `k` nearest neighbor training examples to the student model.
+ #link("https://dspy.ai/api/optimizers/LabeledFewShot/")[dspy.LabeledFewShot]: Uses `k` labeled training examples as few-shot demos for each predictor.
+ #link("https://dspy.ai/api/optimizers/MIPROv2/")[dspy.MIPROv2]: Jointly optimizes instructions and few-shot examples using Bayesian optimization.
+ #link("https://dspy.ai/api/optimizers/SIMBA/")[dspy.SIMBA]: Stochastic Introspective Mini-Batch Ascent; samples mini-batches and generates improvement rules or demos.

== DSPy Compiler

The DSPy compiler will internally trace your program and then optimize it using an optimizer (teleprompter) to maximize a given metric (e.g., improve quality or cost) for your task. The optimizations depend on the type of LM you are using:

+ *for LLMs*: construct high-quality few-shot prompts
+ *for smaller LMs*: train automatic finetunes

#pagebreak()

That means the DSPy compiler automatically maps the modules to high-quality compositions of prompting, finetuning, reasoning, and augmentation. #link("https://arxiv.org/abs/2310.03714")[1] Internally, the compiler simulates various versions of the program on the inputs and bootstraps example traces of each module for self-improvement to optimize the pipeline to your task. This process is similar to the training process of a neural network.

For example, while the initial prompt, the `ChainOfThought` module created earlier, may be a good starting point for any LM to understand the task, it probably isn't the optimal prompt. As you can see in the following image, the DSPy compiler optimizes the initial prompt and thus eliminates the need for manual prompt tuning.

#pagebreak()

#figure(
  image("/courses/Agentic_AI/assets/dspy_article/dspy_compiler_optimizes_initial_prompt.png", height: 85%),
  caption: [How the DSPy compiler optimizes the initial prompt (Inspired by #link("https://x.com/eshorten300/status/1754966790910726161")[Erika's post])],
)

#pagebreak()

The compiler takes the following inputs, as shown in the code and image below:

+ the program,
+ the teleprompter, including the defined validation metric, and
+ a few training samples.

#figure(
  image("/courses/Agentic_AI/assets/dspy_article/dspy_compiler.png", height: 60%),
)

#pagebreak()

```python
from dspy.teleprompt import BootstrapFewShot

# Small training set with question and answer pairs
trainset = [dspy.Example(question="What were the two main things the author worked on before college?",
                         answer="Writing and programming").with_inputs('question'),
            dspy.Example(question="What kind of writing did the author do before college?",
                         answer="Short stories").with_inputs('question'),
            ...
            ]
```

#pagebreak()

```python
# The teleprompter will bootstrap missing labels: reasoning chains and retrieval contexts
optimizer = BootstrapFewShot(metric=dspy.evaluate.answer_exact_match)

compiled_rag = optimizer.compile(RAG(), trainset=trainset)
```
