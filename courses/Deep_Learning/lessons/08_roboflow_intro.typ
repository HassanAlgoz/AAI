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
    title: [Introduction to Computer Vision Tasks],
    subtitle: [Roboflow Ecosystem and YOLO],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Computer Vision Applications

== Overview

Computer Vision Applications are about *useful predictions under latency constraints*.

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

== Computer Vision Projects

Strong realtime CV products also need tooling around the model:

- *data ingestion* and annotation
- *training* and experiment management
  - #link("https://platform.ultralytics.com/")[Ultralytics]: model architectures (PyTorch) and the underlying training engine
- *inference serving* in production
- *post-processing* and visualization 
- *tracking* across video frames

== The Roboflow ecosystem

#link("https://docs.roboflow.com/")[Roboflow] focuses on the application workflow around realtime computer vision, providing an integrated set of tools and libraries for every stage:

=== Dataset, Model, Training, and Deployment #pause

- #link("https://app.roboflow.com/")[Roboflow App]: upload data, annotate, train, and deploy
- #link("https://universe.roboflow.com/")[Universe]: browse reusable datasets and models
  - #link("https://docs.roboflow.com/annotate/annotation-tools")[Roboflow Annotate]: provides a fast, robust interface through which you can annotate images, manually or with AI.
  - #link("https://rapid.roboflow.com/")[Roboflow Rapid]: lets you go from raw data to a ready-to-use object detection API in five minutes.

#pagebreak()
=== Inference Workflows #pause

- #link("https://inference.roboflow.com/")[Inference]: run models in deployment workflows
- #link("https://supervision.roboflow.com/latest/")[Supervision]: post-process and visualize predictions
- #link("https://trackers.roboflow.com/latest/")[Trackers]: track objects across frames with #link("https://trackers.roboflow.com/latest/#algorithms")[algorithms] such as SORT, ByteTrack, OC-SORT, and BoT-SORT

Each layer builds on the previous, streamlining the process from raw data to usable, realtime computer vision applications.

== Takeaways

- YOLO26 is a modern example of a *single family* spanning multiple vision tasks.
- Roboflow's ecosystem covers the workflow around deployment, not just the model.
- Realtime CV optimizes for *latency-aware usefulness*, not just benchmark accuracy.
- Tracking and post-processing are essential for stable video applications.
