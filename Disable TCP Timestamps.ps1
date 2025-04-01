# Mitigate Uptime calculation
# Mitigate Host identification using clock skew


﻿netsh int tcp set global timestamps=disabled


New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "Tcp1323Opts" -Value 0 -PropertyType DWORD -Force
