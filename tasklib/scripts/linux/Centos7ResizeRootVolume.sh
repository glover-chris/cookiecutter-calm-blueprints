#!/bin/bash
set -ex

#comment block
: <<'END'
This script is designed to take freespace and add it to 
the root partition and volume.

Creator:  dusty.lane@nutanix.com
Version:  1.1
Date:  05/10/2021
Change\update:  Variablize the partition and root vol names.

END

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