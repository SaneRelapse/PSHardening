# Block all inbound traffic (all protocols)
New-NetFirewallRule -DisplayName "Block All Inbound Protocols" -Direction Inbound -Action Block -Protocol Any -Profile PRIVATE

# Block all outbound traffic (all protocols)
New-NetFirewallRule -DisplayName "Block All Outbound Protocols" -Direction Outbound -Action Block -Protocol Any -Profile PRIVATE
