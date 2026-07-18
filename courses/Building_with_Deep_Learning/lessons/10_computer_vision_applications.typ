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
    title: [Computer Vision Applications],
    subtitle: [Snapshot #sym.arrow.r Video #sym.arrow.r Action],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#let deck-image(path, width: 100%, height: 62%) = figure(
  image(path, width: width, height: height, fit: "contain"),
)

#let flow-box(fill-color, body) = box(
  fill: fill-color,
  stroke: secondary-color.lighten(35%),
  inset: 10pt,
  radius: 8pt,
  width: 100%,
  body,
)

#title-slide()

= Realtime Inference

== Overview

*Realtime* means the system processes input and reacts fast enough that the user experiences it as happening now.

#grid(
  columns: (1fr, 1fr),
  gutter: 1.2em,
  flow-box(secondary-color.transparentize(82%))[
    *Mental model* \
    A live camera feed feels interactive. A delayed batch job does not.
  ],
  flow-box(tertiary-color.transparentize(82%))[
    *Design questions* \
    1. Where does inference run? \
    2. What kind of input arrives?
  ],
)

== Two Design Axes

Every realtime inference system is shaped by two choices:

- *Where it runs:* inside your application process or behind a server boundary.
- *What it consumes:* a one-off image snapshot or a continuous video stream.

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  flow-box(secondary-color.transparentize(84%))[
    *Image snapshot* \
    Request in #sym.arrow.r prediction out
  ],
  flow-box(tertiary-color.transparentize(84%))[
    *Video stream* \
    Long-running loop #sym.arrow.r events, visuals, or actions
  ],
)

== In-Process vs Server

#link("https://inference.roboflow.com/quickstart/run_a_model/")[Running a model] may happen in one of two ways:

- *Server:* the #link("https://inference.roboflow.com/inference_helpers/inference_sdk/")[`inference-sdk`] sends requests to an #link("https://inference.roboflow.com/quickstart/docker/")[Inference Server] over HTTP.
- *In-process:* the #link("https://inference.roboflow.com/using_inference/about/")[`inference` Python package] loads and runs models directly in your process.

#table(
  columns: (1.2fr, 1fr, 1fr),
  inset: 8pt,
  stroke: .6pt + luma(80%),
  table.header([*Question*], [*In-process*], [*Server*]),
  [Where does the model live?], [Inside your Python app], [In a separate service],
  [How do you call it?], [Function / package API], [HTTP / SDK request],
  [Best when...], [You want tight local control], [Inference is one piece of a bigger system],
  [Trade-off], [Simple], [Complex integration],
)

== Inference as a Service

The most common production pattern is to treat inference as a *microservice*:

- the client sends input,
- the server returns a *response object*,
- downstream code decides what to do with that response.

That response might contain:

- detections or classifications,
- a pass/fail inspection result,
- an aggregate such as counts,
- or a visualization artifact.

Inference Workflows can be #link("https://inference.roboflow.com/start/overview/#features")[deployed anywhere].

== Image Snapshots

For image workloads, the interaction is usually *synchronous*:

- pass the image as an argument,
- wait for the model to finish,
- receive one response for that image.

#deck-image("/courses/Building_with_Deep_Learning/assets/inference_microservice.svg", height: 62%)

== Snapshot Use Cases

#deck-image("/courses/Building_with_Deep_Learning/assets/inference_image_input_applications_1.png", height: 75%)

- tagging user-uploaded images,
- checking whether a machine is configured correctly before startup,
- counting pills or parts in a still image.

== Snapshot Use Cases (Continued)

#deck-image("/courses/Building_with_Deep_Learning/assets/inference_image_input_applications_2.png", height: 75%)

- detecting wiring mismatches,
- inspecting manufactured goods against spec,
- validating that a surface is defect-free.

== Video Streams

Video changes the interface completely:

- you start a long-running visual agent,
- frames are processed in a loop until stopped,
- predictions are *polled* or *subscribed to* asynchronously.

This is why streaming systems are usually designed around *pipelines*, not single request/response calls.

#deck-image("/courses/Building_with_Deep_Learning/assets/inference_pipeline_architecture.svg", height: 45%)

== From Processing to Action

Inference can also behave like an *appliance*: a system that continuously watches video and triggers downstream behavior.

#grid(
  columns: (1.3fr, 1fr),
  gutter: 1.5em,
  [
    #deck-image("/courses/Building_with_Deep_Learning/assets/inference_appliance.svg", width: 100%),
  ],
  [
    *Common actions:* \
    - 💾 update a database, \
    - 📤 send notifications, \
    - 🔔 fire webhooks, \
    - 🚨 signal machinery or alarms.
  ],
)

== Video Stream Use Cases

#deck-image("/courses/Building_with_Deep_Learning/assets/inference_video_input_applications.png", height: 65%)

#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  [
    - measuring retail wait times,
    - flagging suspicious activity,
    - updating yard or warehouse inventory,
  ],
  [
    - collecting traffic analytics,
    - stopping a conveyor belt on jams,
    - sounding an alarm when a scrap heap overflows,
  ],
)

== Takeaway

Choose your inference setup based on use case:

- *Snapshot image*: synchronous request/response, ideal for HTTP/cloud serving.
- *Video stream*: `InferencePipeline` enables asynchronous, batched processing for real-time video.
- *Action system*: orchestrates automated workflows, integrating inference output with other systems.
