# Enable auditing for named pipe handle manipulation (detects unauthorized access to named pipes)
auditpol /set /subcategory:"Handle Manipulation" /success:enable /failure:enable

# Enforce strongest authentication level (NTLMv2/Kerberos only, blocking LM and NTLMv1)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "LmCompatibilityLevel" -Value 5

# Disable anonymous (null session) named pipes (prevents unauthenticated access to system services)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "NullSessionPipes" -Value ""

# Restrict null session access to shared resources (blocks anonymous SMB access)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "RestrictNullSessAccess" -Value 1

# Disable anonymous (null session) shares (prevents unauthenticated users from accessing shared folders)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "NullSessionShares" -Value ""

# Disable NetBIOS helper service (blocks LMHOSTS name resolution, reducing attack surface)
Set-Service -Name "lmhosts" -StartupType Disabled

# Disable SMB file sharing service (prevents sharing files/folders over SMB)
Set-Service -Name "LanmanServer" -StartupType Disabled

# Disable SMB client service (prevents this machine from accessing SMB shares on other computers)
Set-Service -Name "LanmanWorkstation" -StartupType Disabled

# ✅ Enabling auditing of named pipes
# ✅ Enforcing secure authentication (blocking LM & NTLMv1)
# ✅ Blocking anonymous access to named pipes and shares
# ✅ Disabling SMB services to reduce attack surface
