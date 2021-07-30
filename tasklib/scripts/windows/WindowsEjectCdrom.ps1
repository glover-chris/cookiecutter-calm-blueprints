# region headers
# * author:     stephane.bourdeaud@nutanix.com
# * version:    v1.0/20210504 - cita-starter version
# task_name:    EjectCdrom
# description:  ejects the cdrom (applicable when using unattend.xml to mask configuration).               
# output vars:  none
# dependencies: none
# endregion

$sh = New-Object -ComObject "Shell.Application"
write-host "$(get-date) [INFO] Ejecting cdrom" -ForegroundColor Green
try {$sh.Namespace(17).Items() | Where-Object { $_.Type -eq "CD Drive" } | foreach { $_.InvokeVerb("Eject") }}
catch {throw "$(get-date) [ERROR] Error ejecting cdrom : $($_.Exception.Message)"}
write-host "$(get-date) [SUCCESS] Successfully ejected cdrom" -ForegroundColor Green