# Prevent Windows from storing activity history (e.g., apps used, files opened, websites visited) locally on the system.
# This eliminates the risk of local forensic recovery of user behavior data by attackers, forensic tools, or unauthorized users.
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -PropertyType DWORD -Value 0 -Force

# Prevent Windows from uploading activity history to Microsoft cloud services.
# This blocks synchronization of user behavior across devices tied to the same Microsoft account or tenant.
# Hardens system privacy posture by cutting off telemetry-like data flow to Microsoft Graph and cloud analysis tools.
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -PropertyType DWORD -Value 0 -Force

# Why It Matters for Hardening:
# - No local trail of activities: Makes data exfiltration and post-breach forensics harder for adversaries.
# - Cloud sync disabled: Prevents leakage of behavioral metadata to the cloud, reducing exposure to third-party compromise.
# - Cross-device behavioral mapping neutralized: Defeats Microsoft’s ability to reconstruct your workflow across machines.
