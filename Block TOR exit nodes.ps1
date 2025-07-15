# This script retrieves a real-time list of Tor exit node IPs.
# Tor exit nodes are commonly used by:
#  - Attackers trying to hide their origin
#  - Scrapers, brute-forcers, and bots
#  - People trying to bypass geoblocks or rate limits

# By blocking these IPs from initiating inbound connections:
# ✅ You reduce your exposure to anonymous and abusive sources
# ✅ You protect services like RDP, web servers, or admin interfaces
# ✅ You make your system less visible to automated Tor-based recon and scans
# Retrieve the current list of Tor exit node IPs from a trusted source
$torIPs = Invoke-WebRequest -Uri "https://www.dan.me.uk/torlist/?exit" -UseBasicParsing | Select-Object -ExpandProperty Content

# Split the retrieved content into individual IP addresses
$torIPs = $torIPs -split "`n"

# Loop through each IP and create a Windows Firewall rule to block inbound traffic
foreach ($ip in $torIPs) {
    if ($ip -match '^\d{1,3}(\.\d{1,3}){3}$') {  # Validate IPv4 format
        New-NetFirewallRule -DisplayName "Block_Tor_$ip" -Direction Inbound -RemoteAddress $ip -Action Block -Protocol Any
    }
}
