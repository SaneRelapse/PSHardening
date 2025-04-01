Get-Process -Name svchost -IncludeUserName | Where-Object {$_.UserName -eq 'NT AUTHORITY\SYSTEM'} | ForEach-Object {Get-Process -Id $_.Id -Module}
