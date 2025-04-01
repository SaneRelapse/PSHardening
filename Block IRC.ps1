# Block IRC-related ports: 194, 529, 6660-6669, 6697, and 7000
New-NetFirewallRule -DisplayName "Block IRC Ports" -Direction Inbound -Protocol TCP -LocalPort 194,529,6660-6669,6697,7000 -Action Block -Description "Blocking IRC-related ports: 194, 529, 6660-6669, 6697, and 7000"
