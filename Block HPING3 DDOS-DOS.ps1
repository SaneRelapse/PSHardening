# Block Hping3 DDOS 
New-NetFirewallRule -DisplayName "Block Outbound Port 0 NULL TCP HPING3 DDOS" -Direction Outbound -LocalPort 0 -Protocol TCP -Action Block
New-NetFirewallRule -DisplayName "Block Inbound Port 0 NULL TCP HPING3 DDOS" -Direction Inbound -LocalPort 0 -Protocol TCP -Action Block
New-NetFirewallRule -DisplayName "Block Outbound Port 0 UDP HPING3 DDOS" -Direction Outbound -LocalPort 0 -Protocol UDP -Action Block
New-NetFirewallRule -DisplayName "Block Inbound Port 0 UDP HPING3 DDOS" -Direction Inbound -LocalPort 0 -Protocol UDP -Action Block
