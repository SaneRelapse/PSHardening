# Block ICMP Timestamp Request (Type 13)
New-NetFirewallRule -DisplayName "Block ICMP Timestamp Request" -Protocol ICMPv4 -IcmpType 13 -Direction Inbound -Action Block

# Block ICMP Timestamp Reply (Type 14)
New-NetFirewallRule -DisplayName "Block ICMP Timestamp Reply" -Protocol ICMPv4 -IcmpType 14 -Direction Inbound -Action Block
