reg add "HKCU\Software\Microsoft\YourPhone" /v "SmsEnabled" /t REG_DWORD /d 0 /f
Get-StartApps | Where-Object { $_.Name -like "*messages*" }  # Find app name
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\<AppName>" -Name "Enabled" -Value 0 -PropertyType DWord -Force
New-NetFirewallRule -DisplayName "Block SMS Sync" -Direction Outbound -Action Block -Program "%SystemRoot%\System32\YourPhone.exe"
Get-AppxPackage *messages* | Remove-AppxPackage

