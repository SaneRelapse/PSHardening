# Once auditing is enabled, look for these events in Event Viewer:

# Event ID 4673 – A privileged service was called (SeImpersonatePrivilege used)

# Event ID 4688 – A new process has been created (look for impersonation-related processes)

# Event ID 4696 – A token was assigned to a process (possible impersonation)
Get-WinEvent -LogName Security | Where-Object { $_.Id -eq 4673 -or $_.Id -eq 4696 } | Format-List
