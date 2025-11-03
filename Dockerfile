# ============================================
# Base image: Ubuntu + Python 3.10 + FFmpeg
# ============================================
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Ho_Chi_Minh
ENV PYTHONUNBUFFERED=1
WORKDIR /workspace

# 1️⃣ System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.10 python3.10-dev python3-pip python3-distutils \
    git wget ffmpeg libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

RUN ln -sf /usr/bin/python3.10 /usr/bin/python
RUN python -m pip install --upgrade pip

# 2️⃣ Install numpy (locked to <2)
RUN pip install numpy==1.26.4

# 3️⃣ Install torch and torchvision
RUN pip install torch==2.0.1 torchvision==0.15.2

# 4️⃣ Install required libs manually (no deps to keep numpy intact)
RUN pip install lmdb basicsr facexlib gfpgan

# 🧩 Cài đặt OpenCV tương thích với numpy 1.x
RUN pip install opencv-python==4.7.0.72 tqdm Pillow==10.1.0

# 5️⃣ Clone and setup Real-ESRGAN
RUN git clone https://github.com/xinntao/Real-ESRGAN.git && \
    cd Real-ESRGAN && \
    pip install --no-deps -r requirements.txt && \
    python setup.py develop

# 6️⃣ Download pretrained model
RUN mkdir -p /workspace/Real-ESRGAN/models && \
    wget https://huggingface.co/alexgenovese/upscalers/resolve/main/RealESRGAN_x4plus.pth \
    -O /workspace/Real-ESRGAN/models/RealESRGAN_x4plus.pth

WORKDIR /workspace/Real-ESRGAN
CMD ["/bin/bash"]
