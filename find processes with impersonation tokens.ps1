Get-WmiObject Win32_Process | ForEach-Object {
    $proc = $_
    $owner = $proc.GetOwner()
    $token = $proc.GetOwnerSid()
    [PSCustomObject]@{
        ProcessName = $proc.Name
        ProcessID = $proc.ProcessId
        UserName = "$($owner.Domain)\$($owner.User)"
        UserSID = $token
    }
} | Format-Table -AutoSize