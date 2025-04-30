# Stop any running SNMP service immediately to eliminate the attack surface
Stop-Service -Name "SNMP" -Force

# Disable SNMP so it cannot be started again (manually or by a dependency)
Set-Service -Name "SNMP" -StartupType Disabled

# Uninstall the SNMP feature entirely, removing binaries and config
Remove-WindowsFeature -Name "SNMP-Service"

#=======================================================================
# Firewall rules: block all SNMP traffic (UDP 161 for queries, 162 for traps)
# This ensures that even if SNMP were installed or re-enabled,
# no SNMP packets can reach or leave the host.
#=======================================================================

# Block inbound SNMP queries (UDP 161) from any source
New-NetFirewallRule `
  -DisplayName "Block SNMP Queries Inbound (UDP 161)" `
  -Direction Inbound `
  -Protocol UDP `
  -LocalPort 161 `
  -Action Block `
  -Profile Any

# Block outbound SNMP queries (UDP 161) to any destination
New-NetFirewallRule `
  -DisplayName "Block SNMP Queries Outbound (UDP 161)" `
  -Direction Outbound `
  -Protocol UDP `
  -LocalPort 161 `
  -Action Block `
  -Profile Any

# Block inbound SNMP trap messages (UDP 162)
New-NetFirewallRule `
  -DisplayName "Block SNMP Traps Inbound (UDP 162)" `
  -Direction Inbound `
  -Protocol UDP `
  -LocalPort 162 `
  -Action Block `
  -Profile Any

# Block outbound SNMP trap messages (UDP 162)
New-NetFirewallRule `
  -DisplayName "Block SNMP Traps Outbound (UDP 162)" `
  -Direction Outbound `
  -Protocol UDP `
  -LocalPort 162 `
  -Action Block `
  -Profile Any

#=======================================================================
# A second set of rules specifying RemotePort Any ensures that even
# misconfigured or dynamic SNMP implementations can’t slip through.
#=======================================================================

# Block inbound SNMP queries regardless of remote port
New-NetFirewallRule `
  -DisplayName "Block SNMP Queries Inbound (UDP 161) - Any RemotePort" `
  -Direction Inbound `
  -Protocol UDP `
  -LocalPort 161 `
  -RemotePort Any `
  -Action Block `
  -Profile Any

# Block outbound SNMP queries regardless of remote port
New-NetFirewallRule `
  -DisplayName "Block SNMP Queries Outbound (UDP 161) - Any RemotePort" `
  -Direction Outbound `
  -Protocol UDP `
  -LocalPort 161 `
  -RemotePort Any `
  -Action Block `
  -Profile Any

# Block inbound SNMP traps regardless of remote port
New-NetFirewallRule `
  -DisplayName "Block SNMP Traps Inbound (UDP 162) - Any RemotePort" `
  -Direction Inbound `
  -Protocol UDP `
  -LocalPort 162 `
  -RemotePort Any `
  -Action Block `
  -Profile Any

# Block outbound SNMP traps regardless of remote port
New-NetFirewallRule `
  -DisplayName "Block SNMP Traps Outbound (UDP 162) - Any RemotePort" `
  -Direction Outbound `
  -Protocol UDP `
  -LocalPort 162 `
  -RemotePort Any `
  -Action Block `
  -Profile Any

#=======================================================================
# SNMP Enumeration: Mechanics & Attack Scenarios
#=======================================================================

# What Is SNMP Enumeration?
# SNMP (Simple Network Management Protocol) is designed to monitor and configure networked devices.
# Enumeration is the process of querying SNMP-enabled hosts to extract valuable information—often using
# publicly-known “community strings” (like public or private) and standard MIB (Management Information Base)
# OIDs (Object Identifiers).

# How SNMP Enumeration Works:
#  - Community String Guessing:
#      SNMP v1/v2c use plaintext community strings as “passwords.” Attackers first try default
#      strings (public/private) or brute-force a customized list.
#  - SNMP GET & GETNEXT Requests:
#      Once they’ve got a valid string, they issue GET requests for specific OIDs (e.g., system
#      description, uptime, interface tables). GETNEXT and GETBULK let them walk through entire
#      MIB trees, harvesting large swaths of configuration data.
#  - Device Profiling:
#      The returned data reveals hardware models, firmware versions, interface IPs/MACs, routing
#      tables, ARP caches, installed software, and sometimes even user account info or passwords
#      stored in SNMP-accessible objects.

# Why Attackers Love SNMP Enumeration:
#  - Low Noise Recon:
#      SNMP queries blend into normal monitoring traffic, making them hard to spot in network logs
#      unless SNMP traffic is explicitly monitored or blocked.
#  - Rich Data Harvesting:
#      A single SNMP WALK can yield detailed topology maps, OS versions (to target known CVEs),
#      and service configurations—everything needed for follow-on exploits.
#  - Pivot & Lateral Movement:
#      With interface and routing info, attackers can plan internal scans, target high-value
#      segments, or configure rogue devices (if SNMP SET is allowed) to inject routes or disable
#      security controls.

# Real-World Attack Flow:
#  1. Discovery:
#      Attacker scans UDP/161 to find live SNMP endpoints.
#  2. Credential Testing:
#      Tries default or stolen community strings.
#  3. Data Extraction:
#      Performs SNMP WALKs on OIDs under .1.3.6.1.2.1 (the standard MIB-II tree).
#  4. Analysis & Exploitation:
#      Parses returned tables to identify outdated firmware, open interfaces, or even view
#      plaintext SNMP-stored credentials.
#  5. Pivot:
#      Uses learned topology or credentials to breach deeper systems or reconfigure network
#      gear to intercept traffic.

# By disabling SNMP services and fully blocking UDP ports 161/162, you cut off this reconnaissance
# vector entirely—no service to query, no community string to guess, and no MIB data to harvest.

#=======================================================================
# Example SNMP Check Output (what a real scan might reveal)
#=======================================================================

# [*] System information:
# 
#   Host IP address               : 192.168.1.2
#   Hostname                      : example-host
#   Description                   : Test Server
#   Contact                       : admin@example.com
#   Location                      : Data Center Rack 5
#   Uptime snmp                   : 12 days, 04:22:10
#   Uptime system                 : 12 days, 04:22:12
#   System date                   : 2025-04-29 13:45:23
# 
# [*] Network information:
#   Interfaces: eth0, eth1
#   ARP Cache Entries: 23
# 
# [*] Network interfaces:
#   eth0: up, 192.168.1.2/24, mac 00:11:22:33:44:55
#   eth1: down, 10.0.0.5/24, mac 00:11:22:33:44:56
# 
# [*] Network IP:
#   Default Gateway: 192.168.1.1
#   DNS Servers: 8.8.8.8, 8.8.4.4
# 
# [*] Routing information:
#   0.0.0.0/0 via 192.168.1.1
#   10.0.0.0/24 via 10.0.0.1
# 
# [*] TCP connections and listening ports:
#   LISTEN 0.0.0.0:22 sshd
#   ESTABLISHED 192.168.1.100:53422 -> 192.168.1.2:22
# 
# [*] Listening UDP ports:
#   161/snmpd (community: public)
#   123/ntpd
