# =============================================================================
# List only currently connected USB devices
# This shows all USB-bus devices that are plugged in right now,
# including external drives, hubs, webcams, Bluetooth radios, etc.
# =============================================================================

Get-PnpDevice -PresentOnly `
    # -PresentOnly ensures we only get devices that are currently attached and recognized
  | Where-Object { $_.InstanceId -like 'USB\VID_*' } `
    # Filter on InstanceId starting with 'USB\VID_' so only USB devices are listed
  | Select-Object `
      InstanceId,   # The unique PnP device identifier (e.g. USB\VID_0781&PID_5567\...)
      FriendlyName, # Human-readable name (e.g. 'SanDisk Ultra USB Device')
      Class,        # Device class (USBSTOR, HIDClass, etc.)
      Service       # Windows service/driver handling the device (usbhub, USBSTOR, etc.)
  | Format-Table -AutoSize
    # Format the output as a clean table for easy reading
