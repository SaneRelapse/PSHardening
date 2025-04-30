# =============================================================================
# ARP Spoofing Mitigation for Windows 11 Home
# =============================================================================
# Purpose:
#   • Lock down ARP behavior to prevent ARP cache poisoning (Man-in-the-LAN).
#   • Enforce “strong host” model so each NIC only answers ARP for its own IP.
#   • Pin static ARP entries for your gateway and DNS servers.
# =============================================================================

# 1) Disable the Weak Host Model on all IPv4 interfaces
#    - By default Windows will respond to ARP requests on any NIC for any IP (weak host).
#    - Disabling WeakHostSend/WeakHostReceive enforces per-interface ARP isolation.
Get-NetIPInterface -AddressFamily IPv4 | ForEach-Object {
    Set-NetIPInterface `
        -InterfaceIndex $_.InterfaceIndex `
        -WeakHostSend Disabled `
        -WeakHostReceive Disabled
    Write-Host "Disabled weak host on interface '$($_.InterfaceAlias)'"
}

# 2) Retrieve your default gateway IP and interface alias
$cfg = Get-NetIPConfiguration | Where-Object IPv4DefaultGateway
$gwIp    = $cfg.IPv4DefaultGateway.NextHop
$iface   = $cfg.InterfaceAlias

# 3) Read the current ARP entry for your gateway to lock it in
#    - This captures the true MAC, so an attacker can’t poison it.
$arpLine = (arp -a $gwIp) -match $gwIp
if ($arpLine) {
    $gwMac = ($arpLine -split '\s+')[1]
    # Add a permanent ARP entry for the gateway
    netsh interface ipv4 add neighbors `
        name="$iface" `
        address=$gwIp `
        macaddress=$gwMac `
        | Out-Null
    Write-Host "Pinned static ARP entry for gateway $gwIp → $gwMac"
} else {
    Write-Warning "Unable to read ARP entry for $gwIp. Ensure you’re online and run again."
}

# 4) (Optional) Pin ARP for your DNS servers too
$dnsServers = (Get-DnsClientServerAddress -AddressFamily IPv4 -InterfaceAlias $iface).ServerAddresses
foreach ($dns in $dnsServers) {
    $arpLine = (arp -a $dns) -match $dns
    if ($arpLine) {
        $dnsMac = ($arpLine -split '\s+')[1]
        netsh interface ipv4 add neighbors `
            name="$iface" `
            address=$dns `
            macaddress=$dnsMac `
            | Out-Null
        Write-Host "Pinned static ARP entry for DNS $dns → $dnsMac"
    } else {
        Write-Warning "Unable to read ARP entry for DNS $dns."
    }
}

Write-Host "`nARP anti-spoofing configuration complete."
Write-Host "Reboot recommended to enforce Weak Host changes."

# =============================================================================
# How this hardens Windows:
# - Disabling WeakHostSend/WeakHostReceive prevents your NIC from answering
#   ARP for IPs bound to other interfaces, thwarting cross-NIC ARP spoofing.
# - Pinning static ARP entries for critical hops (gateway, DNS) stops attackers
#   from injecting fake MAC/IP mappings into your ARP cache.
# - Together, these steps significantly reduce the risk of local MITM or
#   traffic interception over your LAN.
# =============================================================================
