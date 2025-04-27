# Warning: THIS DOES NOT STOP BASHBUNNY MALICIOUS USB
﻿# =============================================================================
# Anti-Persistence & Forensic Tweaks
# Purpose: Prevent malicious USB media from auto-executing code while
#          preserving normal USB functionality (keyboards, mice, storage)
# =============================================================================

# Disable AutoRun/AutoPlay on all drive types
#   - NoDriveTypeAutoRun = 0xFF means "do not autorun on any drive"
#   - Stops Windows from automatically reading and executing any autorun.inf
#   - Prevents “juice jacking” and malware on USB sticks from launching
#   - DOES NOT disable USB ports or drivers—HID devices (keyboard/mouse)
#     and storage devices still mount and function normally.
#
# Hardening effect:
#   • Blocks one of the most common USB attack vectors (autorun malware)
#   • Forces user intervention before any code on removable media can run
#   • Reduces risk of drive-by infections from untrusted USB devices
#
# User impact:
#   • No autoplay pop-ups when you insert a USB stick or external HDD/SSD
#   • You still see the drive in Explorer and can manually browse/copy files
#   • USB peripherals (keyboard, mouse, game controllers) continue to work
# =============================================================================

Set-ItemProperty `
    -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" `
    -Name "NoDriveTypeAutoRun" `
    -Value 0xFF `
    -Type DWord

# =============================================================================
# Note:
# If you *do* want to completely block USB storage (but retain HID devices),
# you can disable the USBSTOR driver instead:
# 
#   Set-ItemProperty `
#       -Path "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR" `
#       -Name "Start" `
#       -Value 4 `
#       -Type DWord
# 
# That stops Windows from loading the USB storage driver, so sticks/HDDs
# won’t mount—yet your keyboard and mouse (which use different drivers)
# remain fully functional.
# =============================================================================
