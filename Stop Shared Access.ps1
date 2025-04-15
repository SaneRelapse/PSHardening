# -----------------------------------------------------------
# Security Hardening Script: Disable Internet Connection Sharing (ICS)
#
# Purpose: This script stops and disables the SharedAccess service,
# which is responsible for ICS. Disabling ICS prevents your computer
# from sharing its network connection with other devices, thereby:
#
# 1. Reducing the network attack surface by closing ports used for sharing.
# 2. Preventing unauthorized access from untrusted devices.
# 3. Minimizing the risk of network-based attacks such as man-in-the-middle.
# 4. Ensuring that unnecessary services do not run, maintaining a secure environment.
# -----------------------------------------------------------

# Stop the SharedAccess service immediately.
# 'Stop-Service' stops the service, and '-Force' ensures that dependent services are also stopped.
Stop-Service -Name SharedAccess -Force

# Disable the SharedAccess service from starting at boot.
# 'Set-Service' changes the startup type, and setting it to Disabled ensures it does not restart automatically.
Set-Service -Name SharedAccess -StartupType Disabled

# -----------------------------------------------------------
# End of Script
# By stopping and disabling the SharedAccess service, the system will no longer participate in ICS,
# reducing potential vulnerabilities associated with network sharing.
# -----------------------------------------------------------
