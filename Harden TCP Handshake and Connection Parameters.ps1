# =============================================================================
# Script: Harden TCP/IP Handshake and Connection Parameters
# Purpose: Aggressively defend against SYN floods and tighten various TCP settings
# Author:  J
# Date:    2025-04-26
# =============================================================================

# -----------------------------------------------------------------------------
# 1) Enable SYN flood protection (SynAttackProtect level 2 = aggressive mode)
# -----------------------------------------------------------------------------
# What it does:
#   • Enforces SYN cookies early
#   • Limits half-open backlog tightly
#   • Shortens handshake timeouts
#   • Dynamically throttles or drops SYNs under flood
# Default: 0 (off)
# Hardened: 2 (aggressive, always-on)
# -----------------------------------------------------------------------------
$regPath       = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
$synValueName  = "SynAttackProtect"
$synDesiredVal = 2

if (-not (Get-ItemProperty -Path $regPath -Name $synValueName -ErrorAction SilentlyContinue)) {
    New-ItemProperty -Path $regPath -Name $synValueName -PropertyType DWord -Value $synDesiredVal -Force | Out-Null
    Write-Host "SynAttackProtect created and set to $synDesiredVal"
} else {
    Write-Host "SynAttackProtect already exists; no change made."
}

# -----------------------------------------------------------------------------
# 2) Additional TCP hardening parameters
# -----------------------------------------------------------------------------
# TcpMaxSynRetransmissions
#   What it does: How many times Windows will retransmit a SYN before giving up.
#   Default: 2
#   Hardened: 1 (or 0 for immediate failure)
#   Effect: Limits attacker’s ability to tie up resources by repeated SYN retries.
#
# TcpMaxHalfOpen
#   What it does: Maximum number of concurrent half-open (SYN_RECEIVED) connections.
#   Default: 100
#   Hardened: 20–30
#   Effect: Caps backlog so SYN floods can’t exhaust memory.
#
# TcpMaxHalfOpenRetried
#   What it does: After this many half-open retries, TCP throttles new accepts linearly.
#   Default: 80
#   Hardened: 15–20
#   Effect: Acts as a “trip-wire” to throttle faster under flood.
#
# TcpTimedWaitDelay
#   What it does: Seconds a closed connection stays in TIME_WAIT.
#   Default: 240
#   Hardened: 30–60
#   Effect: Frees up ports faster during high connection churn.
#
# MaxUserPort
#   What it does: Highest ephemeral (client) port number.
#   Default: 5000
#   Hardened: > 32767 (e.g. 61000)
#   Effect: Expands port pool so attackers can’t exhaust ports.
#
# EnablePMTUDiscovery
#   What it does: Path MTU Discovery (ICMP-based) enabled?
#   Default: 1 (enabled)
#   Hardened: 0 (disable)
#   Effect: Prevents ICMP-based MTU black-hole attacks (may fragment).
#
# EnablePMTUBHDetect
#   What it does: Black-hole router detection for PMTU.
#   Default: 0 (disabled)
#   Hardened: 1 (enable)
#   Effect: Recovers connectivity when PMTU Discovery is off.
#
# EnableICMPRedirect
#   What it does: Honor ICMP Redirect messages?
#   Default: 1 (enabled)
#   Hardened: 0 (disable)
#   Effect: Prevents malicious route-hijacking via forged redirects.
#
# EnableDeadGWDetect
#   What it does: Automatic dead-gateway detection/switch?
#   Default: 1 (enabled)
#   Hardened: 0 (disable)
#   Effect: Stops LAN attackers from poisoning gateway list.
#
# EnableIPSourceRouting
#   What it does: Honor source-routed packets?
#   Default: 0 (disabled)
#   Hardened: 0 (disable)
#   Effect: Prevents attackers from forcing traffic through malicious routers.
# -----------------------------------------------------------------------------
$settings = @{
    TcpMaxSynRetransmissions = 1
    TcpMaxHalfOpen           = 25
    TcpMaxHalfOpenRetried    = 20
    TcpTimedWaitDelay        = 30
    MaxUserPort              = 61000
    EnablePMTUDiscovery      = 0
    EnablePMTUBHDetect       = 1
    EnableICMPRedirect       = 0
    EnableDeadGWDetect       = 0
    EnableIPSourceRouting    = 0
}

foreach ($name in $settings.Keys) {
    $val = $settings[$name]
    $current = (Get-ItemProperty -Path $regPath -Name $name -ErrorAction SilentlyContinue).$name
    if ($current -ne $val) {
        New-ItemProperty -Path $regPath -Name $name -PropertyType DWord -Value $val -Force | Out-Null
        Write-Host "Set $name = $val"
    } else {
        Write-Host "$name already set to $val"
    }
}

Write-Host "`nAll settings applied. Please reboot to enable changes."
