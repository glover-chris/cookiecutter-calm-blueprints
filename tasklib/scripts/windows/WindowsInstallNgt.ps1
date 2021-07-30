<#
.notes
##############################################################################
#          Nutanix Guest Tools Active Directory Installer Script
#          Filename            :      NTNX_NGT_Startup_Installer.ps1
#          Script Version      :      1.0.5
#          Author              :      Ed McAndrew (ed.mcandrew@nutanix.com)
##############################################################################
.prerequisites
    1. Powershell 4 or above ($psversiontable.psversion.major)
    2. Windows Vista or newer.
    3. There is a shared key exchange between the ISO/Mount process and the Nutanix Guest Tools installation process.
            a) For Nutanix Guest Tools to work properly, you MUST mount the Nutanix Guest Tools ISO to the virtual machine prior to this startup script execution.
            b) To do this, either use Prism to mount the NGT ISO, or from SSH to one of your Controller Virtual Machines (CVMs), run the following.
                $ ncli ngt mount vm-id=<vm_id>
                note: To get the <vm_id>, you can use the following command
                            $ ncli vm list | grep -B2 <part of your vm name>
                            Example; Our <vm_id> will be: 11f155b3-b003-4046-bac9-1b9f4cce7119
                                $ ncli vm list | grep -B2 emcandrew
                                Id                        : 00056eb6-a64f-650a-0000-00000000a8bb::11f155b3-b003-4046-bac9-1b9f4cce7119
                                Uuid                      : 11f155b3-b003-4046-bac9-1b9f4cce7119
                                Name                      : emcandrew-win10
                note: You can also do a mass mounting of the Nutanix Guest Tools (WARNING: THIS WILL MOUNT THE NGT ISO ON ALL VIRTUAL MACHINES):
                            To Mount:
                                $ for i in `ncli vm list | grep "Id" | grep -v Hypervisor | awk -F ":" '{print $4}'`;do ncli ngt mount vm-id=$i;done
                            To Unmount:
                                $ for i in `ncli vm list | grep "Id" | grep -v Hypervisor | awk -F ":" '{print $4}'`;do ncli ngt unmount vm-id=$i;done
                note: You can also build a master list of virtual machines, edit that list and then mount the NGT ISO based on the edited list.
                            To build the list:
                                $ ncli vm list | egrep 'Id|Name' | grep -v "Hypervisor" | awk '{$1=$2=""; print $0}' | paste -sd ' \n' > ~/ngt_iso_mount.txt
                            Once done editing with VIM (vi), save the file and run the following one-liner.  This one will parse each line of the file and mount the NGT ISO to each VM.
                                $ while IFS=" ," read b a; do echo -e "========\nMounting NGT: $a"; ncli ngt mount vm-id=$(echo $b | awk -F "::" '{print $2}'); done < ~/ngt_iso_mount.txt
                            The installation package will eject the ISO when it completes.  But if you need to manually unmount the ISO, you can use this same process but unmount instead.
                                $ while IFS=" ," read b a; do echo -e "========\nUnmounting NGT: $a"; ncli ngt unmount vm-id=$(echo $b | awk -F "::" '{print $2}'); done < ~/ngt_iso_mount.txt
.synopsis
    Determine if Nutanix Guest Tools (NGT) is installed.  If not installed, determine mount path for NGT ISO and install from that.  Basic state information written to Application Event log under eventid 1.
.usage
    Run this script from an Active Directory startup script GPO
.author
    Ed McAndrew (ed.mcandrew@nutanix.com)
.disclaimer
    This script is provided "AS IS" without any additional support of any kind.
    This script is provided "AS IS" without warranty of any kind, either expressed or implied, including but not limited to the implied warranties of merchantability and/or fitness for a particular purpose.
#>
##############################################################################
# SET VARIABLES
##############################################################################
$my_log_directory = "c:\"
##############################################################################
#///////////////////////////////////////////////////////////////////////////////////////////////////
# CHANGE NOTHING BELOW HERE!
#///////////////////////////////////////////////////////////////////////////////////////////////////
[string]$my_temperract = $erroractionpreference # set error handling preferences
[string]$erroractionpreference = "silentlycontinue" # set error handling preferences
$ntnx_cnt = 0

function write-log {
    [cmdletbinding()]
    param(
        [parameter(valuefrompipeline=$true,mandatory=$true)] [validatenotnullorempty()]
        [string] $message,
        [parameter()] [validateset("Error", "Warn", "Info")]
        [string] $level = "Info"
    )
    $eventid = 1
    $eventlogname = "Application"
    $eventsource = "Nutanix Guest Tools Installer Script"
    if (-not [diagnostics.eventlog]::sourceexists($eventsource)) { [diagnostics.eventlog]::createeventsource($eventsource, $eventlogname) }
    $log = new-object system.diagnostics.eventlog
    $log.set_log($eventlogname)
    $log.set_source($eventsource)
    switch ($level) {
        "error" { $log.writeentry($message, 'Error', $eventid) }
        "warn"  { $log.writeentry($message, 'Warning', $eventid) }
        "info"  { $log.writeentry($message, 'Information', $eventid) }
    }
}

get-wmiobject -class win32_product | % { if ($_.Name -match "nutanix") { $ntnx_cnt++ } }
if ($ntnx_cnt -ne 6) {
    $my_driveid = (get-ciminstance Win32_LogicalDisk | ?{ $_.volumename -eq "NUTANIX_TOOLS" }).deviceid
    $my_date = get-date -format 'MMddyyyy_HHmm'
    $my_files = @("Nutanix_Guest_Tools*")
    if ($my_driveid) {
        try {
            if (test-path "$($my_driveid)\setup.exe") {
                write-log -message "Starting Nutanix Guest Tools Installer..." -level info
                write-host "Starting Nutanix Guest Tools Installer..."
                $process = start-process "$($my_driveid)\setup.exe" -windowstyle Hidden -argumentlist "/quiet /norestart ACCEPTEULA=YES IGNOREALLWARNINGS=yes log $($my_log_directory)\NGT\" -passthru -wait
                if ($process.exitcode -eq 0) {
                    write-log -message "Installation Succeeded..." -level info
                    write-host "Installation Succeeded..."
                }
                else {
                    write-log -message "Installation failed, non-zero exit code..." -level warn
                    write-host "Installation failed, non-zero exit code..."
                }
            }
            else {
                    write-log -message "Installation failed, setup executable not found..." -level warn
                    wrtie-host "Installation failed, setup executable not found..."
            }
        }
        catch {
            write-log -message "Installation failed...`r`n$($_)" -level error
            write-host "Installation failed...`r`n$($_)"
        }
        new-item -itemtype directory -force -path "$($my_log_directory)\NGT" | out-null; get-childitem -recurse ($env:temp) -include ($my_files) | move-item -destination "$($my_log_directory)\NGT\" -ea silentlycontinue
    }
    else {
        write-log -message "Installation failed, ISO not mounted..." -level warn
        write-host "Installation failed, ISO not mounted..."
    }
}
else {
    write-log -message "Nutanix Guest Tools is already installed..." -level info
    write-host "Nutanix Guest Tools is already installed..."
}
$erroractionpreference = $my_temperract
exit
########