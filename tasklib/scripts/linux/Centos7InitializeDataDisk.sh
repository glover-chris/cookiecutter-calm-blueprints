# region headers
# * author:     stephane.bourdeaud@nutanix.com
# * version:    v1.0/20210504 - cita-starter version
# task_name:    InitializeDataDisk
# description:  configured /dev/sdb1 as an lvm volume, formats it
#               as ext4 and mounts it in /data, also configuring
#               fstab.               
# output vars:  none
# dependencies: none
# endregion

sudo yum install -y lvm2
printf 'o\nn\np\n\n\n\nt\n8e\nw' | sudo fdisk /dev/sdb
sudo pvcreate /dev/sdb1
sudo vgcreate vg0 /dev/sdb1
sudo lvcreate -n data -l 100%FREE vg0
sudo mkfs.ext4 /dev/vg0/data
sudo mkdir /data
sudo mount /dev/vg0/data /data
echo '/dev/mapper/vg0-data /data ext4 defaults 0 0' | sudo tee -a /etc/fstab