# ============================================
# Firewall Hardening Command
# ============================================
# This command configures Windows Firewall to block all unsolicited inbound network traffic 
# for the following profiles: Domain, Private, and Public.
#
# What does this do?
# - It sets the default inbound action to "Block" for all three profiles.
# - Unsolicited inbound connections (those not initiated by your computer) will be denied.
#
# Why is this important?
# - **Reduces Attack Surface:** By blocking inbound connections by default, 
#   you prevent attackers from directly accessing open ports or services on your computer.
# - **Prevents Unauthorized Access:** Even if an attacker knows your IP address, their attempts
#   to establish a connection will be dropped by the firewall, thwarting many remote exploits.
# - **Protects Against Network-Based Attacks:** This setting helps mitigate risks such as port scanning,
#   exploitation of vulnerabilities in network services, and other unauthorized access attempts.
#
# This setup allows your computer to send outbound requests (e.g., for browsing or gaming),
# while only permitting inbound responses to those requests.
Set-NetFirewallProfile -Profile Domain,Private,Public -DefaultInboundAction Block
