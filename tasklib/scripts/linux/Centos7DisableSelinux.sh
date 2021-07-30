#!/bin/bash

# region headers
# * author:     stephane.bourdeaud@nutanix.com
# * version:    v1.0/20210504 - cita-starter version
# task_name:    DisableSelinux
# description:  disables enforcement of selinux policy.               
# output vars:  none
# dependencies: none
# endregion

sudo hostnamectl set-hostname --static @@{vm_name}@@
echo "@@{address}@@  @@{vm_name}@@.@@{domain}@@ @@{vm_name}@@" | sudo tee -a /etc/hosts

#sudo /bin/systemctl stop firewalld || true
#sudo /bin/systemctl disable firewalld || true

sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
sudo setenforce 0



