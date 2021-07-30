# region headers
# * author:     stephane.bourdeaud@nutanix.com
# * version:    v1.0/20210504 - cita-starter version
# task_name:    InitDataDisk
# description:  turns disk 1 into a GPT ntfs partition nad mounts it with the next
#               available logical drive letter.               
# output vars:  none
# dependencies: none
# endregion

write-host "$(get-date) [INFO] Bringing data disk online" -ForegroundColor Green
try {Get-Disk | Where-Object IsOffline –Eq $True | Set-Disk –IsOffline $False}
catch {throw "$(get-date) [ERROR] Error bringing data disk online: $($_.Exception.Message)"}

write-host "$(get-date) [INFO] Initializing data disk" -ForegroundColor Green
try {Initialize-Disk -Number 1 -PartitionStyle GPT}
catch {throw "$(get-date) [ERROR] Error initializing data disk : $($_.Exception.Message)"}

write-host "$(get-date) [INFO] Creating new partition on data disk" -ForegroundColor Green
try {New-Partition -DiskNumber 1 -UseMaximumSize -AssignDriveLetter}
catch {throw "$(get-date) [ERROR] Error creating new partition on data disk : $($_.Exception.Message)"}

write-host "$(get-date) [INFO] Formatting data disk" -ForegroundColor Green
try {Format-Volume -DriveLetter ((Get-Partition -DiskNumber 1 -PartitionNumber 2).DriveLetter)}
catch {throw "$(get-date) [ERROR] Error formatting data disk : $($_.Exception.Message)"}
