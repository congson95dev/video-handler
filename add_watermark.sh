#!/bin/bash

# Đầu vào
INPUT="output.mp4"
LOGO="logo.png"
OUTPUT="output_watermarked.mp4"

# Kiểm tra file tồn tại
if [ ! -f "$INPUT" ]; then
    echo "Không tìm thấy file video: $INPUT"
    exit 1
fi

if [ ! -f "$LOGO" ]; then
    echo "Không tìm thấy file logo: $LOGO"
    exit 1
fi

# Chèn watermark (logo ở góc dưới bên phải, cách viền 10px)
ffmpeg -y -i "$INPUT" -i "$LOGO" -filter_complex "[1:v]scale=100:-1[logo];[0:v][logo]overlay=W-w-10:H-h-10" -codec:a copy "$OUTPUT"
