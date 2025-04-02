# If File and Printer Sharing (ms_server) is enabled, your system is potentially vulnerable to four types of attacks,
# especially when connected to untrusted networks (public Wi-Fi, hotels, airports, etc.).

# Why Keeping ms_server Enabled is Risky

# 1. Remote Exploitation (SMB Attacks)
# - The Server Message Block (SMB) protocol is used for file sharing. If exposed, attackers can exploit vulnerabilities like EternalBlue (used in WannaCry ransomware) to gain remote access.
# - SMB-based brute-force attacks can guess weak credentials.
# - Anonymous connections (if misconfigured) may expose shared resources.

# 2. Lateral Movement (Internal Network Attacks)
# - If an attacker gains access to one system on your network, they can use SMB to move laterally to your machine.
# - Pass-the-Hash (PtH) attacks allow attackers to authenticate as you without knowing your password.

# 3. Man-in-the-Middle (MITM) Attacks
# - Attackers can intercept SMB traffic, capturing credentials and file transfers.
# - Tools like Responder can poison SMB requests and steal NTLM hashes.

# 4. Exposing Shared Folders & Printers
# - If file/printer sharing is enabled and not properly restricted, attackers might access sensitive files.
# - Misconfigured open shares may allow attackers to read/write files.

# How Disabling ms_server Helps
# ✅ Prevents SMB-based remote exploits
# ✅ Blocks unauthorized file and printer access
# ✅ Reduces attack surface for malware like WannaCry
# ✅ Stops internal lateral movement via SMB

# Final Verdict
# Disabling ms_server on all network adapters (Ethernet & Wi-Fi) is a smart security move unless you specifically need file sharing.

# Disable File and Printer Sharing on Ethernet and Wi-Fi
Disable-NetAdapterBinding -Name "Ethernet" -ComponentID ms_server
Disable-NetAdapterBinding -Name "Wi-Fi" -ComponentID ms_server
# You can Enumerate with the command
# Get-NetAdapterBinding
