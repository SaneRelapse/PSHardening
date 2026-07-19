# =====================================================================
# Unified RDP / MSTSC Hardening Script
# Safely disables all RDP server functionality without deleting mstsc.exe
# =====================================================================

# Ensure admin
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent() `
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Write-Error "This script must be run as Administrator."
    exit
}

Write-Host "Hardening RDP / MSTSC..." -ForegroundColor Cyan

# =====================================================================
# Disable RDP Server (Terminal Services)
# =====================================================================

Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" `
                 -Name "fDenyTSConnections" -Value 1

Stop-Service TermService -Force -ErrorAction SilentlyContinue
Set-Service TermService -StartupType Disabled

# =====================================================================
# Disable Remote Assistance
# =====================================================================

Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Remote Assistance" `
                 -Name "fAllowToGetHelp" -Value 0

# =====================================================================
# Disable Remote Credential Guard / Restricted Admin
# =====================================================================

Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
                 -Name "DisableRestrictedAdmin" -Value 1

# =====================================================================
# Disable Remote Shell (PowerShell Remoting)
# =====================================================================

Disable-PSSessionConfiguration -Name Microsoft.PowerShell -ErrorAction SilentlyContinue

# =====================================================================
# Disable Remote Desktop Shadowing
# =====================================================================

Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" `
                 -Name "Shadow" -Value 0

# =====================================================================
# Disable RemoteFX (deprecated but still present on some builds)
# =====================================================================

Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" `
                 -Name "fEnableRemoteFXAdvancedGraphics" -Value 0 -ErrorAction SilentlyContinue

# =====================================================================
# Disable NLA fallback (forces no authentication downgrade)
# =====================================================================

Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" `
                 -Name "UserAuthentication" -Value 1

# =====================================================================
# Disable RDP Clipboard & Printer Redirection
# =====================================================================

Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" `
                 -Name "fDisableClip" -Value 1

Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" `
                 -Name "fDisableCcm" -Value 1

# =====================================================================
# Block RDP Ports (3389 TCP/UDP)
# Remove ANY existing rules on these ports
# =====================================================================

$rdpPorts = @(3389)

foreach ($port in $rdpPorts) {

    # Remove any inbound rule using this port
    $existing = Get-NetFirewallRule -Direction Inbound |
                Get-NetFirewallPortFilter |
                Where-Object { $_.LocalPort -eq $port }

    foreach ($rule in $existing) {
        Remove-NetFirewallRule -Name $rule.InstanceID
    }

    # Add hardened block rule
    New-NetFirewallRule -DisplayName "Block RDP Port $port" `
                        -Direction Inbound `
                        -Protocol TCP `
                        -LocalPort $port `
                        -Action Block

    New-NetFirewallRule -DisplayName "Block RDP Port $port UDP" `
                        -Direction Inbound `
                        -Protocol UDP `
                        -LocalPort $port `
                        -Action Block
}

Write-Host "RDP / MSTSC hardening complete." -ForegroundColor Green
