#!/bin/bash

# Bật chế độ nullglob để glob không match gì sẽ trả về chuỗi rỗng
shopt -s nullglob

# Thời gian chia nhỏ video (giây)
time_to_split=5

# Danh sách các đuôi file bạn muốn xử lý
extensions=("mp4" "mov" "mkv")

for ext in "${extensions[@]}"; do
  files=(*."$ext")

  # Bỏ qua nếu không có file nào với đuôi này
  if [ ${#files[@]} -eq 0 ]; then
    continue
  fi

  # Xử lý từng file
  for video in "${files[@]}"; do
    base=$(basename "$video" | sed 's/\.[^.]*$//')
    mkdir -p "$base"
    
    echo "🔧 Splitting $video into 5s segments..."
    ffmpeg -i "$video" -c copy -map 0 -f segment -segment_time ${time_to_split} -reset_timestamps 1 "$base/out%03d.mp4"
  done
done
