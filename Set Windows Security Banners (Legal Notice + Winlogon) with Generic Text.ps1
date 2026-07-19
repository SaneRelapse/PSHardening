# =====================================================================
# Set Windows Security Banners (Legal Notice + Winlogon) with Generic Text
# =====================================================================

# Ensure the script is run with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent() `
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Write-Error "This script must be run as an Administrator."
    exit
}

# =====================================================================
# Legal Notice Banner (Policies\System)
# =====================================================================

$sysKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
if (-not (Test-Path $sysKey)) { New-Item -Path $sysKey -Force | Out-Null }

Set-ItemProperty -Path $sysKey -Name "LegalNoticeCaption" -Value "AUTHORIZED AND UNAUTHORIZED USE NOTICE"

Set-ItemProperty -Path $sysKey -Name "LegalNoticeText" -Value @"
This system is for authorized use only. Unauthorized access, use, or modification is prohibited and may result in administrative, civil, or criminal action.

All activity on this system may be monitored and recorded. By proceeding, you consent to such monitoring.
"@

Write-Host "Legal Notice banner applied."


# =====================================================================
# Winlogon Banner (Windows NT\CurrentVersion\Winlogon)
# =====================================================================

$wlKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
if (-not (Test-Path $wlKey)) { New-Item -Path $wlKey -Force | Out-Null }

Set-ItemProperty -Path $wlKey -Name "LegalNoticeCaption" -Value "SECURITY NOTICE"

Set-ItemProperty -Path $wlKey -Name "LegalNoticeText" -Value @"
This computer system is for authorized use only. Unauthorized access or misuse is strictly prohibited and may lead to disciplinary action or prosecution.

System activity may be monitored, logged, and reviewed. By continuing to use this system, you acknowledge and accept these conditions.
"@

Write-Host "Winlogon warning banner applied."
