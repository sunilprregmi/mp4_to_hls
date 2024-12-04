@echo off
setlocal enabledelayedexpansion

:: Define bitrate and resolution profiles
set bitrate_1=1500k
set bitrate_2=3000k
set bitrate_3=5000k

set resolution_1=960x540
set resolution_2=1280x720
set resolution_3=1920x1080

:: Process all .mp4 files in the current directory
for %%f in (*.mp4) do (
    set input_file=%%f
    set filename=%%~nf
    set output_folder=%filename%

    :: Create output directory structure
    if not exist "%output_folder%" mkdir "%output_folder%"
    if not exist "%output_folder%/540p" mkdir "%output_folder%/540p"
    if not exist "%output_folder%/720p" mkdir "%output_folder%/720p"
    if not exist "%output_folder%/1080p" mkdir "%output_folder%/1080p"

    :: Generate HLS for each resolution
    ffmpeg -i "%%f" -vf "scale=%resolution_1%" -c:v h264 -b:v %bitrate_1% -c:a aac -b:a 128k -hls_time 4 -hls_playlist_type vod "%output_folder%/540p/playlist_540p.m3u8"
    ffmpeg -i "%%f" -vf "scale=%resolution_2%" -c:v h264 -b:v %bitrate_2% -c:a aac -b:a 128k -hls_time 4 -hls_playlist_type vod "%output_folder%/720p/playlist_720p.m3u8"
    ffmpeg -i "%%f" -vf "scale=%resolution_3%" -c:v h264 -b:v %bitrate_3% -c:a aac -b:a 128k -hls_time 4 -hls_playlist_type vod "%output_folder%/1080p/playlist_1080p.m3u8"

    :: Create master playlist
    echo #EXTM3U > "%output_folder%/master.m3u8"
    echo #EXT-X-STREAM-INF:BANDWIDTH=1500000,RESOLUTION=960x540 >> "%output_folder%/master.m3u8"
    echo 540p/playlist_540p.m3u8 >> "%output_folder%/master.m3u8"
    echo #EXT-X-STREAM-INF:BANDWIDTH=3000000,RESOLUTION=1280x720 >> "%output_folder%/master.m3u8"
    echo 720p/playlist_720p.m3u8 >> "%output_folder%/master.m3u8"
    echo #EXT-X-STREAM-INF:BANDWIDTH=5000000,RESOLUTION=1920x1080 >> "%output_folder%/master.m3u8"
    echo 1080p/playlist_1080p.m3u8 >> "%output_folder%/master.m3u8"

    echo Finished processing %%f. Output saved to "%output_folder%".
)

pause
