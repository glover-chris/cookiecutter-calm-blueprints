#!/bin/bash
set -ex

# region headers
# * author:     dusty.lane@nutanix.com
# * version:    v1.2/20210511
# task_name:    ResizeRootVolume
# description:  Extend root volume (LVM)               
# output vars:  none
# dependencies: none
# endregion

# if the deistribution doesn't have lvm install, let's install it.
sudo yum install lvm2 -y

# let's see if we need to resize a partition, getting the
# partition information using the 'lsblk' command.
FREESPACE="$(sudo parted /dev/sda print free | grep Free | grep GB | awk '{print $3}' | awk -F"." '{print $1}')"
if [[ $FREESPACE -lt 2 ]]; then
    echo 'additional partition space not found'
    exit 0
fi

# the root volume should have been grown already using the 
# escript-prism-resize-CPU-MEM-DISK.py. Step 2 - add space to the lvm partition
sudo growpart /dev/sda 2

# Resize the partition
sudo pvresize /dev/sda2

# get the name of the root partition \ file system
VG="$(df -h | grep -i root | awk -F"/" '{print $4}' | awk '{print $1}')"
FS="$(echo $VG | awk -F"-" '{print $1}')"

# add the space to the logical volume
sudo lvextend -l +100%FREE /dev/mapper/$VG

# grow the root file system
sudo xfs_growfs /dev/$FS/root