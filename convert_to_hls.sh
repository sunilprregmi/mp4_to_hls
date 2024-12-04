#!/bin/bash

# Define bitrate and resolution profiles
BITRATE_1="1500k"
BITRATE_2="3000k"
BITRATE_3="5000k"

RESOLUTION_1="960x540"
RESOLUTION_2="1280x720"
RESOLUTION_3="1920x1080"

# Loop through all .mp4 files in the current directory
for input_file in *.mp4; do
    # Get the file name without extension
    filename=$(basename "$input_file" .mp4)
    output_folder="$filename"

    # Create output directory structure
    mkdir -p "$output_folder/540p"
    mkdir -p "$output_folder/720p"
    mkdir -p "$output_folder/1080p"

    # Generate HLS for each resolution
    ffmpeg -i "$input_file" -vf "scale=$RESOLUTION_1" -c:v h264 -b:v $BITRATE_1 -c:a aac -b:a 128k -hls_time 4 -hls_playlist_type vod "$output_folder/540p/playlist_540p.m3u8"
    ffmpeg -i "$input_file" -vf "scale=$RESOLUTION_2" -c:v h264 -b:v $BITRATE_2 -c:a aac -b:a 128k -hls_time 4 -hls_playlist_type vod "$output_folder/720p/playlist_720p.m3u8"
    ffmpeg -i "$input_file" -vf "scale=$RESOLUTION_3" -c:v h264 -b:v $BITRATE_3 -c:a aac -b:a 128k -hls_time 4 -hls_playlist_type vod "$output_folder/1080p/playlist_1080p.m3u8"

    # Create master playlist
    master_playlist="$output_folder/master.m3u8"
    echo "#EXTM3U" > "$master_playlist"
    echo "#EXT-X-STREAM-INF:BANDWIDTH=1500000,RESOLUTION=960x540" >> "$master_playlist"
    echo "540p/playlist_540p.m3u8" >> "$master_playlist"
    echo "#EXT-X-STREAM-INF:BANDWIDTH=3000000,RESOLUTION=1280x720" >> "$master_playlist"
    echo "720p/playlist_720p.m3u8" >> "$master_playlist"
    echo "#EXT-X-STREAM-INF:BANDWIDTH=5000000,RESOLUTION=1920x1080" >> "$master_playlist"
    echo "1080p/playlist_1080p.m3u8" >> "$master_playlist"

    echo "Finished processing $input_file. Output saved to $output_folder."
done
