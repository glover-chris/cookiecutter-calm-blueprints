# region headers
# * author:     stephane.bourdeaud@nutanix.com
# * version:    v1.0/20210504 - cita-starter version
# task_name:    ApplyLinuxUpdates
# description:  applies updates and upgrades from default yum repo.               
# output vars:  none
# dependencies: none
# endregion

#this is required or update will fail on filesystem package
sudo umount /mnt

sudo yum update -y
sudo yum upgrade -y