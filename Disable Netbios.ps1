# NetBIOS was originally designed for legacy systems to support file and printer sharing over a local area network (LAN). However, it has become a target for a variety of cyberattacks. Attackers often exploit vulnerabilities in NetBIOS to gain unauthorized access to systems or gather sensitive information. By disabling NetBIOS, you reduce the number of potential entry points for attackers, particularly when dealing with legacy protocols that are no longer necessary in modern networks.
# 
# 2. Prevents Information Disclosure
# NetBIOS can expose sensitive network information, such as the computer name, workgroup/domain name, and shared resources. This information can be leveraged by attackers for reconnaissance, potentially leading to more severe attacks like SMB (Server Message Block) exploitation. Disabling NetBIOS mitigates this risk by limiting the amount of information about your network that is available to unauthorized users.
# 
# 3. Prevents Lateral Movement in the Network
# Attackers often use NetBIOS to perform "NetBIOS name service" (NBNS) queries or "SMB enumeration" attacks to discover vulnerable machines on the network. Disabling NetBIOS helps to prevent attackers from easily finding devices or servers within the internal network, thus hindering lateral movement after an initial breach.
# 
# 4. Mitigates NetBIOS Spoofing and Poisoning
# NetBIOS name service is susceptible to attacks like NetBIOS name spoofing and NetBIOS name poisoning, where attackers may impersonate other machines on the network. For example, a malicious actor could poison the local NetBIOS name cache to redirect traffic or impersonate trusted services, leading to man-in-the-middle attacks, data interception, or unauthorized access. By disabling NetBIOS, you eliminate this risk.
# 
# 5. Reduces SMB Exploits
# SMB (Server Message Block) is a protocol that NetBIOS uses for file and printer sharing. Known vulnerabilities in SMB (e.g., EternalBlue, SMBv1 vulnerabilities) have been exploited in some of the largest ransomware attacks (e.g., WannaCry, NotPetya). While NetBIOS is not directly tied to SMB, it interacts with the protocol, making disabling NetBIOS a useful step in mitigating SMB-related vulnerabilities.
# 
# 6. Modern Networks Don’t Need NetBIOS
# In modern networks, especially those based on Active Directory, NetBIOS is no longer necessary for basic network communication. DNS (Domain Name System) has largely replaced NetBIOS for name resolution, especially in large networks. Disabling NetBIOS simplifies network management and reduces the complexity of maintaining outdated services that are no longer required for typical operations.
# 
# 7. Compliance and Security Best Practices
# Many security frameworks and compliance regulations, such as CIS Benchmarks and NIST, recommend disabling or limiting the use of legacy protocols like NetBIOS to improve overall security posture. Disabling unnecessary services aligns with security best practices, ensuring your network remains as secure and streamlined as possible.
# 
# 8. Prevents Windows Name Resolution Attacks
# Since NetBIOS is used for local name resolution (e.g., converting computer names into IP addresses), disabling it prevents attackers from exploiting the NetBIOS name resolution process to carry out attacks, such as SMB relay attacks or NetBIOS enumeration, where the attacker can retrieve a list of network shares and services without valid authentication.
# Netbios can be tricky to disable this uses a multi pronged approach to disable, some systems give me problems others disable right away.

# Get all network adapter interfaces
$interfaces = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }

# Loop through each network interface and modify the registry to disable NetBIOS
foreach ($interface in $interfaces) {
    $interfaceIndex = $interface.InterfaceIndex
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$interfaceIndex"

    # Set the registry value to disable NetBIOS
    Set-ItemProperty -Path $regPath -Name "NetbiosOptions" -Value 2
}

Write-Host "NetBIOS has been disabled on all active network interfaces."
# Disable NetBIOS over TCP/IP for all network interfaces using PowerShell
Get-NetAdapter | ForEach-Object {
    Set-NetAdapterAdvancedProperty -Name $_.Name -DisplayName "NetBIOS" -DisplayValue "Disabled"
}
netsh interface ipv4 set subinterface "Ethernet" netbios=disabled
New-ItemProperty `
  -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Dhcp\Parameters\Options\DhcpNetbiosOptions" `
  -Name OptionId `
  -PropertyType DWord `
  -Value 4 `
  -Force
