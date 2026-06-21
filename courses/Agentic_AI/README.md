# Agentic AI Course

**Goal**: learn best practices for building Agentic AI applications that will open up many more opportunities, whether job opportunities or the chance to build amazing software yourself.

**What you will Learn**:

- How to build agentic workflows made of swappable, debuggable, and composable modules.
- How to evaluate the performance of AI workflows in terms of latency, cost, and accuracy.
- How to optimize modules and workflows using training data; rather than manual prompt engineering.
- How to utilize the results of tried and tested methods as evident by research on Agentic AI including: _Reasoning_, _Reflection_, _Planning_, and _CodeAct_.

## M1. Introductions

1. [Overview](lessons/01_overview.md)
2. [Language Models: Large and Small, Uni- and Multi-modal](lessons/02_llms.md)
3. [Agentic Workflows and the Autonomy Spectrum](lessons/03_whats_agent.md)
4. [Agentic Patterns: what works and what doesn't according to research on LLM-based agents](lessons/04_agentic_patterns.md)

## M2. Signatures and Modules

1. [Setup](lessons/05_dspy_setup.ipynb)
2. [First Program](lessons/06_dspy_first_program.ipynb)
3. [Class-based Signature](lessons/07_dspy_class-based_signature.ipynb)
4. [Changing Modules](lessons/08_dspy_changing_modules.ipynb)
   - [Exercise: Email Extraction](exercises/email_extraction.ipynb)

Recommended: [Set up MLflow Tracing to understand what's happening under the hood](lessons/mlflow.md).

## M3. Agents with Tools

1. [ReAct Loop](lessons/09_dspy_ReAct.ipynb)
   - [Exercise: Flights Agent](exercises/flights_agent.ipynb)

## M4. Coding Agents

1. [Composing Modules](lessons/10_dspy_composing_modules.ipynb)
2. [CodeAct Loop](lessons/11_dspy_CodeAct.ipynb)
   - [Exercise: Flights Coding Agent (and Keep Conversation History)](exercises/flights_code_agent.ipynb) ([solution](exercises/flights_code_agent_solution.ipynb))

For long-term/persistent memory see [Memory-Enabled ReAct Agents with Mem0](https://dspy.ai/tutorials/mem0_react_agent/).

### M5. Optimize

1. [Evaluation and Optimization](lessons/12_dspy_evaluation_and_optimization.ipynb)
2. make evaluation dataset to optimize prompts

## M6. Retrieval Augmented Generation (RAG)

1. [What is RAG?](lessons/13_rag.md)
2. [ChromaDB: Ingestion and Querying](lessons/14_chromadb.ipynb)
   1. [Exercise: Embeddings EDA](exercises/14/visualize_embeddings.ipynb) ([solution](exercises/14/visualize_embeddings_solution.ipynb))
3. [Chunking: Searching PDF Documents](lessons/15_chunking.ipynb)
4. [RAG with DSPy](lessons/16_dspy_rag.ipynb)

## M7. Deploy

References:

- https://dspy.ai/production/
- https://dspy.ai/tutorials/deployment/
- [Three Frontends with LangGraph as a backend](https://github.com/HassanAlgoz/chatbot)

## References

- [Agentic AI Course](https://www.deeplearning.ai/courses/agentic-ai) (Andrew Ng, DeepLearningAI)
- [DSPy](https://dspy.ai/): Program, don’t prompt, your LLMs.

- Build Your Own Deep Research Agents:
  - [Full Workshop: Build Your Own Deep Research Agents - Louis-François Bouchard, Paul Iusztin, Samridhi](https://www.youtube.com/watch?v=mYSRn6PC1mc)
  - [Repo](https://github.com/iusztinpaul/designing-real-world-ai-agents-workshop)
