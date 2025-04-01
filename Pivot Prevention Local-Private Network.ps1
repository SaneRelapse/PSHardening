# Pivoting is a hacking technique where an attacker gains initial access to a compromised system and then moves laterally through a local network/private to access other systems.
# This method is commonly used in post-exploitation scenarios, allowing attackers to bypass security controls and reach deeper into a network.
# This Script hopes to prevent these types of attacks.

﻿# Block all inbound traffic (all protocols)
New-NetFirewallRule -DisplayName "Block All Inbound Protocols" -Direction Inbound -Action Block -Protocol Any -Profile PRIVATE

# Block all outbound traffic (all protocols)
New-NetFirewallRule -DisplayName "Block All Outbound Protocols" -Direction Outbound -Action Block -Protocol Any -Profile PRIVATE
