<#
.SYNOPSIS
  Enumerate actual TCP/UDP listeners and detect hidden ones via bind()
#>

# 1) Gather known listeners
$props = [System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties()
$tcpEPs = $props.GetActiveTcpListeners()
$udpEPs = $props.GetActiveUdpListeners()

# 2) Build the known‑ports sets
$knownTcp = [System.Collections.Generic.HashSet[int]]::new()
foreach ($ep in $tcpEPs) { $knownTcp.Add($ep.Port) | Out-Null }

$knownUdp = [System.Collections.Generic.HashSet[int]]::new()
foreach ($ep in $udpEPs) { $knownUdp.Add($ep.Port) | Out-Null }

Write-Host "Known TCP listeners: $($knownTcp.Count)"
Write-Host "Known UDP listeners: $($knownUdp.Count)"

# 3) Brute‑force bind on missing ports
$hidden = [System.Collections.Generic.List[psobject]]::new()

for ($port = 1; $port -le 65535; $port++) {
    # TCP check
    if (-not $knownTcp.Contains($port)) {
        $sock = [System.Net.Sockets.Socket]::new(
            [System.Net.Sockets.AddressFamily]::InterNetwork,
            [System.Net.Sockets.SocketType]::Stream,
            [System.Net.Sockets.ProtocolType]::Tcp
        )
        try {
            $sock.Bind([System.Net.IPEndPoint]::new([System.Net.IPAddress]::Loopback, $port))
        }
        catch [System.Net.Sockets.SocketException] {
            if ($_.ErrorCode -eq 10048) {
                $hidden.Add([PSCustomObject]@{ Protocol = 'TCP'; Port = $port })
            }
        }
        finally { $sock.Close() }
    }

    # UDP check
    if (-not $knownUdp.Contains($port)) {
        $usock = [System.Net.Sockets.Socket]::new(
            [System.Net.Sockets.AddressFamily]::InterNetwork,
            [System.Net.Sockets.SocketType]::Dgram,
            [System.Net.Sockets.ProtocolType]::Udp
        )
        try {
            $usock.Bind([System.Net.IPEndPoint]::new([System.Net.IPAddress]::Loopback, $port))
        }
        catch [System.Net.Sockets.SocketException] {
            if ($_.ErrorCode -eq 10048) {
                $hidden.Add([PSCustomObject]@{ Protocol = 'UDP'; Port = $port })
            }
        }
        finally { $usock.Close() }
    }
}

# 4) Report
if ($hidden.Count -eq 0) {
    Write-Host "No hidden listeners detected."
} else {
    Write-Host "Hidden listeners detected on these ports:"
    $hidden | Sort-Object Protocol, Port | Format-Table -AutoSize
}
