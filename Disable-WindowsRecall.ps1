<#
.SYNOPSIS
    Disable the Windows 11 Recall feature via registry hardening.

.DESCRIPTION
    - Prevents the Recall app from running or even being installed.
    - Stops Recall from capturing or storing any snapshots.
    - Applies settings under both HKLM and HKCU to ensure system-wide coverage.
#>

# Define the HKLM base key for WindowsAI policies
$hkmlPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsAI"

# 1) Ensure the WindowsAI key exists under HKLM (creates it if missing)
#    Harden: Without this policy key present, we cannot apply Recall restrictions.
if (-not (Test-Path $hkmlPath)) {
    New-Item -Path $hkmlPath -Force | Out-Null
}

# 2) Disable the Recall component entirely
#    Harden: Prevents the Recall feature/app from being enabled or installed.
New-ItemProperty -Path $hkmlPath `
                 -Name "AllowRecallEnablement" `
                 -PropertyType DWord `
                 -Value 0 `
                 -Force | Out-Null

# 3) Disable Recall’s data analysis (snapshot capture/storage) under HKLM
#    Harden: Even if Recall somehow runs, it won’t collect or store any user data.
New-ItemProperty -Path $hkmlPath `
                 -Name "DisableAIDataAnalysis" `
                 -PropertyType DWord `
                 -Value 1 `
                 -Force | Out-Null

# Define the HKCU base key for WindowsAI policies (per-user)
$hkcuPath = "HKCU:\Software\Policies\Microsoft\Windows\WindowsAI"

# 4) Ensure the WindowsAI key exists under HKCU (creates it if missing)
#    Harden: Covers user-specific settings so non-admin users can’t re-enable Recall.
if (-not (Test-Path $hkcuPath)) {
    New-Item -Path $hkcuPath -Force | Out-Null
}

# 5) Disable Recall’s data analysis under HKCU
#    Harden: Mirrors HKLM setting at the user level for complete lockdown.
New-ItemProperty -Path $hkcuPath `
                 -Name "DisableAIDataAnalysis" `
                 -PropertyType DWord `
                 -Value 1 `
                 -Force | Out-Null

Write-Host "✅ Windows Recall feature has been disabled. Please restart the PC to apply changes." -ForegroundColor Green
