# Define an array with the names of the default File and Printer Sharing rules.
# These rules control both inbound and outbound network traffic related to file and printer sharing.
$rules = @(
    "File and Printer Sharing (Echo Request - ICMPv4-In)",
    "File and Printer Sharing (Echo Request - ICMPv4-In)",
    "File and Printer Sharing (Echo Request - ICMPv6-In)",
    "File and Printer Sharing (Echo Request - ICMPv6-In)",
    "File and Printer Sharing (LLMNR-UDP-In)",
    "File and Printer Sharing (NB-Datagram-In)",
    "File and Printer Sharing (NB-Datagram-In)",
    "File and Printer Sharing (NB-Name-In)",
    "File and Printer Sharing (NB-Name-In)",
    "File and Printer Sharing (NB-Session-In)",
    "File and Printer Sharing (NB-Session-In)",
    "File and Printer Sharing (SMB-In)",
    "File and Printer Sharing (SMB-In)",
    "File and Printer Sharing (Spooler Service - RPC)",
    "File and Printer Sharing (Spooler Service - RPC)",
    "File and Printer Sharing (Spooler Service - RPC-EPMAP)",
    "File and Printer Sharing (Spooler Service - RPC-EPMAP)",
    "File and Printer Sharing (Spooler Service Worker - RPC)",
    "File and Printer Sharing (Spooler Service Worker - RPC)",
    "File and Printer Sharing (Restrictive) (Echo Request - ICMPv4-In)",
    "File and Printer Sharing (Restrictive) (Echo Request - ICMPv6-In)",
    "File and Printer Sharing (Restrictive) (LLMNR-UDP-In)",
    "File and Printer Sharing (Restrictive) (SMB-In)",
    "File and Printer Sharing (Restrictive) (Spooler Service - RPC)",
    "File and Printer Sharing (Restrictive) (Spooler Service - RPC-EPMAP)",
    "File and Printer Sharing (Restrictive) (Spooler Service Worker - RPC)",
    "File and Printer Sharing (Echo Request - ICMPv4-Out)",
    "File and Printer Sharing (Echo Request - ICMPv4-Out)",
    "File and Printer Sharing (Echo Request - ICMPv6-Out)",
    "File and Printer Sharing (Echo Request - ICMPv6-Out)",
    "File and Printer Sharing (LLMNR-UDP-Out)",
    "File and Printer Sharing (NB-Datagram-Out)",
    "File and Printer Sharing (NB-Datagram-Out)",
    "File and Printer Sharing (NB-Name-Out)",
    "File and Printer Sharing (NB-Name-Out)",
    "File and Printer Sharing (NB-Session-Out)",
    "File and Printer Sharing (NB-Session-Out)",
    "File and Printer Sharing (SMB-Out)",
    "File and Printer Sharing (SMB-Out)",
    "File and Printer Sharing (Restrictive) (Echo Request - ICMPv4-Out)",
    "File and Printer Sharing (Restrictive) (Echo Request - ICMPv6-Out)",
    "File and Printer Sharing (Restrictive) (LLMNR-UDP-Out)",
    "File and Printer Sharing (Restrictive) (SMB-Out)"
)

# Loop through each rule in the list.
foreach ($rule in $rules) {
    # The Set-NetFirewallRule cmdlet updates the rule by:
    # - Setting the action to 'Block', which prevents any matching traffic from passing.
    # - Enabling the rule, ensuring it actively enforces these restrictions.
    Set-NetFirewallRule -DisplayName $rule -Action Block -Enabled True
}

# Explanation:
# By configuring these default firewall settings to block traffic, we seal a potential security hole.
# File and Printer Sharing services, if left open or misconfigured, can expose systems to unauthorized access,
# exploitation via network protocols, or propagation of malware.
# Blocking these ports and protocols helps to reduce the attack surface and secure the system against intrusions.
