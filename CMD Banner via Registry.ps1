$cmdKey = "HKCU:\Software\Microsoft\Command Processor"

if (-not (Test-Path $cmdKey)) {
    New-Item -Path $cmdKey -Force | Out-Null
}

Set-ItemProperty -Path $cmdKey -Name "AutoRun" -Value 'echo YOU HAVE BEEN CAUGHT. DO NOT ATTEMPT TO ACCESS FILES, INJECT CODE, ESCALATE PRIVILEGES, OR ATTEMPT LATERAL MOVEMENT. CEASE AND DESIST IMMEDIATELY.'