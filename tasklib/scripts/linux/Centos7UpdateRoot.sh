# region headers
# * author:     stephane.bourdeaud@nutanix.com
# * version:    v1.0/20210504 - cita-starter version
# task_name:    UpdateRoot
# description:  updates root password with configured Calm credential secret.               
# output vars:  none
# dependencies: requires the root credential to be present in the blueprint.
# endregion
echo 'root:@@{root.secret}@@' | sudo chpasswd