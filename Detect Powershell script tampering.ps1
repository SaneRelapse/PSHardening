# This script is still in production and is not perfect. it will throw a false positive on almost every file.


# Advesary may inject BOM/Invisible Characters into a PS1 file to hinder a Admin.
﻿# BOM (Byte Order Mark) and other invisible characters can silently corrupt PowerShell scripts. These characters, 
# which might be present at the very beginning of a file, can alter the actual content that PowerShell reads. 
# For example, a command like Get-Process may inadvertently be interpreted as ﻿Get-Process (with hidden characters prefixed), 
# causing the interpreter to throw a "CommandNotFoundException." This type of corruption is often hard to diagnose because
# the BOM or invisible characters aren't visible in many text editors. To prevent such issues, it’s best to save
# scripts in a UTF-8 format without BOM and verify that no extra invisible characters are present at the beginning of your script files.


# Below is a PowerShell script that checks if a given file contains a UTF-8 BOM (Byte Order Mark). 
# The UTF-8 BOM consists of the byte sequence EF BB BF. This script reads the first three bytes of the file and reports whether or not a BOM was detected.
param(
    [Parameter(Mandatory = $true)]
    [string]$FilePath
)

# Check if the file exists
if (-not (Test-Path $FilePath)) {
    Write-Error "File not found: $FilePath"
    exit 1
}

# Read all bytes from the file
$bytes = [System.IO.File]::ReadAllBytes($FilePath)

# Check if the file is large enough to contain a BOM
if ($bytes.Length -ge 3) {
    if ($bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        Write-Output "BOM detected in file: $FilePath"
    }
    else {
        Write-Output "No BOM detected in file: $FilePath"
    }
}
else {
    Write-Output "File is too short to determine BOM presence."
}

# Usage Example
# Save the script to a file (for example, DetectBOM.ps1), then run it in PowerShell like so:
# .\DetectBOM.ps1 -FilePath "C:\Path\To\YourScript.ps1"
