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
    title: [Computer Vision Inference and Deployment],
    subtitle: [],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#let card(title, body, fill: rgb("#F5FAF5")) = block(
  inset: 0.6em,
  radius: 8pt,
  stroke: 1pt + primary-color.lighten(45%),
  fill: fill,
)[
  #text(weight: "bold", fill: primary-color)[#title]
  #v(0.35em)
  #body
]

#let compact-card(title, body) = card(
  title,
  [
    #set text(size: 0.88em)
    #body
  ],
)

#title-slide()

= Computer Vision Inference Pipelines

== Overview

The YOLO model is one part of a bigger system:

1. capture a frame from camera or video stream
2. run a detector / segmenter / pose *model* (YOLO)
3. post-process predictions
4. track objects across frames
5. render or trigger downstream actions

In practice, computer vision is therefore both a *modeling* problem and a *systems* problem.

== Roboflow Inference Library

#link("https://inference.roboflow.com/start/overview/")[Inference] is Roboflow's open-source hub for *deploying computer vision systems*.

Instead of wiring every serving detail by hand, it gives you a reusable layer for: #pause

+ model *serving* (client-server communication) #pause
+ *Workflow* execution (business logic) #pause
+ *video stream* handling (I/O) #pause
+ *pre/post-processing* (per-frame logic) #pause
+ *CPU/GPU* optimization (performance)

#v(0.6em)
*Big idea:* you focus on the application logic (*Workflow*), while `Inference` handles the rest.

== How the pieces fit together

#set text(size: 0.88em)

#grid(
  columns: (1fr, 1fr),
  gutter: 0.9em,
  compact-card(
    [#link("https://inference.roboflow.com/inference_helpers/inference_sdk/")[1. `inference-sdk`]],
    [
      Lightweight Python client for talking to an Inference Server over HTTP. #pause 
    ],
  ),
  compact-card(
    [#link("https://inference.roboflow.com/inference_helpers/inference_cli/")[2. `inference-cli`]],
    [
      Command-line entry point for setup, management, and common server tasks. #pause 
    ],
  ),
  compact-card(
    [#link("https://inference.roboflow.com/quickstart/docker/")[3. Inference Server]],
    [
      Docker-based HTTP service that exposes models and Workflows as an API. #pause 
    ],
  ),
  compact-card(
    [#link("https://inference.roboflow.com/using_inference/about/")[4. `inference` package]],
    [
      Core Python runtime for loading models and executing Workflow logic. #pause 
    ],
  ),
)

#align(center)[
  #link("https://inference.roboflow.com/images/img-inference-diagram-v1.png")[Inference ecosystem diagram]
]

#v(0.5em)
#align(center)[
  Client #sym.arrow.r Server Endpoint #sym.arrow.r *Core Runtime*
]

== Core Runtime

#grid(
  columns: (1fr, 1fr),
  gutter: 0.9em,
  card(
    [#link("https://inference.roboflow.com/quickstart/run_a_model")[Model serving]],
    [
      Run object detection, classification, segmentation, keypoints, OCR, VQA, and more.

      Works with #link("https://inference.roboflow.com/quickstart/aliases")[pre-trained], #link("https://roboflow.com/train")[fine-tuned], and selected #link("https://inference.roboflow.com/foundation/about")[foundation] models. #pause
    ],
  ),
  card(
    [#link("https://inference.roboflow.com/workflows/video_processing/overview")[Video streaming]],
    [
      Use `InferencePipeline` for cameras, RTSP feeds, and video files with frame management built in. #pause
    ],
  ),
  card(
    [#link("https://inference.roboflow.com/understand/features#speed")[Speed]],
    [
      Benefit from parallelization, hardware acceleration, dynamic batching, and optional TensorRT paths. #pause
    ],
  ),
  card(
    [#link("https://inference.roboflow.com/understand/features#extensibility")[Extensibility]],
    [
      The stack is open source, so you can add custom models, custom Workflow blocks, and new backends.
    ],
  ),
)

== Deploy anywhere

The deployment question is *where should it run?*

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 0.8em,
  card(
    [#link("https://docs.roboflow.com/deploy/serverless-hosted-api-v2")[Serverless]],
    [
      *Best for:* simple request-response inference with spiky demand.

      *Billing:* per call (#link("https://roboflow.com/pricing")[metered]).
    ],
    fill: rgb("#F7FCF5"),
  ),
  card(
    [#link("https://docs.roboflow.com/deploy/dedicated-deployments")[Dedicated]],
    [
      *Best for:* heavier models and steadier production workloads.

      *Billing:* hourly VM.
    ],
    fill: rgb("#F5FBFC"),
  ),
  card(
    [#link("https://inference.roboflow.com/install/")[Self-hosted]],
    [
      *Best for:* local hardware, offline operation, and strict infrastructure control.

      *Billing:* your own stack. See the #link("https://inference.roboflow.com/install/")[install guide].
    ],
    fill: rgb("#F8F8FD"),
  ),
)

#v(0.6em)
All three support *fine-tuned models*, *pre-trained models*, and *Workflows*.

See also: #link("https://inference.roboflow.com/quickstart/devices/")[What devices can I use?]

== First workflow: Hello World

The official #link("https://inference.roboflow.com/guides/hello-world/")[Hello World tutorial] is a fast way to validate your setup.

In about five minutes, you:

1. build and run a simple *Workflow*
2. send data through a computer vision model
3. inspect the output in the UI debugger
