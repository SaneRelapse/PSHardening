Stop-Service -Name "SNMP" -Force
Set-Service -Name "SNMP" -StartupType Disabled
Remove-WindowsFeature -Name "SNMP-Service"
# Block SNMP (UDP 161) - Device Queries
New-NetFirewallRule -DisplayName "Block SNMP (UDP 161)" -Direction Inbound -Action Block -Protocol UDP -LocalPort 161 -Profile Any
New-NetFirewallRule -DisplayName "Block SNMP (UDP 161) Outbound" -Direction Outbound -Action Block -Protocol UDP -LocalPort 161 -Profile Any

# Block SNMP Traps (UDP 162) - Alerts from Devices
New-NetFirewallRule -DisplayName "Block SNMP Traps (UDP 162)" -Direction Inbound -Action Block -Protocol UDP -LocalPort 162 -Profile Any
New-NetFirewallRule -DisplayName "Block SNMP Traps (UDP 162) Outbound" -Direction Outbound -Action Block -Protocol UDP -LocalPort 162 -Profile Any

# Block SNMP (UDP 161) - Device Queries
New-NetFirewallRule -DisplayName "Block SNMP (UDP 161)" -Direction Inbound -Action Block -Protocol UDP -LocalPort 161 -RemotePort Any -Profile Any
New-NetFirewallRule -DisplayName "Block SNMP (UDP 161) Outbound" -Direction Outbound -Action Block -Protocol UDP -LocalPort 161 -RemotePort Any -Profile Any

# Block SNMP Traps (UDP 162) - Alerts from Devices
New-NetFirewallRule -DisplayName "Block SNMP Traps (UDP 162)" -Direction Inbound -Action Block -Protocol UDP -LocalPort 162 -RemotePort Any -Profile Any
New-NetFirewallRule -DisplayName "Block SNMP Traps (UDP 162) Outbound" -Direction Outbound -Action Block -Protocol UDP -LocalPort 162 -RemotePort Any -Profile Any
