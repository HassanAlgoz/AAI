#import "@preview/touying:0.6.1": *

#import "/template/theme.typ": *

#show: university-theme.with(
  config-colors(
    primary: primary-color,
    secondary: secondary-color,
    tertiary: tertiary-color,
    neutral-darkest: text-color,
  ),
  config-info(
    title: [Deep Learning Ecosystem],
    subtitle: [Open-weight models and the Hugging Face platform],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Deep Learning Ecosystem

== Overview

This course is *applied deep learning*.

- *Deep learning* focuses on representation learning for high-volume, low-signal, mostly unstructured data: images, audio, text, and video. #pause
- The theory behind it draws on: linear algebra, probability, calculus, and optimization. #pause
- In practice, we often build with existing model ecosystems instead of training every model from scratch.

== What This Course Emphasizes

Rather than starting from low-level framework internals, we will focus on *open-weight models* and the workflows around them.

+ *Choose* the right model for a task.
+ *Use* it through a clean API.
+ *Fine-tune* it for a domain-specific task.
+ *Save* and version model artifacts.
+ *Deploy* it for real users or downstream systems.

#align(center)[
  #box(
    stroke: 1pt + primary-color,
    radius: 6pt,
    inset: 0.7em,
  )[
    *Mental model:* in this course, model ecosystems matter as much as model architecture.
  ]
]

== What Are Open Weights?

#definition("open weights")[
  The released *weights and biases* of a trained neural network.
]

- These learned parameters determine how the model maps inputs to outputs.
- When shared under an approved license, they let others:
  - inspect capabilities
  - run inference
  - fine-tune for new tasks
  - deploy the model in their own systems

See also: #link("https://opensource.org/ai/open-weights")[Open Weights at opensource.org]

== Open Weights vs Open Source AI

#v(0.6em)

// #set text(size: 0.82em)
#table(
  columns: (1.4fr, 1fr, 1fr),
  align: (left, left, left),
  table.header(
    [*Feature*],
    [*Open Weights*],
    [*Open Source AI*],
  ),
  [Weights and biases], [Released], [Released],
  [Training code], [Often not shared], [Fully shared],
  [Intermediate checkpoints], [Usually withheld], [Ideally available],
  [Training dataset], [Not shared or undisclosed], [Released or documented],
  [Data composition], [Partial disclosure], [Full disclosure],
)

#v(0.6em)
- *Key idea:* open weights improve reuse; open-source AI aims for much deeper reproducibility and transparency.

== What Is Hugging Face?

#figure(
  image("/courses/Building_with_Deep_Learning/assets/huggingface_hub.png", width: 100%),
  caption: [Hugging Face is a *central platform* for the modern deep learning ecosystem.]
)

== Why Hugging Face Matters

Hugging Face is a *central platform* for the modern deep learning ecosystem.

+ Discover models and datasets.
+ Reuse work shared by the community.
+ Publish your own checkpoints, demos, and data.

It is especially valuable in an applied course because it turns state-of-the-art research into something accessible for everyone.

== Open-weight Models on Hugging Face

#grid(
  columns: (1.1fr, 0.9fr),
  gutter: 1em,
  [
    - Each model is usually associated with a *task* or pipeline type.
    - The task tells you the expected:
      - *input* shape
      - *output* shape
      - related *inference parameters*
  ],
  [
    #figure(
      image("/courses/Building_with_Deep_Learning/assets/tasks.png", width: 100%),
      caption: [Use task filters to find checkpoints that match the problem you want to solve.],
    )
  ],
)

== The Models Timeline

#figure(
  image("/courses/Building_with_Deep_Learning/assets/timeline.png", width: 78%),
  caption: [Useful bird's-eye view of the latest models.],
)

== Discovering Models Across Time

- The ecosystem changes quickly across text, vision, audio, video, and multimodal systems.
- A timeline view helps you see:
  - how architectures evolved
  - which model families arrived when
  - which became models are more recent

== Reading a Model Card

When you open a model page, start with the *model card*.

+ Repository name, such as #link("https://huggingface.co/openai/whisper-large-v3-turbo")[`openai/whisper-large-v3-turbo`]
+ Download activity and community usage
+ Parameter count, precision, and variants
+ Description of the intended inputs and outputs
+ Usage examples and setup instructions
+ Fine-tuning notes, limitations, and references

== Model Card: What You Look For

- *Task fit*: Does the checkpoint solve the problem you actually have?
- *Input and output contract*:
  - speech #sym.arrow.r.double text
  - image #sym.arrow.r.double label
  - text #sym.arrow.r.double text
- *Memory*: Can your hardware load it (precision #sym.times size)?
- *Adaptation*: Is there guidance for fine-tuning or domain transfer?
- *Deployment*: Are there Spaces, examples, or community integrations already built around it?

On many model pages, the right column also points you to *Spaces using this model*, which is a fast way to inspect real demos.

== Colab

- Great for trying notebooks without local setup.
- Useful when you needd GPUs (almost always with deep learning models).
- Example: #link("https://colab.research.google.com/github/HassanAlgoz/AAI/blob/main/courses/Building_with_Deep_Learning/lessons/youtube_whisper.ipynb")[YouTube Video Transcription with Whisper]

== Spaces: Hosted Inference and Demos

- *Spaces* are hosted AI demos with #link("https://gradio.app/")[Gradio] UIs.
- A Space can turn a model into a simple user-facing application, making them useful for:
  - rapid prototyping
  - portfolio demos
  - internal tools
  - sharing reproducible examples with others

#figure(
  image("/courses/Building_with_Deep_Learning/assets/hf_spaces.png", height: 38%),
  caption: [#link("https://huggingface.co/spaces")[Spaces] let the community package models behind simple interfaces.],
)

== Two Common Compute Patterns

- *ZeroGPU*: shared infrastructure (users pay to use it)
- *Dedicated GPU*: paid, always-on hardware (developer pays for users to use it)

== Explore Community Projects

The Hub is also a map of *research groups, startups, and open communities* working on specific domains and languages.

Examples relevant to Arabic NLP and regional AI work:

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    - #link("https://huggingface.co/humain-ai")[HUMAIN]
    - #link("https://huggingface.co/KFUPM-JRCAI")[KFUPM-JRCAI]
    - #link("https://huggingface.co/KAUST")[KAUST]
    - #link("https://huggingface.co/QCRI")[QCRI]
    - #link("https://huggingface.co/MBZUAI")[MBZUAI]
  ],
  [
    - #link("https://huggingface.co/CAMeL-Lab")[CAMeL Lab]
    - #link("https://huggingface.co/core42")[Core42]
    - #link("https://huggingface.co/tarteel-ai")[Tarteel AI]
    - #link("https://huggingface.co/NAMAA-Space")[NAMAA Community]
  ],
)

== Takeaways

+ Deep learning applications often begin with *reusing* strong existing models.
+ *Open weights* make adaptation and deployment practical even when full training artifacts are unavailable.
+ *Hugging Face* is the main discovery, sharing, and deployment hub for this workflow.
+ *Model cards, task filters, Colab, and Spaces* are core tools for choosing and validating models quickly.
