<#
.SYNOPSIS
    Audit-DefenderExclusions – Retrieves Windows Defender exclusions to help you harden your system.

.DESCRIPTION
    This script pulls Defender’s current exclusion settings and outputs them with commentary.
    Use it to detect overly broad exclusions, remove unsafe entries, and enforce your security policy.

.EXAMPLE
    PS> .\Audit-DefenderExclusions.ps1
#>

function Audit-DefenderExclusions {
    [CmdletBinding()]
    param(
        # Name of this audit run
        [string]$AuditName = "ExclusionAudit_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    )

    Write-Host "===== Audit: $AuditName =====" -ForegroundColor Cyan

    # Step 1: Retrieve Defender preferences
    # 🔍 Helps you see if any critical folders or files are excluded—gaps in scan coverage.
    $prefs = Get-MpPreference

    # Step 2: Show excluded file paths
    Write-Host "`n[1] Excluded Paths:" -ForegroundColor Green
    if ($prefs.ExclusionPath.Count) {
        $prefs.ExclusionPath | ForEach-Object {
            # ⚠️ If this path is system-critical or user data, reconsider exclusion.
            Write-Host " - $_"
        }
    } else {
        Write-Host " (none)"
    }

    # Step 3: Show excluded file extensions
    Write-Host "`n[2] Excluded Extensions:" -ForegroundColor Green
    if ($prefs.ExclusionExtension.Count) {
        $prefs.ExclusionExtension | ForEach-Object {
            # ⚠️ Wildcard extensions (e.g. *.exe) are high-risk—scanner blind spots.
            Write-Host " - $_"
        }
    } else {
        Write-Host " (none)"
    }

    # Step 4: Show excluded processes
    Write-Host "`n[3] Excluded Processes:" -ForegroundColor Green
    if ($prefs.ExclusionProcess.Count) {
        $prefs.ExclusionProcess | ForEach-Object {
            # ⚠️ Excluding critical system processes (e.g. powershell.exe) can allow malware to hide.
            Write-Host " - $_"
        }
    } else {
        Write-Host " (none)"
    }

    Write-Host "`n===== End of $AuditName =====" -ForegroundColor Cyan

    # Hardening Recommendations
    @"
HARDENING GUIDANCE:
 • Review each exclusion—ensure only absolutely necessary items are excluded.
 • Remove broad paths (e.g., C:\) or wildcard extensions (*.exe, *.dll).
 • Avoid excluding system or scripting hosts (powershell.exe, wscript.exe).
 • Document any allowed exclusions in your security policy.
 • Run this audit regularly (e.g., via Scheduled Task) to detect unauthorized changes.
"@ | Write-Host
}

# Execute the audit
Audit-DefenderExclusions

