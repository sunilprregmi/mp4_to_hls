@echo off
setlocal enabledelayedexpansion

:: Get the base name of the input file (without extension)
for %%F in (*.*) do (
    set filename=%%~nF
    goto :process_file
)

:process_file
:: Input file (using the automatically found file)
set input_file=%filename%.mp4

:: Output folder based on the input file name
set output_folder=%filename%

:: Create output folder
if not exist "%output_folder%" mkdir "%output_folder%"

:: Define bitrate profiles
set bitrate_1=1500k
set bitrate_2=3000k
set bitrate_3=5000k

:: Define resolution profiles
set resolution_1=960x540
set resolution_2=1280x720
set resolution_3=1920x1080

:: Start timer
set start_time=%time%

:: Create HLS for each profile
ffmpeg -i "%input_file%" -vf "scale=%resolution_1%" -c:v h264 -b:v %bitrate_1% -c:a aac -b:a 128k -hls_time 4 -hls_playlist_type vod "%output_folder%/playlist_540p.m3u8"
ffmpeg -i "%input_file%" -vf "scale=%resolution_2%" -c:v h264 -b:v %bitrate_2% -c:a aac -b:a 128k -hls_time 4 -hls_playlist_type vod "%output_folder%/playlist_720p.m3u8"
ffmpeg -i "%input_file%" -vf "scale=%resolution_3%" -c:v h264 -b:v %bitrate_3% -c:a aac -b:a 128k -hls_time 4 -hls_playlist_type vod "%output_folder%/playlist_1080p.m3u8"

:: Create master playlist
echo #EXTM3U > "%output_folder%/master.m3u8"
echo #EXT-X-STREAM-INF:BANDWIDTH=1500000,RESOLUTION=960x540 >> "%output_folder%/master.m3u8"
echo playlist_540p.m3u8 >> "%output_folder%/master.m3u8"
echo #EXT-X-STREAM-INF:BANDWIDTH=3000000,RESOLUTION=1280x720 >> "%output_folder%/master.m3u8"
echo playlist_720p.m3u8 >> "%output_folder%/master.m3u8"
echo #EXT-X-STREAM-INF:BANDWIDTH=5000000,RESOLUTION=1920x1080 >> "%output_folder%/master.m3u8"
echo playlist_1080p.m3u8 >> "%output_folder%/master.m3u8"

:: End timer
set end_time=%time%

:: Calculate execution time
call :GetTimeDifference "%start_time%" "%end_time%"

echo Conversion complete! HLS files are saved in the "%output_folder%" folder.
echo Total execution time: %execution_time%
pause
exit

:GetTimeDifference
:: Function to calculate the time difference
set start=%1
set end=%2
set /a start_seconds=(1%start:~0,2%-100)*3600+(1%start:~3,2%-100)*60+(1%start:~6,2%-100)
set /a end_seconds=(1%end:~0,2%-100)*3600+(1%end:~3,2%-100)*60+(1%end:~6,2%-100)
set /a diff_seconds=end_seconds-start_seconds

:: Calculate hours, minutes, seconds
set /a hours=diff_seconds / 3600
set /a minutes=(diff_seconds %% 3600) / 60
set /a seconds=diff_seconds %% 60

:: Format output as HH:MM:SS
if %hours% lss 10 set hours=0%hours%
if %minutes% lss 10 set minutes=0%minutes%
if %seconds% lss 10 set seconds=0%seconds%

set execution_time=%hours%:%minutes%:%seconds%
exit /b
