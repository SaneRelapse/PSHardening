<#
.SYNOPSIS
    Detect suspicious PowerShell invocations across all running processes.
.DESCRIPTION
    Scans each process for PowerShell commands using encoded or obfuscated arguments
    (e.g., -EncodedCommand, -e, -WindowStyle Hidden, or custom obfuscation patterns).
    Outputs PID, process name, and full command line for any matches.
    Requires Administrator privileges to access all process command lines.
#>

Write-Host "Scanning for suspicious PowerShell invocations..." -ForegroundColor Cyan

# Retrieve all PowerShell processes with their command lines
Get-CimInstance Win32_Process -Filter "Name LIKE 'powershell.exe' OR Name LIKE 'pwsh.exe'" |
Select-Object ProcessId, ProcessName, CommandLine |
Where-Object {
    # Define detection patterns
    $patterns = @(
        '-EncodedCommand',
        '-e\b',
        '-WindowStyle\s*Hidden',
        '-NoProfile',
        '\\sv\s*BvI',
        '\\Invoke-Expression',
        '\\IEX\b'
    )
    # Check if any pattern appears in the command line
    foreach ($pattern in $patterns) {
        if ($_.CommandLine -match $pattern) { return $true }
    }
    return $false
} |
ForEach-Object {
    Write-Host "Suspicious PS invocation (PID $($_.ProcessId) - $($_.ProcessName)):`n    $($_.CommandLine)`n" -ForegroundColor Yellow
}
