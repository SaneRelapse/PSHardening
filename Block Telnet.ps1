# ==========================================
# Telnet Lockdown Script
# ==========================================

Write-Host "Blocking Telnet..." -ForegroundColor Cyan

# Block inbound Telnet connections (remote -> this PC)
New-NetFirewallRule `
    -DisplayName "Block Telnet Inbound TCP 23" `
    -Direction Inbound `
    -Protocol TCP `
    -LocalPort 23 `
    -Action Block `
    -Profile Any `
    -ErrorAction SilentlyContinue

# Block outbound Telnet connections (this PC -> remote)
New-NetFirewallRule `
    -DisplayName "Block Telnet Outbound TCP 23" `
    -Direction Outbound `
    -Protocol TCP `
    -RemotePort 23 `
    -Action Block `
    -Profile Any `
    -ErrorAction SilentlyContinue


# Disable Telnet Server if installed
if (Get-Service TlntSvr -ErrorAction SilentlyContinue) {

    Stop-Service TlntSvr -Force -ErrorAction SilentlyContinue

    Set-Service `
        -Name TlntSvr `
        -StartupType Disabled

    # Registry enforcement
    Set-ItemProperty `
        -Path "HKLM:\SYSTEM\CurrentControlSet\Services\TlntSvr" `
        -Name Start `
        -Value 4
}


# Disable Telnet Client feature
Disable-WindowsOptionalFeature `
    -Online `
    -FeatureName TelnetClient `
    -NoRestart `
    -ErrorAction SilentlyContinue


Write-Host ""
Write-Host "Telnet has been blocked successfully." -ForegroundColor Green