# =============================================================================
# Force DNS over HTTPS (DoH)
# =============================================================================
# Hardening Benefits:
#   • Encrypts all DNS queries to prevent eavesdropping (confidentiality) 
#     and tampering (integrity) by on-path attackers.
#   • Disables fallback to plaintext DNS (UDP/TCP port 53), ensuring all lookups
#     occur only over HTTPS.
#   • Protects against DNS spoofing and man-in-the-middle attacks on untrusted
#     networks (public Wi-Fi, malicious hotspots).
# =============================================================================

# Ensure the DNS cache parameters key exists
if (-not (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters")) {
    New-Item `
      -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache" `
      -Name "Parameters" `
      -Force | Out-Null
    Write-Host "Created registry key for DNS parameters."
}

# Set EnableAutoDoh = 2 to require DNS-over-HTTPS only (no plaintext DNS)
New-ItemProperty `
  -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" `
  -Name "EnableAutoDoh" `
  -PropertyType DWord `
  -Value 2 `
  -Force

Write-Host "Enabled Require-DoH only (EnableAutoDoh = 2)."
# -----------------------------------------------------------------------------
# After reboot / DNS client restart:
#   • All DNS queries will be encapsulated in HTTPS (port 443).
#   • Plaintext DNS (port 53) is blocked by the OS, preventing leaks.
# =============================================================================
