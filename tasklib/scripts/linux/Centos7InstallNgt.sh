# region headers
# * author:     stephane.bourdeaud@nutanix.com
# * version:    v1.0/20210504 - cita-starter version
# task_name:    InstallNgt
# description:  mounts the ngt iso (assuming /dev/sr0) and installs
#               Nutanix Guest Tools.               
# output vars:  none
# dependencies: none
# endregion
sleep 15
sudo mount /dev/sr0 /media
sudo /media/installer/linux/install_ngt.py
