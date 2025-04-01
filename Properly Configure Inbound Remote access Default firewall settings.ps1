# In my opinion, the remote access settings in firewall are improperly configured by default. This is how they should be configured...
# This script blocks the remote access rules that are in some windows systems by default which are not blocked by default.......
# Ensure script is running with administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "You must run this script as an Administrator."
    exit
}

# List of firewall rules to modify
$firewallRules = @(
    "Remote Assistance (DCOM-In)",
    "Remote Assistance (PNRP-In)",
    "Remote Assistance (RA Server TCP-In)",
    "Remote Assistance (SSDP TCP-In)",
    "Remote Assistance (SSDP UDP-In)",
    "Remote Assistance (TCP-In)",
    "Remote Event Log Management (NP-In)",
    "Remote Event Log Management (RPC)",
    "Remote Event Log Management (RPC-EPMAP)",
    "Remote Event Monitor (RPC)",
    "Remote Event Monitor (RPC-EPMAP)",
    "Remote Scheduled Tasks Management (RPC)",
    "Remote Scheduled Tasks Management (RPC-EPMAP)",
    "Remote Service Management (NP-In)",
    "Remote Service Management (RPC)",
    "Remote Service Management (RPC-EPMAP)",
    "Inbound Rule for Remote Shutdown (RPC-EP-In)",
    "Inbound Rule for Remote Shutdown (TCP-In)",
    "Remote Volume Management - Virtual Disk Service (RPC)",
    "Remote Volume Management - Virtual Disk Service Loader (RPC)",
    "Remote Volume Management (RPC-EPMAP)",
    "Routing and Remote Access (GRE-In)",
    "Routing and Remote Access (L2TP-In)",
    "Routing and Remote Access (PPTP-In)"
)

# Process each rule
foreach ($rule in $firewallRules) {
    $existingRule = Get-NetFirewallRule -DisplayName $rule -ErrorAction SilentlyContinue
    
    if ($existingRule) {
        # Set rule action to Block and enable it
        Set-NetFirewallRule -DisplayName $rule -Action Block -Enabled True
        Write-Host "Updated rule: $rule (Blocked and Enabled)" -ForegroundColor Green
    } else {
        Write-Host "Rule not found: $rule" -ForegroundColor Yellow
    }
}
