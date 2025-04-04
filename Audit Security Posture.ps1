# Audit-SecurityPosture.ps1
# ============================================
# This script audits your computer's security posture by retrieving
# various configuration settings and statuses that impact system security.
# It reads registry keys, firewall settings, Windows Defender status,
# SMB configuration, user account settings, and more.
# No settings are modified—this is a read-only audit.
# ============================================

# Function: Get-RegValue
# Retrieves a registry value and returns "Not Set" if it doesn't exist.
function Get-RegValue {
    param(
        [string]$Path,
        [string]$Name
    )
    try {
        $value = Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop | Select-Object -ExpandProperty $Name
    } catch {
        $value = "Not Set"
    }
    return $value
}

Write-Host "===== Security Posture Audit Report =====" -ForegroundColor Cyan

# ----------------------------------------------------------------
# Section 1: Registry Settings Related to Anonymous Access
# ----------------------------------------------------------------
Write-Host "`n-- Registry Settings: Anonymous Access --" -ForegroundColor Green
$RestrictAnonymousSAM = Get-RegValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "RestrictAnonymousSAM"
$RestrictAnonymous = Get-RegValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "RestrictAnonymous"
$LmCompatibilityLevel = Get-RegValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "LmCompatibilityLevel"
$RestrictNullSessAccess = Get-RegValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "RestrictNullSessAccess"
$NullSessionPipes = Get-RegValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "NullSessionPipes"
$NullSessionShares = Get-RegValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "NullSessionShares"

Write-Host "RestrictAnonymousSAM: $RestrictAnonymousSAM"
Write-Host "RestrictAnonymous: $RestrictAnonymous"
Write-Host "LmCompatibilityLevel: $LmCompatibilityLevel"
Write-Host "RestrictNullSessAccess: $RestrictNullSessAccess"
Write-Host "NullSessionPipes: $NullSessionPipes"
Write-Host "NullSessionShares: $NullSessionShares"

# ----------------------------------------------------------------
# Section 2: Windows Firewall Settings
# ----------------------------------------------------------------
Write-Host "`n-- Windows Firewall Settings --" -ForegroundColor Green
try {
    $firewallProfiles = Get-NetFirewallProfile
    foreach ($profile in $firewallProfiles) {
        Write-Host "Profile: $($profile.Name)"
        Write-Host "  DefaultInboundAction: $($profile.DefaultInboundAction)"
        Write-Host "  DefaultOutboundAction: $($profile.DefaultOutboundAction)"
        Write-Host "  Enabled: $($profile.Enabled)"
    }
} catch {
    Write-Host "Unable to retrieve firewall settings. Ensure you are running this on a system with the NetSecurity module."
}

# ----------------------------------------------------------------
# Section 3: SMBv1 Status
# ----------------------------------------------------------------
Write-Host "`n-- SMBv1 Status --" -ForegroundColor Green
try {
    $smb1 = Get-WindowsOptionalFeature -Online -FeatureName smb1protocol
    Write-Host "SMBv1 State: $($smb1.State)"
} catch {
    Write-Host "Unable to retrieve SMBv1 status."
}

# ----------------------------------------------------------------
# Section 4: Windows Defender Status
# ----------------------------------------------------------------
Write-Host "`n-- Windows Defender Status --" -ForegroundColor Green
try {
    $defenderStatus = Get-MpComputerStatus
    Write-Host "AMServiceEnabled: $($defenderStatus.AMServiceEnabled)"
    Write-Host "AntispywareEnabled: $($defenderStatus.AntispywareEnabled)"
    Write-Host "AntivirusEnabled: $($defenderStatus.AntivirusEnabled)"
    Write-Host "RealTimeProtectionEnabled: $($defenderStatus.RealTimeProtectionEnabled)"
} catch {
    Write-Host "Unable to retrieve Windows Defender status."
}

# ----------------------------------------------------------------
# Section 5: Local User Accounts – Guest Account
# ----------------------------------------------------------------
Write-Host "`n-- Local User Accounts --" -ForegroundColor Green
try {
    $guest = Get-LocalUser -Name "Guest"
    Write-Host "Guest Account Enabled: $($guest.Enabled)"
} catch {
    Write-Host "Guest account not found or error retrieving guest account status."
}

# ----------------------------------------------------------------
# Section 6: User Account Control (UAC) Settings
# ----------------------------------------------------------------
Write-Host "`n-- User Account Control (UAC) Settings --" -ForegroundColor Green
$EnableLUA = Get-RegValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA"
Write-Host "EnableLUA (UAC): $EnableLUA"

# ----------------------------------------------------------------
# Section 7: Remote Desktop (RDP) Settings
# ----------------------------------------------------------------
Write-Host "`n-- Remote Desktop Settings --" -ForegroundColor Green
$RDPStatus = Get-RegValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections"
if ($RDPStatus -eq 1) {
    Write-Host "Remote Desktop is Disabled (fDenyTSConnections=1)"
} else {
    Write-Host "Remote Desktop is Enabled (fDenyTSConnections=0 or not set)"
}

# ----------------------------------------------------------------
# Section 8: Windows Update Service Status
# ----------------------------------------------------------------
Write-Host "`n-- Windows Update Service Status --" -ForegroundColor Green
try {
    $wuauserv = Get-Service -Name "wuauserv"
    Write-Host "Windows Update Service Status: $($wuauserv.Status)"
} catch {
    Write-Host "Unable to retrieve Windows Update service status."
}

# ----------------------------------------------------------------
# Section 9: Audit Policy Settings
# ----------------------------------------------------------------
Write-Host "`n-- Audit Policy Settings --" -ForegroundColor Green
try {
    $auditPolicies = auditpol /get /category:"*"
    Write-Host $auditPolicies
} catch {
    Write-Host "Unable to retrieve audit policy settings."
}

Write-Host "`n===== End of Security Posture Audit =====" -ForegroundColor Cyan
