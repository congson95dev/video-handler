# Video Handler

## Overview
The Video Handler project is designed to process and manipulate video files efficiently using Real-ESRGAN (https://github.com/xinntao/Real-ESRGAN.git) as the video enhancement library. It provides functionalities to handle video frames, apply transformations, and manage input/output operations.

## Features
- Video enhance (Make video more sharp)

## Installation
To set up the project, clone the repository and install the necessary dependencies:

```bash
git clone git@github.com:congson95dev/video-handler.git
cd video-handler
docker compose up -d --build
```

## Usage
To use the Video Handler, follow these steps:

1. Add your video to the `input` folder.
2. Run this command to access docker container:
   ```bash
   docker exec -it realesrgan bash
   ```
3. Run the following command to separate frames as images:
   ```bash
   ffmpeg -i input2.mp4 -t 3 /workspace/frames/frame_%06d.png
   ```
4. Run the inference script to upscale frames:
   ```bash
   python inference_realesrgan.py --model_path models/RealESRGAN_x4plus.pth --input /workspace/frames --output /workspace/frames_up --fp32 --tile 128 --tile_pad 10
   ```
5. Combine the frames back into a video:
   ```bash
   ffmpeg -framerate 25 -start_number 1 -i /workspace/frames_up/frame_%06d_out.png -c:v libx264 -pix_fmt yuv420p /workspace/output.mp4
   ```

If you encounter an error in step 4, run the following commands to fix the Docker installation:
```bash
python -m pip uninstall -y opencv-python opencv-python-headless
python -m pip install --force-reinstall "numpy<2"
python -m pip install opencv-python==4.7.0.72
python -c "import cv2, numpy; print('cv2', cv2.__version__, 'numpy', numpy.__version__)"
```
This should return `cv2 4.7.0.72 numpy 1.26.4`. <br>
Then re-run step 4.
