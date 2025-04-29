# JellyFin_Overall_VideoScanReporter

# SvalbazNet: Overall_VideoScanReporter.ps1

## Target
TV & Movies

## Description
This script looks recursively at all folders in `$rootTV` and `$rootMovies` for any files with video extensions (e.g., .mp4, .mkv, .avi) and uses `ffmpeg` to check the quality of the videos. It generates a report that can help you determine whether a file needs to be converted or replaced based on your display resolution and preferences.

## Purpose
The purpose of this script is to help users who do not need 4K rips for their devices (e.g., 1080p TV, phone, or 1080p/1440p PC monitor) by identifying videos that may be consuming unnecessary storage space. This way, you can optimise your library without keeping excessive file sizes for non-4K devices.

## Prerequisites
You need to have `ffmpeg` installed. You can download it from here:  
[Download ffmpeg](https://www.gyan.dev/ffmpeg/builds/)

After downloading, extract `ffmpeg` and save it in a folder. Make sure to add the `bin` folder of `ffmpeg` to your PATH environment variable so that it can be called from the command line.

### Codec Names:
- **H.265 = "HEVC"**
- **H.264/AVC = "h264"**

### Note:
- **HEVC (High Efficiency Video Coding)** is the same as "H.265." The ITU-T standard name is "H.265," while the ISO/IEC standard name is "HEVC."

## Usage
Run the script, and it will scan your TV and movie folders for video files, then generate a detailed report based on the quality of the videos.
