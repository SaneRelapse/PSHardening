# Ensure the script is run with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Error "This script must be run as an Administrator."
    exit
}

# Disable PowerShell remoting (affects PowerShell 6+ configurations)
try {
    Disable-PSRemoting -Force -ErrorAction Stop
    Write-Host "PowerShell remoting has been disabled."
}
catch {
    Write-Error "Failed to disable PowerShell remoting: $_"
}

# Stop and disable the WinRM service
try {
    $winrmService = Get-Service -Name WinRM -ErrorAction SilentlyContinue
    if ($winrmService) {
        Write-Host "Stopping WinRM service..."
        Stop-Service -Name WinRM -Force -ErrorAction Stop
        Write-Host "WinRM service stopped."
        
        Write-Host "Disabling WinRM service from starting automatically..."
        Set-Service -Name WinRM -StartupType Disabled -ErrorAction Stop
        Write-Host "WinRM service has been disabled."
    }
    else {
        Write-Warning "WinRM service was not found on this system."
    }
}
catch {
    Write-Error "Failed to stop/disable WinRM service: $_"
}

# Restore the LocalAccountTokenFilterPolicy registry key to 0,
# which restricts remote access to only members of the Administrators group
try {
    $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
    if (Test-Path $registryPath) {
        Set-ItemProperty -Path $registryPath -Name LocalAccountTokenFilterPolicy -Value 0 -ErrorAction Stop
        Write-Host "LocalAccountTokenFilterPolicy has been set to 0."
    }
    else {
        Write-Warning "Registry path $registryPath not found."
    }
}
catch {
    Write-Error "Failed to set LocalAccountTokenFilterPolicy: $_"
}
