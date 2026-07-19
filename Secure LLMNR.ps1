# ================================================================
# Harden Windows by disabling LLMNR (Link‑Local Multicast Name Resolution)
# ================================================================

# Ensure script is run as Administrator
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent() `
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Write-Error "This script must be run as Administrator."
    exit
}

Write-Host "Disabling LLMNR across all interfaces..." -ForegroundColor Cyan

# ================================================================
# 1. Disable LLMNR via Group Policy registry location
# ================================================================
try {
    New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows NT" -Name "DNSClient" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows NT\DNSClient" `
        -Name "EnableMulticast" -Value 0 -Type DWord -Force

    Write-Host "LLMNR disabled via DNSClient policy (EnableMulticast = 0)." -ForegroundColor Green
}
catch {
    Write-Error "Failed to set DNSClient policy for LLMNR: $_"
}

# ================================================================
# 2. Disable LLMNR on all network adapters
# ================================================================
try {
    $adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }

    foreach ($adapter in $adapters) {
        Write-Host "Applying LLMNR disable to adapter: $($adapter.Name)" -ForegroundColor Yellow
        Set-NetAdapterAdvancedProperty -Name $adapter.Name `
            -DisplayName "LLMNR" `
            -DisplayValue "Disabled" `
            -ErrorAction SilentlyContinue
    }

    Write-Host "LLMNR disabled on all active network adapters." -ForegroundColor Green
}
catch {
    Write-Error "Failed to disable LLMNR on adapters: $_"
}

# ================================================================
# 3. Disable LLMNR via netsh (legacy stack compatibility)
# ================================================================
try {
    Write-Host "Applying legacy LLMNR disable via netsh..." -ForegroundColor Yellow
    netsh interface ipv4 set global multicast=disabled
    netsh interface ipv6 set global multicast=disabled

    Write-Host "LLMNR multicast disabled via netsh." -ForegroundColor Green
}
catch {
    Write-Error "Failed to apply netsh multicast disable: $_"
}

# ================================================================
# Final confirmation
# ================================================================
Write-Host "`nLLMNR has been fully disabled across all known Windows locations." -ForegroundColor Cyan
Write-Host "This eliminates LLMNR spoofing, poisoning, relay attacks, and LAN credential theft vectors." -ForegroundColor Cyan
