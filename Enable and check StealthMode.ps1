# PowerShell Script: Enable Stealth Mode for IPsec on All Firewall Profiles

# What This Script Does:

# Step 1: Enabling Stealth Mode for IPsec:
# The first command Set-NetFirewallProfile -Profile Domain,Private,Public -EnableStealthModeForIPsec True enables Stealth Mode for IPsec on all firewall profiles:
# - Domain: Active Directory environments, typically used in corporate networks.
# - Private: Trusted home or work networks.
# - Public: Untrusted networks, such as public Wi-Fi or hotspots.
# Enabling Stealth Mode means your system will not respond to certain unsolicited traffic, such as ICMP unreachable messages or TCP reset messages, particularly for ports where no application is listening. This makes the system less visible to network scanners.

# Step 2: Verifying Stealth Mode for IPsec:
# The Get-NetFirewallProfile | Select-Object Name, EnableStealthModeForIPsec command retrieves the current firewall profile settings, specifically showing the Stealth Mode for IPsec setting for each profile. 
# It will return either True (enabled) or False (disabled), allowing you to confirm whether the settings were applied successfully.

# Final Confirmation:
# A message is displayed after the verification, confirming that Stealth Mode for IPsec has been successfully enabled on all firewall profiles.

Write-Host "Enabling Stealth Mode for IPsec on all firewall profiles..."

# Step 1: Enable Stealth Mode for IPsec on all firewall profiles
Set-NetFirewallProfile -Profile Domain,Private,Public -EnableStealthModeForIPsec True

Write-Host "Verifying if Stealth Mode for IPsec is enabled..."

# Step 2: Verify if Stealth Mode for IPsec is enabled on all firewall profiles
Get-NetFirewallProfile | Select-Object Name, EnableStealthModeForIPsec

Write-Host "Stealth Mode for IPsec is now enabled on all profiles."


# How This Script Helps Harden the System:

# Reduces Exposure to Scanners and Attackers:
# Stealth Mode helps protect your system from being detected by attackers using network scanning tools like Nmap or Nessus. These tools scan for open ports and services on devices,
# but when Stealth Mode is enabled, your system will not send responses such as ICMP unreachable or TCP reset messages to unsolicited traffic, making it invisible to such scanners.

# Prevents OS Fingerprinting:
# Stealth Mode also hides your system's behavior when scanning tools try to determine the operating system by examining how it responds to various probes (OS fingerprinting). 
# This can thwart attackers who use this method to gather information about the OS, which can later be exploited for specific vulnerabilities.

# Protects IPsec Communications:
# By enabling Stealth Mode for IPsec-secured traffic, this ensures that while your system is using IPsec (used for encrypted communications), 
# it will remain hidden and harder to detect even when using encrypted connections. This provides additional protection, especially when transmitting sensitive data over the network.

# Enhances Privacy on Public Networks:
# Systems that are connected to untrusted networks (such as public Wi-Fi) are highly vulnerable to attacks due to the lack of security on such networks.
# Enabling Stealth Mode on the Public profile ensures that your system does not reveal itself to any potential attackers on the same network, preventing discovery and minimizing the attack surface.

# Hardens System Against Network Probing:
# While firewalls already block unauthorized inbound traffic, Stealth Mode adds an extra layer of protection by ensuring that even if attackers try to probe the system, 
# they will get no response, making it difficult to even detect the system's presence.

