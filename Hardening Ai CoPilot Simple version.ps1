#Harden Copliot simple version
Set-ProcessMitigation -Name copilot.exe -Enable DEP,ForceRelocateImages,HighEntropy,SEHOP,CFG,TerminateOnError,EnableExportAddressFilter,EnableImportAddressFilter,EnableRopStackPivot,EnableRopCallerCheck
