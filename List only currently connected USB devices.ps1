# =============================================================================
# List only currently connected USB devices
# This shows all USB-bus devices that are plugged in right now,
# including external drives, hubs, webcams, Bluetooth radios, etc.
Get-PnpDevice -PresentOnly `
| Where-Object { $_.InstanceId -like 'USB\VID_*' } `
| Select-Object InstanceId, FriendlyName, Class, Service `
| Format-Table -AutoSize
