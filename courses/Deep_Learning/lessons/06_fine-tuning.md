# Fine-tuning

## How to Select the Best Model?

[LM Arena Leaderboard](https://arena.ai/leaderboard/) shows rankings based on user preferences across: Agent, Chat, Code, Image, Video tasks. See for example: [Text-to-image](https://arena.ai/leaderboard/text-to-image).

[Open Universal Arabic ASR Leaderboard](https://huggingface.co/spaces/elmresearchcenter/open_universal_arabic_asr_leaderboard): A continuous benchmark evaluating open-source architectures (e.g., Whisper variants, Conformer-CTC, Seamless-M4T) across multiple datasets including MGB-2 and Common Voice. It ranks models by Word Error Rate (WER) and Character Error Rate (CER) against specific dialects (MSA, Egyptian, Hijazi, Najdi, Khaliji) and varied acoustic conditions.

- [Open Universal Arabic Quranic ASR Leaderboard](https://huggingface.co/spaces/deepdml/open_universal_arabic_quranic_asr_leaderboard) benchmarks multi-dialect Arabic Quranic ASR models on various multi-dialect datasets.

[SILMA AI Arabic TTS Benchmark](https://huggingface.co/spaces/silma-ai/arabic-tts-benchmark): A dedicated framework for side-by-side, blind auditory assessments of Arabic speech synthesis models. It bypasses flawed automated metrics in favor of direct human preference evaluation to establish a qualitative gold standard.  

[Massive Text Embedding Benchmark (MTEB / MMTEB)](https://huggingface.co/spaces/mteb/leaderboard): The definitive standard for evaluating embedding models across retrieval, clustering, classification, and semantic textual similarity (STS). To isolate Arabic performance, filter the Hugging Face MTEB leaderboard for the "Multilingual" (MMTEB) category or specifically for Arabic evaluation subsets. High-ranking open-weight models with proven Arabic capacity currently include the `Qwen3-Embedding` family and BAAI's `bge-m3`.

## Model Training

Ready-made fine-tuning notebooks on various tasks. Pick one and modify it to your needs:

- [Official Hugging Face Notebooks 🤗](https://huggingface.co/docs/transformers/notebooks)
- [Community Notebooks](https://huggingface.co/docs/transformers/community)

[Unsloth](https://unsloth.ai/docs) has great guides for training models using different strategies.

- [Unsloth Notebooks](https://unsloth.ai/docs/get-started/unsloth-notebooks)

### Jobs on GPUs

[Hugging Face **Jobs**](https://huggingface.co/docs/hub/jobs) provide compute for AI and data workflows, allowing you to run workloads on Hugging Face infrastructure with a familiar UV & Docker-like interface. Jobs are ideal for fine-tuning AI models, running inference with GPUs, and data ingestion and processing.

You can use [Unsloth's Jobs](https://huggingface.co/datasets/unsloth/jobs) as well.

## Deploy via Inference Endpoints

[Inference Endpoints](https://huggingface.co/docs/inference-endpoints/index) is a managed service to deploy your AI model to production.

Instead of spending weeks configuring infrastructure, managing servers, and debugging deployment issues, you can focus on what matters most: your model and your users.

## Cloud Providers

For alternatives, see [Cloud Providers](cloud_providers.md).

See:

- [Text-to-Speech (TTS) Fine-tuning Guide](https://unsloth.ai/docs/basics/text-to-speech-tts-fine-tuning)
  - [Whisper Large V3 (STT)](https://colab.research.google.com/github/unslothai/notebooks/blob/main/nb/Whisper.ipynb)
- [Fine-tuning Embedding Models with Unsloth Guide](https://unsloth.ai/docs/basics/embedding-finetuning)
- [Vision Fine-tuning](https://unsloth.ai/docs/basics/vision-fine-tuning)