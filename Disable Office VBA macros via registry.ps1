# =============================================================================
# Disable Office VBA macros via registry (Office 2016+)
# Hardening: Prevents unauthorized or malicious macro code from executing,
#            blocking a common malware infection vector in Excel, Word, and PowerPoint.
#            Only macros that are digitally signed by a trusted publisher will run.
# =============================================================================

Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Office\16.0\Excel\Security" `
    -Name "VBAWarnings" -Value 4 -Type DWord   # 4 = disable all except digitally signed

Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Office\16.0\Word\Security" `
    -Name "VBAWarnings" -Value 4 -Type DWord   # 4 = disable all except digitally signed

Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Office\16.0\PowerPoint\Security" `
    -Name "VBAWarnings" -Value 4 -Type DWord   # 4 = disable all except digitally signed
