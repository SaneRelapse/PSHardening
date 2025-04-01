# Ensure script is running as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Error "Run this script as an Administrator."
    exit 1
}

# Function to log messages
function Log-Info($Message) {
    Write-Host "[INFO] $Message" -ForegroundColor Green
}

function Log-Error($Message) {
    Write-Error "[ERROR] $Message"
}

#--- Step 1: Get and disable SMB1
try {
    Log-Info "Checking SMB1 configuration..."
    $smb1 = Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol
    $smb1 | Format-Table FeatureName, State -AutoSize

    if ($smb1.State -ne 'Disabled') {
        Log-Info "Disabling SMB1..."
        Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart -ErrorAction Stop
        Log-Info "SMB1 has been disabled. A system restart may be required."
    }
    else {
        Log-Info "SMB1 is already disabled."
    }
}
catch {
    Log-Error "Error while checking/disabling SMB1: $_"
}

#--- Step 2: Get and disable SMB2 on the server
try {
    Log-Info "Getting SMB Server configuration for SMB2..."
    $smbConfig = Get-SmbServerConfiguration | Select-Object -Property EnableSMB2Protocol
    $smbConfig | Format-Table -AutoSize

    if ($smbConfig.EnableSMB2Protocol) {
        Log-Info "Disabling SMB2..."
        Set-SmbServerConfiguration -EnableSMB2Protocol $false -Force -ErrorAction Stop
        Log-Info "SMB2 has been disabled on the server."
    }
    else {
        Log-Info "SMB2 is already disabled on the server."
    }
}
catch {
    Log-Error "Error while checking/disabling SMB2: $_"
}

#--- Step 3: Block SMB (port 445) via Windows Firewall
try {
    Log-Info "Creating firewall rules to block SMB traffic on port 445..."

    # Block inbound and outbound TCP and UDP on port 445 using a combined approach for clarity
    $ports = 445
    $protocols = @("TCP", "UDP")
    foreach ($protocol in $protocols) {
        foreach ($direction in @("Inbound", "Outbound")) {
            $ruleName = "Block SMB/NTB - $protocol $direction Port 445"
            # Remove existing rule if exists
            if (Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue) {
                Remove-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
            }
            New-NetFirewallRule -DisplayName $ruleName -Direction $direction -Protocol $protocol -LocalPort $ports -Action Block -ErrorAction Stop
            Log-Info "Created firewall rule: $ruleName"
        }
    }
}
catch {
    Log-Error "Error while configuring firewall rules: $_"
}

Log-Info "Script execution complete. Review the output for status and any required system restart."
