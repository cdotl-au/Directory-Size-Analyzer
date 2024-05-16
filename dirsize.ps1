# Directory Size Analyzer
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
