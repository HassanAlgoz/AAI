# Large Language Models

## What is an LLM?

Current Agentic workflows are driven by LLMs. So we'll need to understand how they work, to build systems, debug their issues, and optimize their performance.

Remember that **Artificial Intelligence** is a field of Computer Science, studying how to automate decision making.

> An alternative path to autonomy proposed by the turning award winner who held the cheif scientist position at meta Yann LeCun's World Models (JEPA). See: [Yann LeCun's $1B Bet Against LLMs [Part 1]](https://youtu.be/kYkIdXwW2AE?si=Yx5U4p1Z3qux14j6) for more details.

## Lanuage Models

**Language Model (LM)**; generate text, which were later then used to **perform tasks** by mimicing what people would write in response to a given textual input:

| **Example**             | **Industry Term**                    | **Typical Evaluation Benchmark** |
| ---------------------------- | ------------------------------------ | -------------------------------- |
| Question -> answer           | **Open-Book / Closed-Book QA**       | MMLU, TriviaQA                   |
| Document -> translated       | **Machine Translation**              | WMT                              |
| Text -> PII in it            | **Named Entity Recognition (NER)**   | CoNLL-2003                       |
| Feature request -> code      | **Program Synthesis / Code Gen**     | HumanEval, MBPP                  |
| Grade a piece given rubric   | **LLM-as-a-Judge / Reward Modeling** | MT-Bench                         |
| Edit piece based on feedback | **Iterative Refinement**             | GSM8K                            |

For a more comprehensive listing, see: [BIG-bench](https://github.com/google/BIG-bench/blob/main/bigbench/benchmark_tasks/README.md) by Google (214 tasks in total).

Note that tasks have their own tests to estimate the generalization performance of an LLM.

### Large and Small Language Models

**Large Language Models (LLMs)** are a powerful subset of deep neural NLP models characterized by:

1. massive size (billions of parameters)
2. extensive training data (trillions of tokens)
3. ability to perform a wide range of language tasks

**Small Language Models (SLMs)** are LLMs with far fewer parameters and lower compute requirements, energy consumption, and inference speed, allowing a set of use-cases that are impossible with large models:

- **Cheaper Deployment** – Lower hardware and cloud costs make AI more accessible to startups and developers.
- **Customizability**: Easily fine-tuned for domain-specific tasks (e.g., legal document analysis).
- **On-Device AI** – No need for an internet connection or cloud services, enhancing privacy and security.

## Multi-modal Models

A _modality_ means a medium or a way in which something exists or is done.

We use our 5 sense organs to recieve sensory inputs in multiple ways (modalities):

1. 👀 eyes to see
2. 👂️ ears to hear
3. 🤝 skin to touch
4. 👃 nose to smell
5. 👅 tongue to taste

### Examples of Multimodal Tasks and Models

Specailized models have been developed to support mapping between modalities:

1. Audio + Text ("hearing" 👂️):
      - [Automatic Speech Recognition](https://huggingface.co/tasks/automatic-speech-recognition) (or Speech to Text): Virtual Speech Assistants, Caption Generation.
      - [Text to Speech](https://huggingface.co/tasks/text-to-speech): Voice assistants, Announcement Systems.
2. Vision + Text ("seeing" 👀):
      - [Visual Question Answering or VQA](https://huggingface.co/tasks/visual-question-answering): Aiding visually impaired persons, efficient image retrieval, video search, Video Question Answering, Document VQA.
      - [Image to Text](https://huggingface.co/tasks/image-to-text): Image Captioning, Optical Character Recognition (OCR), Pix2Struct.
      - [Text to Image](https://huggingface.co/tasks/text-to-image): Image Generation.
      - [Text to Video](https://huggingface.co/tasks/text-to-video): Text-to-video editing, Text-to-video search, Video Translation, Text-driven Video Prediction.

Today's LLMs moved beyond language as well. Sometimes called **VLMs (Vision-language models)** and sometimes called **Multi-modal Models (MMMs)**. Searchin through [OpenRouter Models](https://openrouter.ai/models) you can find the left-pane (and the top buttons) to filter for specific modalities.

![OpenRouter](../assets/openrouter_input_modalities.png)

Twelve models worth knowing in 2026, each with one standout strength.

1. [Llama 4 Scout](https://openrouter.ai/models?q=llama+4+scout): Meta's first natively multimodal open-weight model.

2. [DeepSeek V4](https://openrouter.ai/models?q=deepseek+v4): A Mixture-of-Experts model under MIT license with a native million-token context window. Near-frontier performance at a fraction of the cost per token.

3. [Qwen3](https://openrouter.ai/models?q=qwen3): Alibaba's flagship open-weight model with switchable thinking and non-thinking modes, all under Apache 2.0.

4. [Gemma 4](https://openrouter.ai/models?q=gemma+4): Google's open-weight family released under Apache 2.0, with the widest language coverage of any model on this list.

5. [Phi 4](https://openrouter.ai/models?q=phi+4): Microsoft’s compact model trained almost entirely on synthetic, curated data. A practical choice for edge and on-device deployment.

6. [Mistral Small 3.1](https://openrouter.ai/models?q=mistral+small+3.1): A VLM with a long context window that fits on a consumer laptop.

7. [Nemotron 3 Super](https://openrouter.ai/models?q=nemotron+3+super): NVIDIA’s hybrid MoE with a million-token context window. Fully open weights, datasets, and recipes, with strong results on agentic coding benchmarks.

8. [GLM 5.1](https://openrouter.ai/models?q=glm+5.1): The first open-weight model to top SWE-Bench Pro. Released under MIT with no commercial restrictions.

9. [Kimi K2.6](https://openrouter.ai/models?q=kimi+k2.6): Competitive with leading closed models on coding while costing far less per million tokens. Available on Hugging Face under a Modified MIT license.

10. [StarCoder2](https://openrouter.ai/models?q=starcoder2): One of the most transparent code models available.

11. [OLMo 2 (AI2)](https://openrouter.ai/models?q=olmo+2): The most complete example of open-source reproducibility on this list. Weights, training data, code, and full recipes all released under Apache 2.0.

12. [Falcon 3](https://openrouter.ai/models?q=falcon+3): A family of lightweight open-weight models built to run on a single GPU.
