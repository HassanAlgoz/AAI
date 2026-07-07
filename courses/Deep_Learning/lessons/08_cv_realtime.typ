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
    title: [Realtime Computer Vision],
    subtitle: [Models, tooling, and deployment for live vision systems],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Realtime Computer Vision

== Why this lesson matters

Realtime CV is about *useful predictions under latency constraints*.

- The system must process frames quickly enough to support live decisions.
- Accuracy still matters, but *speed, memory, and deployment cost* become first-class requirements.
- This is why model families like *YOLO* dominate many production vision pipelines.

== YOLO26 at a glance

#link("https://www.ultralytics.com/")[Ultralytics] YOLO26 is a unified family of *real-time vision models* described in the #link("https://arxiv.org/abs/2606.03748")[YOLO26 paper].

It emphasizes:

- native end-to-end inference
- a lighter detection head
- an updated training recipe
- task-specific heads for multiple vision tasks

== One family, many tasks

#align(center)[
  #image("/courses/Deep_Learning/assets/ultralytics_yolo_tasks.png", height: 100%)
]
#pagebreak()

YOLO26 family supports the following tasks:

+ #link("https://docs.ultralytics.com/tasks/classify")[Classification]: Assigns a single label or category to the whole image (e.g. classifying an image as either "cat" or "dog").
+ #link("https://docs.ultralytics.com/tasks/detect")[Detection]: Identifies and localizes objects within an image by drawing bounding boxes around them. For example, finding and classifying every car or person in a traffic camera feed.
+ #link("https://docs.ultralytics.com/tasks/obb")[Oriented detection]: Similar to object detection, but allows the bounding boxes to be rotated or oriented, which is useful for accurately localizing objects that aren’t upright, such as vehicles or text at an angle.

#pagebreak()

4. *Instance and semantic segmentation:* Divides an image into segments at the pixel level.
  + #link("https://docs.ultralytics.com/tasks/semantic")[Semantic segmentation]: labels each pixel with its object class (e.g. "road", "sky").
  + #link("https://docs.ultralytics.com/tasks/segment")[Instance segmentation]: also distinguishes between different objects of the same class (e.g. two separate persons).
+ #link("https://docs.ultralytics.com/tasks/pose")[Pose / keypoint estimation]: Detects and localizes important points or "keypoints" of objects, most commonly used for estimating human pose by marking joints like elbows, knees, and ankles within an image.

== Why YOLO-style models win in practice

#quote(
  [YOLO26 is the latest evolution in the YOLO series of real-time object detectors, engineered from the ground up for *edge and low-power devices*. It removes unnecessary complexity while preserving fast, lightweight deployment.],
  attribution: [Adapted from #link("https://docs.ultralytics.com/models/yolo26")[Ultralytics YOLO26 documentation]],
)

For practitioners, the key idea is simple:

- one family
- multiple tasks
- deployment-minded design

== Realtime CV Pipeline

Model architecture (YOLO) is only half the story.

A practical realtime Computer Vision pipeline often looks like this:

1. capture a frame from camera or video stream
2. run a detector / segmenter / pose model
3. post-process predictions
4. track objects across frames
5. render or trigger downstream actions

Realtime CV is therefore both a *modeling* problem and a *systems* problem.

== Computer Vision Projects

Strong realtime CV products also need tooling around the model:

- *data ingestion* and annotation
- *training* and experiment management
  - #link("https://platform.ultralytics.com/")[Ultralytics]: model architectures (PyTorch) and the underlying training engine
- *inference serving* in production
- *post-processing* and visualization 
- *tracking* across video frames

== The Roboflow ecosystem

Roboflow focuses on the application workflow around realtime computer vision, providing an integrated set of tools and libraries for every stage:

- #link("https://app.roboflow.com/")[Roboflow App]: upload data, annotate, train, and deploy
- #link("https://universe.roboflow.com/")[Universe]: browse reusable datasets and models
- #link("https://inference.roboflow.com/")[Inference]: run models in deployment workflows
- #link("https://supervision.roboflow.com/latest/")[Supervision]: post-process and visualize predictions
- #link("https://trackers.roboflow.com/latest/")[Trackers]: track objects across frames with #link("https://trackers.roboflow.com/latest/#algorithms")[algorithms] such as SORT, ByteTrack, OC-SORT, and BoT-SORT

Each layer builds on the previous, streamlining the process from raw data to usable, realtime computer vision applications.

== Takeaways

- YOLO26 is a modern example of a *single family* spanning multiple vision tasks.
- Roboflow's ecosystem covers the workflow around deployment, not just the model.
- Realtime CV optimizes for *latency-aware usefulness*, not just benchmark accuracy.
- Tracking and post-processing are essential for stable video applications.
