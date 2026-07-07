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
    title: [Inference and Workflows],
    subtitle: [Computer vision deployment with Roboflow Inference],
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

= Inference and Workflows

== What is Inference?

#link("https://inference.roboflow.com/start/overview/")[Inference] is Roboflow's open-source hub for *deploying computer vision systems*.

Instead of wiring every serving detail by hand, it gives you a reusable layer for:

+ model serving
+ Workflow execution
+ pre/post-processing
+ video stream handling
+ CPU/GPU optimization

#v(0.6em)
*Big idea:* you focus on the application logic, while Inference handles the operational plumbing.

== How the pieces fit together

#set text(size: 0.88em)

#grid(
  columns: (1fr, 1fr),
  gutter: 0.9em,
  compact-card(
    [#link("https://inference.roboflow.com/inference_helpers/inference_sdk/")[1. `inference-sdk`]],
    [
      Lightweight Python client for talking to an Inference Server over HTTP.
    ],
  ),
  compact-card(
    [#link("https://inference.roboflow.com/inference_helpers/inference_cli/")[2. `inference-cli`]],
    [
      Command-line entry point for setup, management, and common server tasks.
    ],
  ),
  compact-card(
    [#link("https://inference.roboflow.com/quickstart/docker/")[3. Inference Server]],
    [
      Docker-based HTTP service that exposes models and Workflows as an API.
    ],
  ),
  compact-card(
    [#link("https://inference.roboflow.com/using_inference/about/")[4. `inference` package]],
    [
      Core Python runtime for loading models and executing Workflow logic.
    ],
  ),
)

#align(center)[
  #link("https://inference.roboflow.com/images/img-inference-diagram-v1.png")[Inference ecosystem diagram]
]

#v(0.5em)
#align(center)[
  *Client tools* -> *server endpoint* -> *core runtime*
]

== What the core package gives you

#grid(
  columns: (1fr, 1fr),
  gutter: 0.9em,
  card(
    [#link("https://inference.roboflow.com/quickstart/run_a_model")[Model serving]],
    [
      Run object detection, classification, segmentation, keypoints, OCR, VQA, and more.

      Works with #link("https://inference.roboflow.com/quickstart/aliases")[pre-trained], #link("https://roboflow.com/train")[fine-tuned], and selected #link("https://inference.roboflow.com/foundation/about")[foundation] models.
    ],
  ),
  card(
    [#link("https://inference.roboflow.com/workflows/video_processing/overview")[Video streaming]],
    [
      Use `InferencePipeline` for cameras, RTSP feeds, and video files with frame management built in.
    ],
  ),
  card(
    [#link("https://inference.roboflow.com/understand/features#speed")[Speed]],
    [
      Benefit from parallelization, hardware acceleration, dynamic batching, and optional TensorRT paths.
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

== Deploy anywhere, continued

#set text(size: 0.83em)

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 0.8em,
  compact-card(
    [Serverless tradeoff],
    [
      + Scales to zero
      + Great for lightweight APIs
      + Lowest ops burden
      - Not the right home for large #link("https://inference.roboflow.com/foundation/about")[foundation models]
      - No offline operation
    ],
  ),
  compact-card(
    [Dedicated tradeoff],
    [
      + Single-tenant deployment
      + Optional GPU support
      + Supports larger models such as SAM 2, Florence-2, and PaliGemma
      - You pay for running capacity by the hour
    ],
  ),
  compact-card(
    [Self-hosted tradeoff],
    [
      + Full control over hardware and networking
      + Can run offline
      + Works in your own cloud (#link("https://inference.roboflow.com/install/cloud/")[AWS, Azure, GCP]) or on-prem
      - You own installation, scaling, and maintenance
    ],
  ),
)

== Choosing the right deployment mode

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  card(
    [Choose *serverless* when],
    [
      + requests are intermittent
      + you want the fastest time-to-value
      + the model fits a standard hosted serving profile
    ],
  ),
  card(
    [Choose *dedicated* when],
    [
      + latency and consistency matter
      + you need bigger models or a GPU
      + your workload is steady enough to justify reserved capacity
    ],
  ),
  card(
    [Choose *self-hosted* when],
    [
      + data locality or compliance rules are strict
      + you need offline or edge operation
      + you want to run on #link("https://inference.roboflow.com/install/cloud/")[AWS, Azure, GCP], or your own machines
    ],
  ),
  card(
    [Rule of thumb],
    [
      Start with the *least operationally expensive* option that satisfies the model, latency, and compliance constraints.
    ],
  ),
)

#v(0.6em)
See also: #link("https://inference.roboflow.com/quickstart/devices/")[What devices can I use?]

== First workflow: Hello World

The official #link("https://inference.roboflow.com/guides/hello-world/")[Hello World tutorial] is a fast way to validate your setup.

In about five minutes, you:

1. build and run a simple *Workflow*
2. send data through a computer vision model
3. inspect the output in the UI debugger

#v(0.6em)
*Why this matters:* before optimizing production architecture, confirm the local toolchain and Workflow execution path both work.

== Takeaway

- *Inference is the deployment layer*: It packages serving, Workflow execution, stream handling, and optimization into one system.
- *Workflows are portable*: The same logical pipeline can move across managed and self-managed deployment modes.
- *Deployment is a tradeoff*: Pick the option that matches workload shape, model size, and operational constraints.
- *Start small*: Use the #link("https://inference.roboflow.com/guides/hello-world/")[Hello World] Workflow to verify the stack before building more complex realtime systems.
