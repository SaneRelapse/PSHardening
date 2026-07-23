<#
.SYNOPSIS
    Blocks SSH access on Windows.

.DESCRIPTION
    Creates Windows Defender Firewall rules to block:
    - Incoming SSH connections (TCP 22)
    - Outgoing SSH connections (TCP 22)

    Disables OpenSSH Server if installed.

.NOTES
    Run as Administrator.
    Does not affect normal printing, Windows Update, or SMB.
#>

# Require Administrator
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentUser)

if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit
}

Write-Host "Blocking SSH..." -ForegroundColor Cyan


# Firewall Rules

$rules = @(
    @{
        Name = "Block SSH Inbound TCP 22"
        Direction = "Inbound"
        RemotePort = $null
        LocalPort = 22
    },
    @{
        Name = "Block SSH Outbound TCP 22"
        Direction = "Outbound"
        RemotePort = 22
        LocalPort = $null
    }
)


foreach ($rule in $rules) {

    if (-not (Get-NetFirewallRule -DisplayName $rule.Name -ErrorAction SilentlyContinue)) {

        if ($rule.Direction -eq "Inbound") {

            New-NetFirewallRule `
                -DisplayName $rule.Name `
                -Direction Inbound `
                -Protocol TCP `
                -LocalPort $rule.LocalPort `
                -Action Block `
                -Profile Any

        }
        else {

            New-NetFirewallRule `
                -DisplayName $rule.Name `
                -Direction Outbound `
                -Protocol TCP `
                -RemotePort $rule.RemotePort `
                -Action Block `
                -Profile Any
        }
    }
}


# Disable OpenSSH Server

if (Get-Service sshd -ErrorAction SilentlyContinue) {

    Stop-Service sshd -Force -ErrorAction SilentlyContinue

    Set-Service sshd `
        -StartupType Disabled

    Write-Host "OpenSSH Server disabled."
}


Write-Host ""
Write-Host "SSH blocking complete." -ForegroundColor Green
Write-Host "Blocked:"
Write-Host " - Incoming TCP 22"
Write-Host " - Outgoing TCP 22"