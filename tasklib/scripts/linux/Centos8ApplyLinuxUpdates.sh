# region headers
# * author:     stephane.bourdeaud@nutanix.com
# * version:    v1.0/20210506 - cita-starter version
# task_name:    ApplyLinuxUpdates
# description:  updates centos 8 and configures automatic updates.               
# output vars:  none
# dependencies: none
# endregion

#update now
sudo dnf update -y

#configure automatic updates
sudo dnf install dnf-automatic -y
sudo sed -i "s/apply_updates = no/apply_updates = yes/g" /etc/dnf/automatic.conf
sudo sed -i "s/upgrade_type = default/upgrade_type = security/g" /etc/dnf/automatic.conf
sudo systemctl enable --now dnf-automatic.timer