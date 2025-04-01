#Wifi Pineapple Remote
New-NetFirewallRule -DisplayName "Block Outbound Port 1471 Wifi Pineapple" -Direction Outbound -RemotePort 1471 -Protocol TCP -Action Block
New-NetFirewallRule -DisplayName "Block Inbound Port 1471 Wifi Pineapple" -Direction Inbound -RemotePort 1471 -Protocol TCP -Action Block
New-NetFirewallRule -DisplayName "Block Outbound Port 1471 Wifi Pineapple" -Direction Outbound -RemotePort 1471 -Protocol UDP -Action Block
New-NetFirewallRule -DisplayName "Block Inbound Port 1471 Wifi Pineapple" -Direction Inbound -RemotePort 1471 -Protocol UDP -Action Block