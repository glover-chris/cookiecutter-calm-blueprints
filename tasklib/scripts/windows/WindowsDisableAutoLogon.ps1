# region headers
# * author:     stephane.bourdeaud@nutanix.com
# * version:    v1.0/20210504 - cita-starter version
# task_name:    DisableAutoLogon
# description:  disables autologon in case it was enabled in the vm template image.               
# output vars:  none
# dependencies: none
# endregion
write-host "$(get-date) [INFO] Disabling autologon" -ForegroundColor Green
try {Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'AutoAdminLogon' -Value 0 -ErrorAction Stop}
catch {throw "$(get-date) [ERROR] Error disabliong autologon : $($_.Exception.Message)"}
write-host "$(get-date) [SUCCESS] Successfully disabled autologon" -ForegroundColor Green