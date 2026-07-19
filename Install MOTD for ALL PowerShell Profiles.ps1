# =====================================================================
# Install MOTD for ALL PowerShell Profiles
# =====================================================================

# Ensure script is run with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent() `
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Write-Error "This script must be run as Administrator."
    exit
}

Write-Host "Setting execution policy to RemoteSigned (safe for profiles)..." -ForegroundColor Cyan
Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force

Write-Host "Execution policy updated." -ForegroundColor Green

# =====================================================================
# MOTD Text
# =====================================================================

$motd = @'
YOU HAVE BEEN CAUGHT.
DO NOT ATTEMPT TO ACCESS FILES, INJECT CODE, ESCALATE PRIVILEGES,
OR ATTEMPT LATERAL MOVEMENT. CEASE AND DESIST IMMEDIATELY.
'@

# =====================================================================
# Install MOTD into ALL PowerShell profile scopes
# =====================================================================

$profiles = @(
    $PROFILE,                                           # Current user, current host
    $PROFILE.AllUsersAllHosts,                          # All users, all hosts
    $PROFILE.AllUsersCurrentHost,                       # All users, current host
    $PROFILE.CurrentUserAllHosts                        # Current user, all hosts
)

foreach ($p in $profiles) {

    # Create profile file if missing
    if (-not (Test-Path $p)) {
        New-Item -ItemType File -Path $p -Force | Out-Null
    }

    # Append MOTD
    Add-Content -Path $p -Value @"
Write-Host @'
YOU HAVE BEEN CAUGHT.
DO NOT ATTEMPT TO ACCESS FILES, INJECT CODE, ESCALATE PRIVILEGES,
OR ATTEMPT LATERAL MOVEMENT. CEASE AND DESIST IMMEDIATELY.
'@ -ForegroundColor Red
"@
}

Write-Host "PowerShell MOTD installed for ALL profiles." -ForegroundColor Green
Write-Host "Open a new PowerShell window to see the banner." -ForegroundColor Cyan
