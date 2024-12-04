
# MP4 To Multi-Bitrate HLS Converter

A simple script to convert **MP4 files** into **multi-bitrate HLS** format with adaptive streaming. The script processes multiple videos in the current directory, creates individual folders for each video, and organizes resolution-specific playlists into separate subfolders. It supports **Windows** (Batch script) and **Linux** (Shell script).

---

## Features
- Automatically detects `.mp4` files in the current directory.
- Creates a dedicated folder for each video with resolution-specific subfolders:
  ```
  title/
  ├── master.m3u8
  ├── 540p/
  │   └── playlist_540p.m3u8
  ├── 720p/
  │   └── playlist_720p.m3u8
  ├── 1080p/
      └── playlist_1080p.m3u8
  ```
- Supports resolutions: **1080p**, **720p**, and **540p**.
- Generates adaptive **HLS playlists** with a master playlist (`master.m3u8`).

---

## Installation

### Windows
1. **Install FFmpeg**:
   - Download FFmpeg from the [official website](https://ffmpeg.org/download.html).
   - Extract the files and add the `bin` folder to your system's `PATH`.
2. Place the `convert_to_hls.bat` script in the directory containing your `.mp4` files.

### Linux
1. **Install FFmpeg**:
   - Use the package manager to install FFmpeg:
     ```bash
     sudo apt update
     sudo apt install ffmpeg
     ```
2. Place the `convert_to_hls.sh` script in the directory containing your `.mp4` files.

---

## Usage

### Windows
1. Save the `convert_to_hls.bat` script in the folder containing `.mp4` files.
2. Double-click the `convert_to_hls.bat` script.
3. HLS files will be generated in individual folders, each named after the video.

### Linux
1. Save the `convert_to_hls.sh` script in the folder containing `.mp4` files.
2. Make the script executable:
   ```bash
   chmod +x convert_to_hls.sh
   ```
3. Run the script:
   ```bash
   ./convert_to_hls.sh
   ```
4. HLS files will be generated in individual folders, each named after the video.

---

## Example Output
For a file named `Video_001.mp4`, the output directory will look like this:
```
Video_001/
├── master.m3u8
├── 540p/
│   └── playlist_540p.m3u8
├── 720p/
│   └── playlist_720p.m3u8
└── 1080p/
    └── playlist_1080p.m3u8
```

---

## Supported Platforms
- **Windows**: Uses a Batch script (`convert_to_hls.bat`).
- **Linux**: Uses a Shell script (`convert_to_hls.sh`).

---

## Credit
This script was created by [Sunil Prasad Regmi](https://sunilprasad.com.np/). It leverages **FFmpeg**, a powerful open-source tool for multimedia processing. Special thanks to the open-source community for their contributions to FFmpeg and adaptive streaming solutions.

---

## License
This project is licensed under the [MIT License](LICENSE).
