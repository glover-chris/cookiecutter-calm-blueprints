# region headers
# * author:     stephane.bourdeaud@nutanix.com
# * version:    v1.0/20210504 - cita-starter version
# task_name:    Restart
# description:  runs computer restart as a job (so Calm does not error out).               
# output vars:  none
# dependencies: none
# endregion
Start-Job -ScriptBlock {Restart-Computer -Force}
exit 0