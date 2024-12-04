#!/bin/bash

# Function to calculate time difference
function calculate_time_diff {
    start_time=$1
    end_time=$2
    elapsed=$((end_time - start_time))
    hours=$((elapsed / 3600))
    minutes=$(( (elapsed % 3600) / 60 ))
    seconds=$((elapsed % 60))
    printf "%02d:%02d:%02d\n" $hours $minutes $seconds
}

# Detect the first MP4 file in the current directory
input_file=$(ls *.mp4 2>/dev/null | head -n 1)
if [ -z "$input_file" ]; then
    echo "No MP4 file found in the current directory."
    exit 1
fi

# Extract the base name (without extension) to create the output folder
filename=$(basename "$input_file" .mp4)
output_folder="$filename"

# Create the output folder
mkdir -p "$output_folder"

# Define bitrate and resolution profiles
bitrate_1="1500k"
bitrate_2="3000k"
bitrate_3="5000k"

resolution_1="960x540"
resolution_2="1280x720"
resolution_3="1920x1080"

# Record the start time
start_time=$(date +%s)

# Generate HLS streams for each profile
ffmpeg -i "$input_file" -vf "scale=$resolution_1" -c:v h264 -b:v $bitrate_1 -c:a aac -b:a 128k -hls_time 4 -hls_playlist_type vod "$output_folder/playlist_540p.m3u8"
ffmpeg -i "$input_file" -vf "scale=$resolution_2" -c:v h264 -b:v $bitrate_2 -c:a aac -b:a 128k -hls_time 4 -hls_playlist_type vod "$output_folder/playlist_720p.m3u8"
ffmpeg -i "$input_file" -vf "scale=$resolution_3" -c:v h264 -b:v $bitrate_3 -c:a aac -b:a 128k -hls_time 4 -hls_playlist_type vod "$output_folder/playlist_1080p.m3u8"

# Create master playlist
cat <<EOL > "$output_folder/master.m3u8"
#EXTM3U
#EXT-X-STREAM-INF:BANDWIDTH=1500000,RESOLUTION=960x540
playlist_540p.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=3000000,RESOLUTION=1280x720
playlist_720p.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=5000000,RESOLUTION=1920x1080
playlist_1080p.m3u8
EOL

# Record the end time
end_time=$(date +%s)

# Calculate and display the total execution time
execution_time=$(calculate_time_diff $start_time $end_time)
echo "Conversion complete! HLS files are saved in the '$output_folder' folder."
echo "Total execution time: $execution_time"
