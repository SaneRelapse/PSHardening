# Function to get Wi-Fi networks and filter by SSID containing "Pineapple"
function Get-WiFiNetworks {
    # Get the Wi-Fi networks and filter by SSID containing "Pineapple"
    $networks = netsh wlan show networks mode=bssid | Select-String -Pattern "SSID|BSSID" -Context 0,2
    $pineappleNetworks = @()
    
    foreach ($network in $networks) {
        if ($network -match "SSID\s+\d+\s+:\s+(.*Pineapple.*)") {
            $pineappleNetworks += $network
        }
    }
    
    return $pineappleNetworks
}

# Function to block IP using Windows Firewall
function Block-DeviceAtFirewall {
    param (
        [string]$IP
    )
    
    Write-Host "Blocking device with IP address: $IP"
    
    # Add a rule to block the device at the firewall
    New-NetFirewallRule -DisplayName "Block Pineapple AP ($IP)" `
                        -Direction Outbound `
                        -Action Block `
                        -RemoteAddress $IP `
                        -Protocol TCP
}

# Function to get IP address of a device (simple ping)
function Get-DeviceIP {
    param (
        [string]$bssid
    )
    
    # Ping the BSSID address to get the IP (note: this will require that the BSSID/AP is responsive)
    $ping = Test-Connection -ComputerName $bssid -Count 1 -Quiet
    if ($ping) {
        $ip = (Test-Connection -ComputerName $bssid -Count 1).Address.IPAddressToString
        return $ip
    } else {
        Write-Host "Unable to resolve IP for BSSID: $bssid"
        return $null
    }
}

# Main Script with Loop
while ($true) {
    Write-Host "Scanning for networks with 'Pineapple' in SSID..."
    
    $pineappleNetworks = Get-WiFiNetworks

    if ($pineappleNetworks.Count -gt 0) {
        Write-Host "Found the following networks with 'Pineapple' in the SSID:"
        $pineappleNetworks
        
        foreach ($network in $pineappleNetworks) {
            # Extract BSSID (MAC address)
            if ($network -match "BSSID\s+:\s+(\S+)") {
                $bssid = $matches[1]
                Write-Host "Found BSSID: $bssid"
                
                # Try to get the IP address of the device associated with this BSSID
                $deviceIP = Get-DeviceIP -bssid $bssid
                
                if ($deviceIP) {
                    # Block the device at the firewall
                    Block-DeviceAtFirewall -IP $deviceIP
                }
            }
        }
    } else {
        Write-Host "No networks with 'Pineapple' in the SSID found."
    }

    # Wait for 10 seconds before scanning again
    Write-Host "Waiting 10 seconds before next scan..."
    Start-Sleep -Seconds 10
}

