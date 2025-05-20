<#
.SYNOPSIS
  Fully harden wsl.exe and prevent it from being run via DisallowRun (system-wide and user-specific).

.DESCRIPTION
  1. Enables all known exploit mitigations for wsl.exe.
  2. Enables and populates DisallowRun entries in:
     - HKLM\...\Policies\Explorer\DisallowRun
     - HKCU\...\Policies\Explorer\DisallowRun

.NOTES
  Must be run as Administrator for HKLM changes.

────────────────────────────────────────────────────────────────────────────
🛡️ HOW IT HARDENS THE SYSTEM

► Exploit Mitigations
   Enforces strong memory and execution controls on wsl.exe:

   - DEP: Prevents code execution in non-executable memory regions.
   - ASLR: Randomizes memory layout, making ROP attacks unreliable.
   - SEHOP and CFG: Prevent structured exception handling and function call corruption.
   - BlockRemoteImageLoads and others: Stop malicious DLL injection and code loading.
   - RequireSignedOnly: Disallows execution of unsigned code in that process.

► Registry DisallowRun Block
   - HKLM-level: Prevents all users from running wsl.exe via Explorer or cmd.exe if shell policies are enforced.
   - HKCU-level: Applies same restriction to current user.
   - This neutralizes wsl.exe from being executed easily from standard shell environments,
     blocking lazy exploitation, script kids, or insiders.

🚨 WHY BLOCK wsl.exe?

WSL (Windows Subsystem for Linux) gives near-native access to a Linux shell.

If abused, it can:
   - Bypass endpoint protection.
   - Spawn backdoors.
   - Escalate privileges.
   - Touch file systems Windows can't normally access.

If your environment doesn’t need Linux shells: disable or neutralize WSL.
────────────────────────────────────────────────────────────────────────────
#>

function Ensure-DisallowRun-Entry {
    param (
        [string]$RegistryPath,
        [string]$ExeName
    )

    if (-not (Test-Path $RegistryPath)) {
        Write-Host "Creating registry path: $RegistryPath"
        New-Item -Path $RegistryPath -Force | Out-Null
    }

    $key     = Get-Item -Path ("Registry::" + $RegistryPath)
    $numbers = $key.Property | Where-Object { $_ -match '^\d+$' }
    $entries = $numbers | ForEach-Object { $key.GetValue($_) }

    if ($entries -contains $ExeName) {
        Write-Host "[$RegistryPath] $ExeName already listed. Skipping..."
    } else {
        $nextIndex = ([int[]]($numbers | ForEach-Object {[int]$_}) | Measure-Object -Maximum).Maximum + 1
        if (-not $nextIndex) { $nextIndex = 1 }
        Write-Host "Adding $ExeName as entry $nextIndex to [$RegistryPath]..."
        New-ItemProperty -Path $RegistryPath -Name "$nextIndex" -Value $ExeName -PropertyType String | Out-Null
    }
}

# --- 1. Ensure admin privileges ---
If (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as Administrator."
    Exit 1
}

# --- 2. Import ProcessMitigations ---
Try {
    Import-Module ProcessMitigations -ErrorAction Stop
} Catch {
    Write-Error "Failed to load ProcessMitigations module: $_"
    Exit 1
}

# --- 3. Apply mitigations to wsl.exe ---
$mitigations = @(
    'DEP','SEHOP','BottomUpASLR','ForceRelocateImages','HighEntropyASLR',
    'StrictHandle','EnableRopCallerCheck','EnableRopStackPivot',
    'EnableImportAddressFilter','BlockLowLabelImageLoads','BlockRemoteImageLoads',
    'PreferSystem32','DisableNonSystemFonts','EnforceModuleDependencySigning',
    'StrictCFG','SuppressExportAddressFilter','AllowThreadOptOut',
    'DisableExtensionPoints','EmulateAtlThunks','RequireSignedOnly'
)

Write-Host "`nApplying all exploit mitigations to wsl.exe..."
Set-ProcessMitigation -Name 'wsl.exe' -Enable $mitigations
Write-Host "`nMitigation state:"
Get-ProcessMitigation -Name 'wsl.exe' | Format-List

# --- 4. Block via HKLM ---
$regPathHKLM = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$disallowHKLM = Join-Path $regPathHKLM "DisallowRun"

Write-Host "`nEnabling DisallowRun in HKLM..."
New-ItemProperty -Path $regPathHKLM -Name "DisallowRun" -Value 1 -PropertyType DWord -Force | Out-Null
Ensure-DisallowRun-Entry -RegistryPath $disallowHKLM -ExeName "wsl.exe"

# --- 5. Block via HKCU ---
$regPathHKCU = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$disallowHKCU = Join-Path $regPathHKCU "DisallowRun"

Write-Host "`nEnabling DisallowRun in HKCU..."
New-ItemProperty -Path $regPathHKCU -Name "DisallowRun" -Value 1 -PropertyType DWord -Force | Out-Null
Ensure-DisallowRun-Entry -RegistryPath $disallowHKCU -ExeName "wsl.exe"

Write-Host "`nAll actions complete. wsl.exe is now hardened and blocked from Explorer and shell invocation."
