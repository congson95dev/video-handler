## How to use

Grant permission to the scripts
```
chmod +x split_videos.sh
chmod +x merge_videos.sh
chmod +x add_watermark.sh
chmod +x add_subtitles.sh
```

Changing config in each scripts

Then run script based on your demand:
- Split videos to sub-videos with 5s each
```
./split_videos.sh 
```

- Shuffle the above sub-videos and merge them (with multiple pretty transitions)
```
./merge_videos.sh
```
- Add watermark to video
```
./add_watermark.sh
```
- Add subtitles (file .srt) to video
```
./add_subtitles.sh
```