# ============================================
# Outbound Firewall Hardening Command for Domain and Private Profiles
# ============================================
# This command sets the default outbound action for the Domain and Private network profiles to "Block".
#
# What does this do?
# - It blocks any outbound network traffic that isn't explicitly allowed by a firewall rule.
# - Only outbound connections that have been specifically permitted will be allowed to pass.
#
# Why is this important?
# - **Prevents Data Exfiltration:** If malware or an attacker gains access to your system,
#   they won't be able to send data out without an explicit allow rule, reducing the risk of data leaks.
# - **Limits Unauthorized Communications:** Outbound blocking can prevent compromised applications
#   from connecting to command-and-control servers or other malicious endpoints.
# - **Enhanced Network Control:** This setting forces you to create rules for necessary outbound traffic,
#   ensuring that only trusted and approved communications are allowed.
#
# Note:
# - Blocking outbound traffic by default may impact normal operations.
# - You may need to create additional rules to allow legitimate outbound traffic for critical applications.
# - Test this configuration carefully in your environment to ensure it doesn't interrupt essential services.
Set-NetFirewallProfile -Profile Domain,Private -DefaultOutboundAction Block
