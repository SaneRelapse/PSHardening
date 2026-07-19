# ================================================================
# Harden Windows by disabling WPAD (Web Proxy Auto-Discovery Protocol)
# WPAD is a major attack surface used for:
#   - proxy hijacking
#   - credential theft
#   - man-in-the-middle attacks
#   - rogue PAC file injection
#
# This script disables WPAD via:
#   - WinHTTP auto-proxy settings
#   - Internet Explorer/WinINET auto-detect
#   - Group Policy registry keys
#
# Requires: Administrator privileges
# ================================================================

# Ensure script is run as Administrator
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent() `
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Write-Error "This script must be run as Administrator."
    exit
}

Write-Host "Disabling WPAD and automatic proxy discovery..." -ForegroundColor Cyan

# ================================================================
# 1. Disable WinHTTP auto-proxy discovery (WPAD)
# ================================================================
try {
    Write-Host "Resetting WinHTTP proxy settings (disabling WPAD)..." -ForegroundColor Yellow
    netsh winhttp reset proxy
    Write-Host "WinHTTP proxy reset. WPAD auto-discovery disabled for WinHTTP." -ForegroundColor Green
}
catch {
    Write-Error "Failed to reset WinHTTP proxy settings: $_"
}

# ================================================================
# 2. Disable 'Automatically detect settings' (WinINET/IE/Edge legacy)
# ================================================================
try {
    Write-Host "Disabling 'Automatically detect settings' for legacy WinINET/IE..." -ForegroundColor Yellow

    # HKCU - current user
    New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Force | Out-Null
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" `
        -Name "AutoDetect" -Value 0 -Type DWord -Force

    # HKLM - machine-wide default
    New-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" `
        -Name "AutoDetect" -Value 0 -Type DWord -Force

    Write-Host "'Automatically detect settings' disabled (AutoDetect = 0)." -ForegroundColor Green
}
catch {
    Write-Error "Failed to disable AutoDetect for Internet Settings: $_"
}

# ================================================================
# 3. Disable WPAD via Group Policy registry (WinINET/IE)
# ================================================================
try {
    Write-Host "Applying Group Policy-based WPAD disable..." -ForegroundColor Yellow

    # Internet Explorer/WinINET policy key
    New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings" -Force | Out-Null

    # Disable auto-detect (WPAD)
    Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings" `
        -Name "EnableAutoProxyResultCache" -Value 0 -Type DWord -Force

    Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings" `
        -Name "AutoDetect" -Value 0 -Type DWord -Force

    Write-Host "WPAD-related policy settings applied (AutoDetect = 0, EnableAutoProxyResultCache = 0)." -ForegroundColor Green
}
catch {
    Write-Error "Failed to apply WPAD Group Policy settings: $_"
}

# ================================================================
# Final confirmation
# ================================================================
Write-Host "`nWPAD and automatic proxy discovery have been disabled across WinHTTP and WinINET." -ForegroundColor Cyan
Write-Host "This mitigates proxy hijacking, PAC poisoning, and credential theft via rogue WPAD." -ForegroundColor Cyan
