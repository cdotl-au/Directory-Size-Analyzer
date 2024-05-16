# Directory-Size-Analyzer

Analyse and report the sizes of directories.

This script will recursively scan directories, calculate their sizes, and log the results while also printing them to the console.

Useful for working out what's using up space on a drive. The output log file can be grepped or used for further analysis.

![OpenRedirex](https://github.com/cdotl-au/Directory-Size-Analyzer/blob/main/Screenshot.PNG?raw=true)

## How to Use

1. **Specify the Root Directory and Log File:**
   Edit the `$rootDir` and `$logFile` variables within the script to point to your desired root directory and log file location.

2. **Run the Script:**
   Execute the script in PowerShell. It will scan all directories under the specified root directory, calculate their sizes, and output the results to the specified log file and the console.

## Example Usage

```powershell
# Specify root directory and output log file
$rootDir = "C:\"
$logFile = "dirsize.log"

# If the log file already exists, delete it
if (Test-Path $logFile) {
    Remove-Item $logFile
}

Write-Host "Scanning directories..."

# Get all directories recursively
$directories = Get-ChildItem $rootDir -Directory -Recurse -ErrorAction SilentlyContinue

# Initialize total size
$totalSize = 0

# Loop through all directories
foreach ($dir in $directories) {
    # Calculate directory size in MB
    $dirSizeMB = (Get-ChildItem $dir.FullName -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum / 1MB

    # Add directory size to total size
    $totalSize += $dirSizeMB

    # Format size output as GB if over 1024MB, otherwise keep as MB
    if ($dirSizeMB -gt 1024) {
        $dirSizeGB = $dirSizeMB / 1024
        "$($dir.FullName) occupies $( "{0:N2}" -f $dirSizeGB) GB" | Out-File $logFile -Append
        Write-Host "$($dir.FullName) occupies $( "{0:N2}" -f $dirSizeGB) GB"
    } else {
        "$($dir.FullName) occupies $( "{0:N2}" -f $dirSizeMB) MB" | Out-File $logFile -Append
        Write-Host "$($dir.FullName) occupies $( "{0:N2}" -f $dirSizeMB) MB"
    }
}

# Format total size output as GB if over 1024MB, otherwise keep as MB
if ($totalSize -gt 1024) {
    $totalSizeGB = $totalSize / 1024
    "Total used space is $( "{0:N2}" -f $totalSizeGB) GB" | Out-File $logFile -Append
    Write-Host "Total used space is $( "{0:N2}" -f $totalSizeGB) GB"
} else {
    "Total used space is $( "{0:N2}" -f $totalSize) MB" | Out-File $logFile -Append
    Write-Host "Total used space is $( "{0:N2}" -f $totalSize) MB"
}
