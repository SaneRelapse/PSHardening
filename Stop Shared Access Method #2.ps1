# -----------------------------------------------------------------------------
# PSHardening Registry Script: Disable Internet Connection Sharing (ICS)
#
# Overview:
# This script stops the SharedAccess service immediately and updates the registry 
# to prevent it from starting at boot. Disabling ICS reduces potential attack vectors 
# by ensuring the system does not share its network connection with other devices.
#
# Security Benefits:
# 1. Immediate cessation of network sharing minimizes exposure to unauthorized access.
# 2. Modifying the registry ensures persistent protection, even after a system restart.
# -----------------------------------------------------------------------------

# Stop the SharedAccess service immediately.
# The '-Force' parameter ensures the service and any dependent processes are halted.
Stop-Service -Name SharedAccess -Force

# Disable the SharedAccess service from starting automatically on boot by updating the registry.
# The registry key for the service is located at:
# HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess
#
# Within this key, the 'Start' value controls the startup type:
#  - 2 = Automatic
#  - 3 = Manual
#  - 4 = Disabled
#
# Setting 'Start' to 4 ensures that Windows will not start the SharedAccess service 
# when the system boots.
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess" -Name Start -Value 4

# Alternatively, the registry change can be done with the 'reg add' command:
# reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess" /v Start /t REG_DWORD /d 4 /f

# -----------------------------------------------------------------------------
# End of Script
#
# By stopping the service and updating the registry to disable the service, you
# prevent your computer from engaging in Internet Connection Sharing (ICS), which:
# - Reduces the network attack surface.
# - Prevents potential unauthorized access from other devices.
# - Helps mitigate exposure to network-based exploits.
# -----------------------------------------------------------------------------
