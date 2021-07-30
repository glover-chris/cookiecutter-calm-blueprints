# region headers
# * author:     kazi.ahmed@nutanix.com
# * version:    v1.0/20210530- cita-starter version
# task_name:    InstallAnsible
# description:  installs ansible and prereq             
# output vars:  none
# dependencies: epel-release
# endregion
sudo yum install epel-release -y
sudo yum install ansible -y
7