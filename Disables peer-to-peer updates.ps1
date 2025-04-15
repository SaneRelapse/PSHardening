# You can disable the "Allow downloads from other devices" (Delivery Optimization) feature in Windows using PowerShell
# This command prevents your system from participating in peer-to-peer (P2P) file sharing for Windows updates and apps
# with other devices on your local network or the internet by disabling Delivery Optimization for updates.
# Here’s how this helps prevent vulnerabilities and reduce potential hacking risks:

# 1. Prevents Exposure to Malicious Content in P2P Networks
# P2P Sharing of Updates: When Delivery Optimization is enabled, Windows can download updates from other PCs
# that are part of the local network or the internet, in addition to downloading them directly from Microsoft servers.
# If this system is not properly secured, malicious actors could potentially intercept or tamper with the update data 
# while being shared between peers. By disabling this feature, your device will only download updates directly from
# Microsoft servers, which is a much more secure and controlled environment.

# Reduced Attack Surface: Disabling Delivery Optimization limits the number of machines your device communicates with
# during the update process. This minimizes the attack surface available for malicious actors attempting to exploit 
# vulnerabilities in the update distribution process.

# 2. Limits Exposure to Untrusted Devices
# Peer-to-Peer Vulnerabilities: When P2P updates are allowed, your machine may be downloading files from devices on
# your local network, which could be compromised or untrusted. If a device on the network is compromised, an attacker
# could potentially exploit it to infect other machines via the update process.
# By disabling P2P updates, your machine will only communicate with known, trusted sources (Microsoft servers),
# which reduces the risk of downloading malicious or compromised updates from untrusted devices.

# 3. Improves Control Over Updates
# Controlled Update Sources: Disabling P2P updates ensures that updates come only from Microsoft's servers, which 
# are more likely to be validated and properly secured. This gives you more control over the origin of updates, 
# preventing potentially unverified or unauthorized versions of updates from reaching your system.
# Auditing and Integrity: When the updates are solely from Microsoft, it’s easier to track, validate, and verify them 
# as they come through the official channels. This makes it harder for attackers to insert their own malicious 
# payloads into the update process.

# 4. Prevents Abuse of Bandwidth for Malware Propagation
# Bandwidth Used for Malware: Some malware and malicious software may use your system's P2P update feature to 
# propagate itself across devices on a local network. By disabling Delivery Optimization, you prevent your machine 
# from unknowingly becoming part of a botnet or distributing malicious software to other systems on the same network.

# 5. Limitations and Risks of P2P in an Enterprise Environment
# In an enterprise environment, the risk of vulnerabilities can be higher because large numbers of machines may 
# be connected in a network. Allowing Delivery Optimization for updates increases the risk of vulnerabilities being
# spread through the network. Disabling it ensures that updates come from a trusted source, which is important in 
# corporate and sensitive environments.

# Summary: How This Prevents Hacking and Vulnerabilities
# Disabling P2P updates through the DODownloadMode setting reduces the risk of:
# - Exposing the system to untrusted devices that might be compromised or malicious.
# - Intercepting or modifying update files in transit over the network, which could lead to malware infections 
#   or exploitation of vulnerabilities.
# - Becoming an inadvertent vector for spreading malicious software within a network.
# - Improperly validating updates, which could allow attackers to distribute tampered updates.

# This is an additional layer of security to ensure that your system is only getting updates from a controlled,
# trusted source, preventing unwanted and potentially dangerous exposures.

# Set the registry value to disable peer-to-peer updates (Delivery Optimization)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" -Name "DODownloadMode" -Value 0
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DoSvc" /v Start /t REG_DWORD /d 4 /f


