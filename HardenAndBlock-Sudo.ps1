<#
.SYNOPSIS
  Fully harden sudo.exe and prevent it from being run via DisallowRun (system-wide and user-specific).

.DESCRIPTION
  1. Enables all mitigations on sudo.exe.
  2. Enables and populates DisallowRun entries in:
     - HKLM\...\Policies\Explorer\DisallowRun
     - HKCU\...\Policies\Explorer\DisallowRun

.NOTES
  Must be run as Administrator for HKLM changes.
#>

function Ensure-DisallowRun-Entry {
    param (
        [string]$RegistryPath,
        [string]$ExeName
    )

    # Create key if missing
    if (-not (Test-Path $RegistryPath)) {
        Write-Host "Creating registry path: $RegistryPath"
        New-Item -Path $RegistryPath -Force | Out-Null
    }

    # Read existing numbered entries
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

# --- 1. Check for admin ---
If (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
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

# --- 3. Apply all exploit mitigations to sudo.exe ---
$mitigations = @(
    'DEP','SEHOP','BottomUpASLR','ForceRelocateImages','HighEntropyASLR',
    'StrictHandle','EnableRopCallerCheck','EnableRopStackPivot',
    'EnableImportAddressFilter','BlockLowLabelImageLoads','BlockRemoteImageLoads',
    'PreferSystem32','DisableNonSystemFonts','EnforceModuleDependencySigning',
    'StrictCFG','SuppressExportAddressFilter','AllowThreadOptOut',
    'DisableExtensionPoints','EmulateAtlThunks','RequireSignedOnly'
)

Write-Host "`nApplying all exploit mitigations to sudo.exe..."
Set-ProcessMitigation -Name 'sudo.exe' -Enable $mitigations
Write-Host "`nMitigation state:"
Get-ProcessMitigation -Name 'sudo.exe' | Format-List

# --- 4. Block in HKLM ---
$regPathHKLM = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$disallowHKLM = Join-Path $regPathHKLM "DisallowRun"

Write-Host "`nEnabling DisallowRun policy in HKLM..."
New-ItemProperty -Path $regPathHKLM -Name "DisallowRun" -Value 1 -PropertyType DWord -Force | Out-Null
Ensure-DisallowRun-Entry -RegistryPath $disallowHKLM -ExeName "sudo.exe"

# --- 5. Block in HKCU ---
$regPathHKCU = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$disallowHKCU = Join-Path $regPathHKCU "DisallowRun"

Write-Host "`nEnabling DisallowRun policy in HKCU..."
New-ItemProperty -Path $regPathHKCU -Name "DisallowRun" -Value 1 -PropertyType DWord -Force | Out-Null
Ensure-DisallowRun-Entry -RegistryPath $disallowHKCU -ExeName "sudo.exe"

# --- Done ---
Write-Host "`nAll actions complete. sudo.exe is now hardened and blocked from being executed via Explorer."
