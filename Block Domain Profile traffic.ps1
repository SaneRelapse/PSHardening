# This script was created with Home Users in mind.
# The Domain profile in Windows Firewall is designed for enterprise environments
# where the computer is connected to a trusted corporate network with domain controllers.
# However, home users who inadvertently connect to an untrusted network while their system
# is still set to the Domain profile could be vulnerable for several reasons:
#
# 1. Automatic Trust in the Domain Profile
#    - The Domain profile assumes that all devices within the domain network are trusted.
#    - Certain inbound and outbound traffic is automatically allowed (e.g., file sharing, remote desktop, Active Directory services).
#    - This trust model is unsafe for home networks, where devices could be compromised.
#
# 2. Potential for Misconfiguration
#    - If a system fails to detect when it leaves a corporate network, it may stay on the Domain profile even when connected to a home or public network.
#    - This means it retains open firewall rules meant for corporate environments.
#    - Attackers on the same home Wi-Fi (or a compromised router) could exploit these looser firewall rules.
#
# 3. Exposed Services
#    - Many IT policies allow incoming connections in the Domain profile for services like:
#      * SMB (Server Message Block - File Sharing)
#      * RDP (Remote Desktop Protocol)
#      * LDAP (Lightweight Directory Access Protocol)
#    - If these services remain open at home, a malicious actor on the local network could exploit them.
#
# 4. No Network Isolation
#    - At work, enterprise networks have additional security layers (e.g., firewalls, intrusion detection).
#    - At home, a user’s Wi-Fi network may not have these protections, making their system an easier target.
#
# To mitigate these risks, this script blocks all inbound and outbound traffic for the Domain profile
# and logs connection attempts for auditing.

# Block all inbound traffic on Domain profile
New-NetFirewallRule -DisplayName "Block All Inbound Traffic - Domain" -Direction Inbound -Action Block -Profile Domain -Protocol Any

# Block all outbound traffic on Domain profile
New-NetFirewallRule -DisplayName "Block All Outbound Traffic - Domain" -Direction Outbound -Action Block -Profile Domain -Protocol Any

