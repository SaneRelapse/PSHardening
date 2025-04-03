# ================================
# 🔒 Windows Security Hardening Script
# ================================
# This script modifies the Windows registry to enhance security by completely 
# preventing anonymous access to the Security Accounts Manager (SAM) database.
# This protects user account information from unauthorized enumeration attacks.

# 🛠 REGISTRY CHANGE:
# - RestrictAnonymousSAM = 2 (Maximum Security)
# - Prevents anonymous users from querying user and group account names.
# - Protects against enumeration-based reconnaissance attacks.
# - Helps mitigate threats such as brute-force authentication attacks.

Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" `
                 -Name "RestrictAnonymousSAM" `
                 -Type "DWORD" `
                 -Value 2 `
                 -Force

# ✅ SECURITY IMPACT:
# - Anonymous (unauthenticated) users will no longer be able to query SAM.
# - Prevents attackers from discovering valid usernames for brute-force attacks.
# - Reduces exposure to enumeration vulnerabilities.
# - No impact on legitimate, authenticated users.

# 🔄 REBOOT REQUIRED:
# - This change takes effect **only after a system reboot**.
# - To apply it immediately, run: Restart-Computer -Force

Write-Host "✔ Security hardening applied. Restart your system for changes to take effect." -ForegroundColor Green

# You can also run this instead
# Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "RestrictAnonymousSAM" -Type "DWORD" -Value 2 -Force
