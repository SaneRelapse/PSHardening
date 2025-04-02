# What it does: Configures Windows to disallow anonymous users from enumerating system accounts and resources.

# Why it's important: It minimizes security risks by preventing unauthorized access via null sessions.

# Overall impact: Enhances system security, though it may require adjustments for legacy applications relying on anonymous access.

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' -Name RestrictAnonymous -Value 2
