## Inference Pipeline

This lesson answers the question:

> How to process video streams?

**Inference Pipeline** is an interface made for streaming and is likely the best route to go for real time use cases. It is an asynchronous interface that can consume many different video sources including:

1. local devices (like webcams)
2. RTSP video streams
3. video files
4. ..etc.

..With this interface, you define:

1. one or more **sources** (of a video stream) and
2. one or more [**sinks**](https://inference.roboflow.com/using_inference/inference_pipeline/#sinks)

### How the [`InferencePipeline`](https://inference.roboflow.com/using_inference/inference_pipeline/#how-the-inferencepipeline-works) works?

The `InferencePipeline` is designed for robust, multi-source video processing, delegating tasks to dedicated threads to maximize throughput and stability.

![Figure: Inference Pipeline](https://media.roboflow.com/inference/inference-pipeline-diagram.jpg)


### 1.1 Video Multiplexer: Reading and Buffering

![Figure: Inference Pipeline](../assets/inference_pipeline_1.png)

- **Concurrency:** Spawns a separate consumer thread for each video source.
        
- For **Stored videos**, it just processes every frame until it is done.

- For **Live streams**: buffers accumulate frames if the compute budget is strained, ensuring the model can either:
    1. process all frames without dropping any.
    2. skip drops and just the process the most recent ones.
    
- **Auto-recovery:** video sources will be automatically re-connected once connectivity is lost during processing. That is meant to prevent failures in production environment when the pipeline can run long hours and need to gracefully handle sources downtimes.


### 1.2 Video Multiplexer: Batching

![Figure: Inference Pipeline](../assets/inference_pipeline_2.png)

- Collects incoming data into a **frames batch** based on a `batch_collection_timeout`.
    - If a source fails to provide a frame within the timeout, a smaller batch is passed forward.
    - Any missing frames (and their subsequent predictions) are safely padded with `None` before reaching the prediction stage.

### 2. Processing

![Figure: Inference Pipeline](../assets/inference_pipeline_3.png)

1. **`on_video_frame(...)`:** Runs on its own dedicated thread, serving as the execution environment for your AI model.
    
2. **`on_prediction(...)`:** Handles downstream tasks (like visualization) on a separate thread. Controlled by the `sink_mode` parameter, it can process incoming data in either:  
    - `SEQUENTIAL` mode: one element at a time or
    - `BATCH` mode: all batch elements simultaneously.

### Customizing the pipeline

See [the documentation page: Inference pipeline](https://inference.roboflow.com/using_inference/inference_pipeline/) for more details.

For post-processing, see section: [Custom Sink Tutorial](https://inference.roboflow.com/using_inference/inference_pipeline/#custom-sink-tutorial) on that same page.
