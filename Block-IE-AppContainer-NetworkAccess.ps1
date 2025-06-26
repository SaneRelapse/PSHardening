# Block all existing firewall rules tied to the Internet Explorer AppContainer (windows_ie_ac_001).
# This hardens the system by:
# - Preventing sandboxed IE (Enhanced Protected Mode) processes from accessing the network.
# - Closing off legacy vectors that could be exploited by malicious ActiveX, COM, or legacy web content.
# - Eliminating unnecessary AppContainer traffic from a deprecated browser (Internet Explorer).
# - Reducing attack surface in systems that don't explicitly require legacy IE functionality.

Get-NetFirewallRule -AppContainerName "windows_ie_ac_001" | Set-NetFirewallRule -Action Block
