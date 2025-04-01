Get-WmiObject -Class Win32_Service | 
    Where-Object {$_.ProcessID -in (Get-Process -IncludeUserName -Name svchost | Where-Object {$_.UserName -eq 'NT AUTHORITY\SYSTEM'}).Id} | 
    Select-Object Name, DisplayName, State, ProcessID
