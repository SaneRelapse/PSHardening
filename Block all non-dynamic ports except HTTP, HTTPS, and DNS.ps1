# Block all non-dynamic inbound ports except HTTP, HTTPS, and DNS
New-NetFirewallRule -DisplayName "Block Non-Dynamic Inbound Ports" -Direction Inbound -Action Block -Protocol TCP -LocalPort 0-79,81-442,444-8079,8081-49151 -Profile Any
New-NetFirewallRule -DisplayName "Block Non-Dynamic Inbound Ports (UDP)" -Direction Inbound -Action Block -Protocol UDP -LocalPort 0-52,54-49151 -Profile Any

# Block all non-dynamic outbound ports except HTTP, HTTPS, and DNS
New-NetFirewallRule -DisplayName "Block Non-Dynamic Outbound Ports" -Direction Outbound -Action Block -Protocol TCP -LocalPort 0-79,81-442,444-8079,8081-49151 -Profile Any
New-NetFirewallRule -DisplayName "Block Non-Dynamic Outbound Ports (UDP)" -Direction Outbound -Action Block -Protocol UDP -LocalPort 0-52,54-49151 -Profile Any
