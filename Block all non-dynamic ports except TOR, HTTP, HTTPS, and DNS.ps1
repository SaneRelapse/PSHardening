# This version of blocking Non-dynamic ports allows for TOR

# 9001 (Tor relay traffic)

# 9030 (Tor directory service)

# 9050-9051 (Tor SOCKS proxy)

# 9150-9151 (Tor Browser SOCKS proxy)

# To allow Tor while blocking other non-dynamic ports, modify your firewall rules like this:

# Block all non-dynamic inbound ports except HTTP, HTTPS, DNS, and Tor
New-NetFirewallRule -DisplayName "Block Non-Dynamic Inbound Ports" -Direction Inbound -Action Block -Protocol TCP -LocalPort 0-79,81-442,444-8079,8081-8999,9002-9029,9031-49151 -Profile Any
New-NetFirewallRule -DisplayName "Block Non-Dynamic Inbound Ports (UDP)" -Direction Inbound -Action Block -Protocol UDP -LocalPort 0-52,54-49151 -Profile Any

# Block all non-dynamic outbound ports except HTTP, HTTPS, DNS, and Tor
New-NetFirewallRule -DisplayName "Block Non-Dynamic Outbound Ports" -Direction Outbound -Action Block -Protocol TCP -LocalPort 0-79,81-442,444-8079,8081-8999,9002-9029,9031-9049,9052-9149,9152-49151 -Profile Any
New-NetFirewallRule -DisplayName "Block Non-Dynamic Outbound Ports (UDP)" -Direction Outbound -Action Block -Protocol UDP -LocalPort 0-52,54-49151 -Profile Any