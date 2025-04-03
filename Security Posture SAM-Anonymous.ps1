# Security Posture Retrieval Script

$registryPaths = @(
    @{ Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"; Name = "RestrictAnonymousSAM"; Description = "Restrict Anonymous SAM Access" },
    @{ Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"; Name = "RestrictAnonymous"; Description = "Restrict Anonymous Enumeration" },
    @{ Path = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"; Name = "RestrictNullSessAccess"; Description = "Restrict Null Session Access" },
    @{ Path = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"; Name = "NullSessionPipes"; Description = "Null Session Pipes" },
    @{ Path = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"; Name = "NullSessionShares"; Description = "Null Session Shares" },
    @{ Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"; Name = "LmCompatibilityLevel"; Description = "LAN Manager Authentication Level" }
)

Write-Host "===== SYSTEM SECURITY POSTURE CHECK =====" -ForegroundColor Cyan

foreach ($item in $registryPaths) {
    try {
        $value = Get-ItemProperty -Path $item.Path -Name $item.Name -ErrorAction Stop | Select-Object -ExpandProperty $item.Name
    } catch {
        $value = "Not Set"
    }
    
    Write-Host "$($item.Description): $value" -ForegroundColor Yellow
}

Write-Host "`n===== INTERPRETATION GUIDE =====" -ForegroundColor Green
Write-Host "🔹 RestrictAnonymousSAM = 1 → Blocks anonymous SAM enumeration"
Write-Host "🔹 RestrictAnonymous = 2 → Completely blocks anonymous enumeration (Recommended)"
Write-Host "🔹 RestrictNullSessAccess = 1 → Blocks null session access to named pipes & shares"
Write-Host "🔹 NullSessionPipes = Empty → No null session pipes allowed"
Write-Host "🔹 NullSessionShares = Empty → No null session shares allowed"
Write-Host "🔹 LmCompatibilityLevel:"
Write-Host "   0 = Send LM & NTLM responses (Weak)"
Write-Host "   1 = Use NTLM if possible"
Write-Host "   2 = Only send NTLM responses"
Write-Host "   3 = Use NTLMv2 if possible (Recommended for security)"
Write-Host "   4 = Only send NTLMv2 responses"
Write-Host "   5 = Only send NTLMv2 & refuse LM/NTLM (Strictest)"
