# region headers
# * author:     stephane.bourdeaud@nutanix.com
# * version:    v1.0/20210504 - cita-starter version
# task_name:    ApplyWindowsUpdates
# description:  applies all applicable Windows Updates (from WindowsUpdate) using DSC (Desired Configuration State).               
# output vars:  none
# dependencies: requires InstallDscModules
# endregion

#configure desired state
Configuration xWindowsUpdateAgent-InstallNow
{
    Import-DscResource -ModuleName 'xWindowsUpdate'

    xWindowsUpdateAgent 'InstallSecurityAndImportant'
    {
        IsSingleInstance = 'Yes'
        UpdateNow        = $true
        Category         = @('Security','Important') #{ Security | Important | Optional }
        Source           = 'WindowsUpdate' #{ MicrosoftUpdate | WindowsUpdate | WSUS }
        Notifications    = 'Disabled' #{ Disabled | ScheduledInstallation }
    }
}

#build configuration mof file
write-host "$(get-date) [INFO] Building desired state configuration file for Windows Update" -ForegroundColor Green
xWindowsUpdateAgent-InstallNow

#apply desired state
write-host "$(get-date) [INFO] Apply Windows Update desired state configuration and install updates now" -ForegroundColor Green
try {Start-DscConfiguration -Path .\xWindowsUpdateAgent-InstallNow -Wait -Force -ErrorAction Stop -Verbose}
catch {throw "$(get-date) [ERROR] Error applying desired state configuration : $($_.Exception.Message)"}
write-host "$(get-date) [SUCCESS] Successfully applied desired state configuration. Please reboot the computer." -ForegroundColor Green