#!/bin/bash

# Đầu vào
VIDEO="output_watermarked.mp4"
SUBTITLE="subtitles.srt"
OUTPUT="output_with_subs.mp4"

# Kiểm tra file tồn tại
if [ ! -f "$VIDEO" ]; then
    echo "❌ Không tìm thấy video: $VIDEO"
    exit 1
fi

if [ ! -f "$SUBTITLE" ]; then
    echo "❌ Không tìm thấy phụ đề: $SUBTITLE"
    exit 1
fi

# Ghép phụ đề vào video (burn-in)
ffmpeg -y -i "$VIDEO" -vf "subtitles=$SUBTITLE" -c:a copy "$OUTPUT"

echo "✅ Đã ghép phụ đề vào video: $OUTPUT"
