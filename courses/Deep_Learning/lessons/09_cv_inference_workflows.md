# Inference and Workflows

[Inference](https://inference.roboflow.com/start/overview/) is an open-source computer vision deployment hub by Roboflow. It handles model serving, video stream management, pre/post-processing, and GPU/CPU optimization so you can focus on building your application.

_Inference_ has several components that work together. The diagram below shows how they fit together:

![](https://inference.roboflow.com/images/img-inference-diagram-v1.png)

- **[inference-sdk](https://inference.roboflow.com/inference_helpers/inference_sdk/)** - Lightweight Python client for communicating with the Inference Server.
- **[inference-cli](https://inference.roboflow.com/inference_helpers/inference_cli/)** - Command-line tool for managing the Inference Server and running common tasks.
- **[Inference Server](https://inference.roboflow.com/quickstart/docker/)** - HTTP server (Docker) that wraps the `inference` package as a REST API.
- **[inference](https://inference.roboflow.com/using_inference/about/)** - Core Python package for model loading, inference, and Workflows execution.

## Features

Featres of Inference; The core Python package:

- **[Model Serving](https://inference.roboflow.com/quickstart/run_a_model)** - Object detection, classification, segmentation, keypoint detection, OCR, VQA, and more. Supports [pre-trained](https://inference.roboflow.com/quickstart/aliases), [fine-tuned](https://roboflow.com/train), and [foundation](https://inference.roboflow.com/foundation/about) models.
- **[Video Streaming](https://inference.roboflow.com/workflows/video_processing/overview)** - Efficient `InferencePipeline` for consuming camera feeds, RTSP streams, and video files with automatic frame management and state tracking.
- **[Speed](https://inference.roboflow.com/understand/features#speed)** - Automatic parallelization, hardware acceleration, dynamic batching, and optional TensorRT quantization.
- **[Extensibility](https://inference.roboflow.com/understand/features#extensibility)** - Open source (Apache 2.0). Add custom models, Workflow blocks, and backends.

## Deploy Anywhere

||[Serverless](https://docs.roboflow.com/deploy/serverless-hosted-api-v2)|[Dedicated](https://docs.roboflow.com/deploy/dedicated-deployments)|[Self-Hosted](https://inference.roboflow.com/install/)|
|---|---|---|---|
|Fine-Tuned & Pre-Trained Models|✅|✅|✅|
|Workflows|✅|✅|✅|
|Foundation Models||✅|✅|
|Video Streaming||✅|✅|
|Dynamic Python Blocks||✅|✅|
|Runs Offline|||✅|
|Billing|Per-Call|Hourly|Free + [metered](https://roboflow.com/pricing)|

- **Serverless** - Pay-per-Inference, scales to zero. Doesn't support large [foundation models](https://inference.roboflow.com/foundation/about).
- **Dedicated** - Single-tenant VMs with optional GPU. Supports larger foundation models (SAM 2, Florence-2, PaliGemma). Billed hourly.
- **Self-Hosted** - Run on your own hardware. [Install guide →](https://inference.roboflow.com/install/)
- **Bring Your Own Cloud** - Self-host on [AWS, Azure, or GCP](https://inference.roboflow.com/install/cloud/) for enterprise compliance.

See: [What Devices Can I Use?](https://inference.roboflow.com/quickstart/devices/).

## Tutorial: Hello World

Follow the [Hello World Tutorial](https://inference.roboflow.com/guides/hello-world/) (5 minutes, Easy), where you:

1. build and run a simple **Workflow** to validate that our setup is installed and working correctly
2. run inference on a computer vision model
3. visualize its output via the UI debugger
