if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "You must run this script as an Administrator."
    exit
}

# New list of outbound firewall rules to modify
$firewallRules = @(
    "Remote Assistance (PNRP-Out)",
    "Remote Assistance (PNRP-Out)",  # duplicate entry; remove if not needed
    "Remote Assistance (RA Server TCP-Out)",
    "Remote Assistance (SSDP TCP-Out)",
    "Remote Assistance (SSDP UDP-Out)",
    "Remote Assistance (TCP-Out)",
    "Remote Assistance (TCP-Out)",    # duplicate entry; remove if not needed
    "Routing and Remote Access (GRE-Out)",
    "Routing and Remote Access (L2TP-Out)",
    "Routing and Remote Access (PPTP-Out)"
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
