# region headers
# * author:     stephane.bourdeaud@nutanix.com
# * version:    v1.0/20210504 - cita-starter version
# task_name:    ApplyLinuxUpdates
# description:  installs DSC modules from the PowerShell Gallery.               
# output vars:  none
# dependencies: requires internet connectivity to the PowerShell Gallery.
# endregion

#installing NuGet package provider
write-host "$(get-date) [INFO] Installing NuGet package provider..." -ForegroundColor Green
try {Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force}
catch {throw "$(get-date) [ERROR] Error installing NuGet package provider : $($_.Exception.Message)"}
write-host "$(get-date) [SUCCESS] Successfully installed NuGet package provider" -ForegroundColor Green

#trust the Windows PowerShell Gallery repository
write-host "$(get-date) [INFO] Trusting PowerShell Gallery repository..." -ForegroundColor Green
try {Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted -ErrorAction Stop}
catch {throw "$(get-date) [ERROR] Error trusting the PowerShell Gallery repository : $($_.Exception.Message)"}
write-host "$(get-date) [SUCCESS] Now trusting PowerShell Gallery repository" -ForegroundColor Green
$Error.Clear() #required as PoSH populates $error even though the cmdlet completed successfully

#install Windows Update Desired State Configuration PowerShell Module
write-host "$(get-date) [INFO] Installing the xWindowsUpdate module..." -ForegroundColor Green
try {Install-Module -Name xWindowsUpdate -ErrorAction Stop}
catch {throw "$(get-date) [ERROR] Error installing the xWindowsUpdate module : $($_.Exception.Message)"}
write-host "$(get-date) [SUCCESS] Successfully installed the xWindowsUpdate module" -ForegroundColor Green