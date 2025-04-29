<#
SvalbazNet: Overall_VideoScanReporter.ps1

Target:		TV & Movies
Use: 		Script looks recursively at all folders in $rootTV & $rootMovies for any $videoExtensions and leverages ffmpeg to interrogate the quality. It then produces a report for you.
Reason: 	The only devices consuming content are a 1080p TV hooked up to an xbox, my phone or my PC monitor (1440p) so whats the point in using all my storage with 4K rips? This lets me know if I need to convert or replace anything

Notes: 	You can download ffmpeg from here: "https://www.gyan.dev/ffmpeg/builds/", Extract it and save it somewhere on your machine, you then need to set the extracted bin folder in your PATH system environment variable

		When ffprobe returns the codec name:
		H.265 =		"HEVC"
		H.264/AVC = "h264"

		H.265/HEVC explanation: HEVC (High Efficiency Video Coding) is the same as "H.265", "H.265" is the ITU-T standard name. "HEVC" is the ISO/IEC name
#>


# ----- VARIABLES ----- #
$rootPaths = @(
    "\\192.168.1.184\tv\TV",
    "\\192.168.1.184\Movies\Movies"
)

$videoExtensions = 	@(".mkv", ".mp4", ".avi", ".ts", ".m4v") # Can be done against other extensions
$videoheight = 		1080 # 1080P, not quotes as it is an integer, not a string
$codecChoice1 = 	"h264" # H.264
$codecChoice2 = 	"hevc" # HEVC
$ffprobePath = 		"ffprobe"  # Assumes ffprobe is in PATH, please see Notes above
$results = 			@() # Building an Array for later
$outputCsv = 		"$env:USERPROFILE\Desktop\Video_Scan_Report.csv" # Trying to be system/setup agnostic

# ----- FUNCTION ----- #
function Scan-Videos {
    param([string]$path)

$files = Get-ChildItem -Path $path -Recurse -File | Where-Object {
    $videoExtensions -contains $_.Extension.ToLower()
}

$total = $files.Count
$index = 0

# Let's produce a nice progress bar, depending on how many files you've got you might just think the script is broken and not doing anything. This lets you see how it's getting on.
foreach ($fileInfo in $files) {
    $index++
    Write-Progress -Activity "Scanning video files..." `
                   -Status "Processing: $($fileInfo.Name)" `
                   -PercentComplete (($index / $total) * 100)

    $file = $fileInfo.FullName

        $file = $_.FullName

        # Use ffprobe to extract video stream info
        $ffprobeOutput = & $ffprobePath -v error -select_streams v:0 `
            -show_entries stream=width,height,codec_name `
            -of default=noprint_wrappers=1:nokey=1 "$file" 2>$null

        if ($ffprobeOutput) {
            $info = $ffprobeOutput -split "`n"
            if ($info.Count -ge 3) {
if ([int]::TryParse($info[0], [ref]$null) -and [int]::TryParse($info[1], [ref]$null)) {
    $width = [int]$info[0]
    $height = [int]$info[1]
    $codec = $info[2].ToLower()

    if ($height -gt $videoheight -or ($codec -ne $codecChoice1 -and $codec -ne $codecChoice2)) {
        $results += [PSCustomObject]@{
            FilePath = $file
            Width = $width
            Height = $height
            Codec = $codec
        }
    }
}

                $codec = $info[2].ToLower()

                if ($height -gt $videoheight -or ($codec -ne $codecChoice1 -and $codec -ne $codecChoice2)) {
                    $results += [PSCustomObject]@{
                        FilePath = $file
                        Width = $width
                        Height = $height
                        Codec = $codec
                    }
                }
            }
        }
    }
}

# ----- RUN SCANS FOR BOTH ROOTS ----- #
foreach ($path in $rootPaths) {
    Write-Host "📁 Scanning: $path" -ForegroundColor Cyan # Let's use Emojis, it's 2025
    Scan-Videos -path $path
}

# ----- OUTPUT ----- #
if ($results.Count -eq 0) {
    Write-Host "`n✅ No files above 1080p or outside H.264/H.265" -ForegroundColor Green # Let's use Emojis, it's 2025
} else {
    Write-Host "`n⚠️ Files with resolution >1080p or unsupported codec:" -ForegroundColor Yellow # Let's use Emojis, it's 2025
    $results | Format-Table -AutoSize

    # Export to CSV
    $results | Export-Csv -Path $outputCsv -NoTypeInformation -Encoding UTF8
    Write-Host "`n📁 Results exported to: $outputCsv" -ForegroundColor Cyan # Let's use Emojis, it's 2025
}
