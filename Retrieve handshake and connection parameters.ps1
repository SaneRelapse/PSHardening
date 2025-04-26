# Define the registry path and the names you want to check
$regPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters'
$names = @(
  'SynAttackProtect',
  'TcpMaxSynRetransmissions',
  'TcpMaxHalfOpen',
  'TcpMaxHalfOpenRetried',
  'TcpTimedWaitDelay',
  'MaxUserPort',
  'EnablePMTUDiscovery',
  'EnablePMTUBHDetect',
  'EnableICMPRedirect',
  'EnableDeadGWDetect',
  'EnableIPSourceRouting'
)

# Loop and display each
foreach ($name in $names) {
    $prop = Get-ItemProperty -Path $regPath -Name $name -ErrorAction SilentlyContinue
    if ($prop -and $prop.PSObject.Properties[$name]) {
        $value = $prop.$name
        Write-Host "`t$name = $value"
    }
    else {
        Write-Host "`t$name is not set in the registry (using OS default)"
    }
}
