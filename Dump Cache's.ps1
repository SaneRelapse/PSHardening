Write-Host "=== DNS Cache ===" -ForegroundColor Cyan
try {
    ipconfig /displaydns
} catch {
    Write-Warning "Failed to dump DNS cache"
}

Write-Host "`n=== ARP Cache ===" -ForegroundColor Cyan
try {
    arp -a
} catch {
    Write-Warning "Failed to dump ARP cache"
}

Write-Host "`n=== NetBIOS Cache ===" -ForegroundColor Cyan
try {
    nbtstat -c
} catch {
    Write-Warning "Failed to dump NetBIOS cache"
}

Write-Host "`n=== Prefetch Files (Listing) ===" -ForegroundColor Cyan
$prefetchDir = "$env:SystemRoot\Prefetch"
if (Test-Path $prefetchDir) {
    Get-ChildItem "$prefetchDir\*.pf" | Select-Object Name,LastWriteTime,Length | Format-Table -AutoSize
} else {
    Write-Warning "Prefetch folder not found"
}

Write-Host "`n=== Jump Lists (Listing) ===" -ForegroundColor Cyan
$jumpListDir = "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations"
if (Test-Path $jumpListDir) {
    Get-ChildItem $jumpListDir | Select-Object Name,LastWriteTime,Length | Format-Table -AutoSize
} else {
    Write-Warning "Jump Lists folder not found"
}

Write-Host "`n=== Recent Items (Listing) ===" -ForegroundColor Cyan
$recentDir = "$env:APPDATA\Microsoft\Windows\Recent"
if (Test-Path $recentDir) {
    Get-ChildItem $recentDir | Select-Object Name,LastWriteTime,Length | Format-Table -AutoSize
} else {
    Write-Warning "Recent Items folder not found"
}

Write-Host "`n=== UserAssist (Raw Registry Data) ===" -ForegroundColor Cyan
try {
    Get-ChildItem -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist" -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Host "Key: $($_.PSPath)" -ForegroundColor Yellow
        Get-ItemProperty -Path $_.PSPath | Format-List
        Write-Host ""
    }
} catch {
    Write-Warning "Failed to read UserAssist keys"
}

Write-Host "`n=== SRUM Database Info ===" -ForegroundColor Cyan
$srumDB = "$env:SystemRoot\System32\sru\SRUDB.dat"
if (Test-Path $srumDB) {
    Write-Host "SRUM DB found at $srumDB (parsing requires external tools)" -ForegroundColor Green
} else {
    Write-Warning "SRUM DB not found"
}

Write-Host "`n=== WER Logs (Listing) ===" -ForegroundColor Cyan
$werDir = "$env:ProgramData\Microsoft\Windows\WER"
if (Test-Path $werDir) {
    Get-ChildItem $werDir -Recurse | Select-Object FullName,LastWriteTime,Length | Format-Table -AutoSize
} else {
    Write-Warning "WER logs folder not found"
}

Write-Host "`n=== Thumbnail Cache Files (Listing) ===" -ForegroundColor Cyan
$thumbDir = "$env:LOCALAPPDATA\Microsoft\Windows\Explorer"
if (Test-Path $thumbDir) {
    Get-ChildItem -Path $thumbDir -Filter "thumbcache_*.db" | Select-Object Name,LastWriteTime,Length | Format-Table -AutoSize
} else {
    Write-Warning "Thumbnail cache folder not found"
}
