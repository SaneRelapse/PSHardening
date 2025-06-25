# Block-RTP.ps1
# -----------------------------------------------
# Block RTP Traffic to Harden System Security
# -----------------------------------------------
# This script adds Windows Firewall rules to block RTP (Real-Time Transport Protocol)
# traffic over UDP ports 16384–32767, which are commonly used by VoIP, video conferencing,
# and streaming applications. RTP can also be exploited for:
# - Covert data exfiltration channels.
# - Malware command & control.
# - Bypassing inspection due to its use of dynamic ports.

# Blocking these ports reduces the system’s attack surface, prevents unauthorized
# communication, and strengthens security posture in hardened or high-trust environments.

# --------------------------
# BLOCK INBOUND RTP TRAFFIC
# --------------------------

# This rule blocks incoming RTP streams over UDP on ports 16384–32767.
# It stops unsolicited VoIP/video sessions and mitigates remote attack vectors.
New-NetFirewallRule -DisplayName "Block RTP UDP Inbound Ports" `
    -Direction Inbound `
    -Protocol UDP `
    -LocalPort 16384-32767 `
    -Action Block `
    -Profile Any `
    -Enabled True `
    -Description "HARDENING: Blocks inbound RTP traffic (UDP 16384–32767) to prevent unauthorized VoIP/media session initiation and remote exploitation."

# ---------------------------
# BLOCK OUTBOUND RTP TRAFFIC
# ---------------------------

# This rule blocks outgoing RTP streams over UDP on ports 16384–32767.
# It helps stop:
# - Data exfiltration over RTP streams (covert channels).
# - Malware beaconing via VoIP/streaming protocols.
New-NetFirewallRule -DisplayName "Block RTP UDP Outbound Ports" `
    -Direction Outbound `
    -Protocol UDP `
    -RemotePort 16384-32767 `
    -Action Block `
    -Profile Any `
    -Enabled True `
    -Description "HARDENING: Blocks outbound RTP traffic (UDP 16384–32767) to prevent data exfiltration, covert channels, and unauthorized media transmission."

# -----------------------------------------------
# RESULT: SYSTEM HARDENED
# - Reduces exposure to dynamic UDP port attacks.
# - Shuts down unnecessary real-time media flows.
# - Prevents lateral movement and remote session abuse.
# - Useful in secure environments (e.g., air-gapped, SCADA, classified networks).
# -----------------------------------------------
