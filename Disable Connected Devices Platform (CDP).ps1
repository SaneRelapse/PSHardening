# Disable Connected Devices Platform (CDP) to harden system against cross-device data leaks and tracking.
# This prevents Windows from sharing user activities, app sessions, and clipboard data across other signed-in devices via the Microsoft Graph.
# Reduces attack surface by disabling background services that sync personal or behavioral data to the cloud.
# Helps mitigate risks related to user profiling, unwanted remote session resumption, and unauthorized activity replication.

New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableCdp" -PropertyType DWORD -Value 0 -Force
