﻿Get-Process -IncludeUserName | Where-Object {$_.UserName -eq 'NT AUTHORITY\SYSTEM'}
