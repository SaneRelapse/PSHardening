<#
.SYNOPSIS
    List loaded modules of Notepad using Win32 APIs in PowerShell.
.DESCRIPTION
    1. Declares P/Invoke for EnumProcessModules and GetModuleFileNameEx.
    2. Opens a handle to notepad.exe.
    3. Enumerates and displays each loaded module.
    Requires Administrator privileges.
#>

# 1) P/Invoke definitions for PsAPI
$psApiTypeDef = @"
using System;
using System.Runtime.InteropServices;
using System.Text;

public static class PsApi {
    [DllImport("psapi.dll", SetLastError = true)]
    public static extern bool EnumProcessModules(
        IntPtr hProcess,
        [Out] IntPtr[] lphModule,
        uint cb,
        out uint lpcbNeeded
    );

    [DllImport("psapi.dll", CharSet = CharSet.Auto, SetLastError = true)]
    public static extern uint GetModuleFileNameEx(
        IntPtr hProcess,
        IntPtr hModule,
        [Out] StringBuilder lpFilename,
        uint nSize
    );
}
"@

# Always add or ignore existing type
try {
    Add-Type -TypeDefinition $psApiTypeDef -Language CSharp -ErrorAction Stop
} catch [System.Exception] {
    # ignore if type already exists
}

# 2) Define access rights constants
$PROCESS_QUERY_INFORMATION = 0x0400
$PROCESS_VM_READ           = 0x0010

# 3) Get notepad process and handle
$proc = Get-Process -Name notepad -ErrorAction Stop
$hProcess = $proc.Handle

# 4) Enumerate modules
Write-Host "Loaded modules in notepad.exe:`n" -ForegroundColor Green
$maxModules = 1024
$modules = New-Object IntPtr[] $maxModules
[uint32]$bytesNeeded = 0

if ([PsApi]::EnumProcessModules($hProcess, $modules, $maxModules * [IntPtr]::Size, [ref]$bytesNeeded)) {
    $moduleCount = [int]($bytesNeeded / [IntPtr]::Size)
    for ($i = 0; $i -lt $moduleCount; $i++) {
        $sb = New-Object Text.StringBuilder 260
        [PsApi]::GetModuleFileNameEx($hProcess, $modules[$i], $sb, $sb.Capacity) | Out-Null
        Write-Host "[$i] $($sb.ToString())"
    }
} else {
    $err = [Runtime.InteropServices.Marshal]::GetLastWin32Error()
    Write-Error "EnumProcessModules failed with error code $err"
}
