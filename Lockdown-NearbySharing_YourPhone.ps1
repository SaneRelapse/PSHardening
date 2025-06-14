# Disable Nearby Sharing for the current user by setting NearShareChannel to 0
# This prevents unauthorized or accidental file sharing via Nearby Sharing,
# which reduces the attack surface for lateral movement or data leakage on local networks.
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CDP" -Name "NearShareChannel" -Value 0

# Ensure the Group Policy registry path for Nearby Sharing exists under HKLM (machine-wide policy)
# Creating this key allows setting a system-wide policy that overrides user settings,
# enforcing the disablement of Nearby Sharing for all users, increasing security baseline.
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CDP" -Force | Out-Null

# Set the machine-wide policy to disable Nearby Sharing by setting NearShareChannel to 0
# This prevents any user on the machine from enabling Nearby Sharing,
# which is important in enterprise or sensitive environments to prevent data leakage.
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CDP" -Name "NearShareChannel" -Value 0

# Remove the Your Phone app for all users to reduce telemetry and device linking features
# This minimizes potential attack surface from the Your Phone app and related services.
Get-AppxPackage Microsoft.YourPhone -AllUsers | Remove-AppxPackage
