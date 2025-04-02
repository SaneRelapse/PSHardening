# Detecting Token Impersonation in Windows
# Token impersonation allows attackers to execute code with higher privileges by "borrowing" another user’s security token.
auditpol /set /subcategory:"Sensitive Privilege Use" /success:enable /failure:enable
