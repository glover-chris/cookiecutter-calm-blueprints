#!/bin/bash

# region headers
# * author:     stephane.bourdeaud@nutanix.com
# * version:    v1.0/20210504 - cita-starter version
# task_name:    EjectCdrom
# description:  ejects all cdrom devices (/dev/sr*).               
# output vars:  none
# dependencies: none
# endregion

for device in /dev/sr*
do 
    sudo eject $device
    echo "Ejected ${device}"
done