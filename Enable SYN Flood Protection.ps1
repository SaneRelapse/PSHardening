# =============================================================================
# Script: Enable SYN Flood Protection (SynAttackProtect)
# Purpose: Ensures Windows TCP/IP stack aggressively defends against SYN flood attacks
# =============================================================================

# Define the registry path where TCP/IP parameters live
$regPath     = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
# Define the specific value name for SYN flood protection
$valueName   = "SynAttackProtect"
# Level 2 = aggressive, always-on SYN flood defense
$desiredValue = 2

# -----------------------------------------------------------------------------
# Check whether SynAttackProtect already exists
#    - If it doesn’t, create it and set to aggressive mode (2)
#    - If it does, leave it alone to avoid overwriting admin intent
# -----------------------------------------------------------------------------
if (-not (Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction SilentlyContinue)) {
    # Create the DWORD under Tcpip\Parameters and assign the aggressive mode
    New-ItemProperty `
        -Path $regPath `
        -Name $valueName `
        -PropertyType DWord `
        -Value $desiredValue `
        -Force
    Write-Output "SynAttackProtect was created and set to $desiredValue."
} else {
    Write-Output "SynAttackProtect already exists. No changes made."
}

# =============================================================================
# What this script does:
# 1. Looks in the registry for SynAttackProtect under
#    HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters.
# 2. If the key is missing, it creates it as a 32-bit DWORD and sets its value to 2.
# 3. Level 2 tells Windows to:
#      • Enforce SYN cookies early (not just under extreme load)
#      • Limit half-open connection backlogs tightly
#      • Shorten handshake timeouts for incomplete handshakes
#      • Dynamically throttle/delay or drop new SYNs under flood conditions
# =============================================================================

# How it hardens networking:
# • Prevents resource exhaustion from SYN flood (half-open) attacks.
# • Reduces the window attackers have to tie up your server’s TCP backlog.
# • Activates SYN cookie fallback preemptively to ensure legitimate clients still connect.
# • Adds a low-overhead barrier that makes large-scale TCP handshake floods impractical.
# =============================================================================
