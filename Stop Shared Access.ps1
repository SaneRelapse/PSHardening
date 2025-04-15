# Stop the SharedAccess service immediately
Stop-Service -Name SharedAccess -Force

# Prevent the service from starting at boot by setting its startup type to Disabled
Set-Service -Name SharedAccess -StartupType Disabled
