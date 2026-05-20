## Learning session structure

- Introductions
  - Briefly define what the lesson is and what it isn't.
  - Motivation
    - If new content:
      - tell: story, statistics, or an analytical logical argument.
      - Show applcations
      - How did we get here? (previous methods)
    - Else If connected to previous lessson: show how it connects.
- Outline: the sequence of top-level topics
- *Main Content*
- Conclusion
- Glossary of Terms

## What's the *Main Content*?

Types of Explained Ideas in Computer Science and Software Engineering:

Basically, we explain methods of computation:

1. adjusted to some specific level of detail
2. primitive and composed
3. sequential and concurrent

..where logic is done through action, which we'll call a *step*:

1. A step could be to load a value into a register, when the assumption is Assembly compiler and toolchain.  
  
2. A step could also be represent the meaning of a sentence, where the input is text and the output is vector embeddings. 
  
Before focusing on the details, we usually want to look at the bigger picture, the start and the finish. This comes in many forms in programming:

1. Data Structures and Algorithms (abstract) where the goal is efficient storage and read/write operations on stored items.
2. Application functions (more applied compared to the previous one) which can be seen in programming languages as:
  1. A library (or a set of libraries) of utility functions that are usually flat and not composed, rather, a toolkit, a set of functions where each one is independent of the others. Example: Python's built-in standard library and how it works with the language itself.
  2. A framework of related methods that work together to achieve specific results. They are composed in very specific ways. Here we teach the way of thinking as laid out by this framework. Example: `numpy`, `pandas`, `scikit-learn`, or `HuggingFace`.

## Lessons

*Level*: Start by clarifying the assumptions that the lecture will build upon. This way we can align the lesson with the student level, but, in a way that keeps desirable difficulty, which motivates the neurons of the brain to acquire new knowledge and skills, such that it doesn't become boring.

*New Concepts*: The human brain cannot learn and retain more than 5-10 new concepts per lesson, depending on the inter-conntectedness between them, and priors. As such, you shall review each lesson, and break them down if they feel overwhelming; all the way until they meet the requirement of desirable difficulty, but not exceed it.

*Simple Concepts*: Based on the level of the learner (and lesson level), simpler concepts become very easy to digest, and so feel free to build on them. Even more so, the assumptions.

### Design: Theoretical

A description of the program modules, the flowchart in which they are sequenced and loops that would scaffold later into execution, as assumed to be possible by current systems.

This is where programmers enumerates possibilities, computational complexity in terms of compute and storage, discuss them as much as needed, eliminate unnecessary steps, aggregate from multiple design choices, and pick the best.

## Practice

*Gap between theory and practice*: As the gap between theory and application widens, as less and less effective the teaching becomes. On the other hand, if the gap is to tight, then there is no build up of mental models and conceptual idea connection; it becomes so dull and mechanical. To strike the sweet middle point, a practice session should be held right after each lesson.

*Progressively Less Supervision*: This means the earlier lessons should have more details, and earlier labs, more step-by-step guidance and references of where to find information from the docs. At later stages, to aid the learner in acquiring autonomy and mastey of knowledge and skills, both later lessons and practice sessions needs to build up on previous ones, with fewer hints and less hand-holding. To apply this we may go throgh these 5 phases:

### 1. Predict / Tracing

Step 1. Provide a snippet of code and ask specific questions about what will happen upon execution.

Step 2. Provide a modified version of the previous code snippet, and ask the student to predict the change in output.

Note: if the code snippet is longer than 20 lines, we'll just show the important highlights of the code, and no need to provide a full working code snippet. Just show what's important to assess whether the student knows how this affects the output.

### 2. Change

Ask the student to change the code, to get a desired output instead of the current state of code.

### 4. Composition

#### 4.1 Library  (one library / one framework)

Given a set of building blocks, which, in case of programming, would be functions, defined or imported, the student is asked to assemble a working program that satisfied a well-defined input-output test table of cases.

##### 4.1.a Exploring other capabilities of the library / framework

Given a library / framework, the student shall be able to look up the answer to their inquiry about it:

1. What does the function do? (docs: API reference; parameters, return value, examples, ..etc.)
2. What's the mental model behind this framework? (docs: concepts pages)
3. It's too hard for me to see how components fit together. Where can I find examples in which it does? (docs: guides, tutorials, cookbook, examples gallery)

#### 4.2 Integration (2+ libraries / 2+ frameworks)

The student is able to synthesize bigger programs by using both primitive and composed units. Example:

1. higher-level and lower-level like:
  - `pandas` and `numpy`
  - `scikit-learn` and `AutoGluon`
2. integrations like:
  - `datasets` (HuggingFace) with `pandas` or `scikit-learn`
  - `langchain` and `openrouter`
  - `docling` and `HuggingFace`

This demonstrate their ability to work at different levels of abstractions simultaneously which is a highly relevant skill for any software engineer.

#### 4.3 System Integration

Programs that communicate over IPC or the Network. Also known as distributed system.

Examples:

- Frontend system (view): `chainlit` or Telegram Bot or `textual`
- Backend system (model/state): `langgraph`
- Storage system (persistence): `sqlite` or `chromadb`

### 5. Debug

Given a working program and a well-defined set of test cases, the student is able to break the cases one by one, by commenting out the code responsible for the output of each case. This demonstrates high analytical skill in the student, and a good understanding of the mental model represented in the program.

## Apply

### 1. Refine

#### 1.1 Review

This is the task of: given a  sub-optimal program. Perhaps, the programmer was being overly specific when a more general approach would work, or vice-versa. Maybe they've used the wrong terms. Or they left out cruicial information. Of course the previous are just examples of what may go wrong, but in general, the idea here is that the student is tasked with the role of being a reviewer of some some code, and he should do it properly; spotting issues and leaving actionable comments.

### 1.2 Improve

Simplification of a complex program is an example of imporvement. This is usually done through refactoring, or a library function instead of building from scratch. Or Perhaps using composition instead of repeating yourself. And so on. Of course these also are just examples of many improvements that a student is tasked with doning, given a potentially improveable program.

### 2. Collaborate

Collaboration to achieve higher productivity, requires planning coordination in the execution of coding tasks such that we don't step on eachothers' toes.

1. Define roles:
  1. design
  2. coding
      1. frontend
      2. backend
  3. reviewing (peers and seniors)
  4. development and deployment, infrastructure / environment
1. figure out the dependency between coding tasks
2. assign coding tasks to team members

...etc.
