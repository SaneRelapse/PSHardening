# This script hardens your Windows computer by reducing the available attack surface.
# The SSTP service (SstpSvc) handles Secure Socket Tunneling Protocol (SSTP) VPN connections,
# which provide secure remote access over HTTPS.
#
# If you disable SSTP you may not be able to use VPN.
# If you do disable SSTP you can renable it.
# Remote Access Note:
# When enabled, SSTP allows authorized remote users to connect securely to a network.
# However, if you do not use SSTP for remote access, leaving this service enabled can 
# expose your system to potential vulnerabilities that may be exploited by attackers.
# Disabling the service, therefore, prevents unauthorized remote access attempts via SSTP,
# increasing your overall security posture.

# Check for the SSTP service by its name.
$service = Get-Service -Name SstpSvc -ErrorAction SilentlyContinue

if ($null -ne $service) {
    Write-Output "SstpSvc service found."
    
    # If the service is running, stop it to prevent it from being exploited.
    if ($service.Status -eq "Running") {
        Write-Output "Stopping SstpSvc service..."
        Stop-Service -Name SstpSvc -Force -ErrorAction Stop
        Write-Output "SstpSvc service stopped."
    }
    else {
        Write-Output "SstpSvc service is not running."
    }

    # Disable the service so it cannot be started automatically, reducing potential exposure.
    Write-Output "Disabling SstpSvc service..."
    Set-Service -Name SstpSvc -StartupType Disabled
    Write-Output "SstpSvc service has been disabled."
}
else {
    Write-Output "SstpSvc service not found on this system."
}
