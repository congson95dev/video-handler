#!/bin/bash

# Đường dẫn tới 2 thư mục chứa video nhỏ
FOLDER1="video1"
FOLDER2="video2"

# Lấy tất cả video từ 2 thư mục, trộn lẫn và lưu vào mảng
VIDEO_FILES=($(find "$FOLDER1" "$FOLDER2" -type f \( -iname "*.mp4" -o -iname "*.mov" -o -iname "*.mkv" \) | shuf))

# Liệt kê video đã tìm thấy
echo "List videos sau khi shuffle:"
for ((i=0; i<${#VIDEO_FILES[@]}; i++)); do
    FILE=${VIDEO_FILES[$i]}
    echo ${FILE}
done


# Kiểm tra số lượng video
if [ ${#VIDEO_FILES[@]} -lt 2 ]; then
    echo "Cần ít nhất 2 video để ghép. Thoát."
    exit 1
fi

# Tạo danh sách input cho ffmpeg
INPUTS=()
for FILE in "${VIDEO_FILES[@]}"; do
    INPUTS+=("-i" "$FILE")
done

# Danh sách hiệu ứng chuyển cảnh
TRANSITIONS=("fade" "wipeleft" "wiperight" "slideup" "slidedown" "circlecrop" "distance" "fadeblack" "fadewhite" "radial")

# Build filter_complex
FILTERS=""
LABELS=()

# Chuẩn hóa từng video
for ((i = 0; i < ${#VIDEO_FILES[@]}; i++)); do
    FILTERS+="[$i:v]fps=60,scale=1280:720:force_original_aspect_ratio=decrease,"
    FILTERS+="pad=1280:720:(ow-iw)/2:(oh-ih)/2[v$i];"
    LABELS+=("v$i")
done

# Ghép video bằng xfade
DURATION_XFADE=1
OFFSET=0
TMP_LABEL=""

for ((i = 0; i < ${#LABELS[@]} - 1; i++)); do
    # Lấy độ dài video trước
    DUR_PREV=$(ffprobe -v error -select_streams v:0 -show_entries format=duration \
        -of default=noprint_wrappers=1:nokey=1 "${VIDEO_FILES[$i]}")
    DUR_PREV=${DUR_PREV%.*}

    # Chọn hiệu ứng ngẫu nhiên
    TRANSITION=${TRANSITIONS[$((RANDOM % ${#TRANSITIONS[@]}))]}

    echo "Chuyển cảnh $i: $TRANSITION"

    # Tính offset hiện tại
    if [ $i -eq 0 ]; then
        OFFSET=$(echo "$DUR_PREV - $DURATION_XFADE" | bc)
        FILTERS+="[${LABELS[$i]}][${LABELS[$((i + 1))]}]xfade=transition=$TRANSITION:duration=$DURATION_XFADE:offset=$OFFSET[vx1];"
        TMP_LABEL="vx1"
    else
        OFFSET=$(echo "$OFFSET + $DUR_PREV - $DURATION_XFADE" | bc)
        NEXT_IDX=$((i + 1))
        OUT_LABEL="vx$((i + 1))"
        FILTERS+="[$TMP_LABEL][${LABELS[$NEXT_IDX]}]xfade=transition=$TRANSITION:duration=$DURATION_XFADE:offset=$OFFSET[$OUT_LABEL];"
        TMP_LABEL="$OUT_LABEL"
    fi
done

# Remove dấu ; cuối cùng nếu có
FILTERS="${FILTERS%;}"

# Output file name
OUTPUT="output.mp4"

# Chạy ffmpeg
ffmpeg -y "${INPUTS[@]}" -filter_complex "$FILTERS" -map "[$TMP_LABEL]" -c:v libx264 -crf 23 -preset veryfast ${OUTPUT}