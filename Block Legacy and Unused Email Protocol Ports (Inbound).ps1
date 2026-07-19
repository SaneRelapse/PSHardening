# =====================================================================
# Block Legacy and Unused Email Protocol Ports (Inbound)
# =====================================================================
# Purpose:
#   • Reduce exposure to unsolicited inbound traffic
#   • Block legacy mail protocols commonly abused in scans or probes
#   • Harden systems that do not host mail services
# =====================================================================

$rules = @(
    @{ Name = "Block POP3 Port 110";  Port = 110 },
    @{ Name = "Block POP3 Secure Port 995"; Port = 995 },
    @{ Name = "Block IMAP Port 143"; Port = 143 },
    @{ Name = "Block IMAP Secure Port 993"; Port = 993 },
    @{ Name = "Block SMTP Port 25"; Port = 25 },
    @{ Name = "Block SMTP Submission Port 587"; Port = 587 },
    @{ Name = "Block SMTP Secure Port 465"; Port = 465 }
)

foreach ($rule in $rules) {

    # Remove existing rule if present (idempotent behavior)
    $existing = Get-NetFirewallRule -DisplayName $rule.Name -ErrorAction SilentlyContinue
    if ($existing) {
        Remove-NetFirewallRule -DisplayName $rule.Name
    }

    # Create the inbound block rule
    New-NetFirewallRule -DisplayName $rule.Name `
                        -Direction Inbound `
                        -Protocol TCP `
                        -LocalPort $rule.Port `
                        -Action Block
}
