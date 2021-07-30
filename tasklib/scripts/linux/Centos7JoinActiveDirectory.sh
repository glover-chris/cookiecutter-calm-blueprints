# region headers
# * author:     kazi.ahmed@nutanix.com
# * version:    v1.0/20210530- cita-starter version
# task_name:    JoinActiveDirectory
# description:  joins this computer in Windows based Active Directory           
# output vars:  none
# dependencies: "sssd" "realmd" "oddjob" "oddjob-mkhomedir" "adcli" "samba-common" "samba-common-tools" "krb5-workstation" "openldap-clients" "policycoreutils-python"
# endregion
## declare an array variable
declare -a arr=("sssd" "realmd" "oddjob" "oddjob-mkhomedir" "adcli" "samba-common" "samba-common-tools" "krb5-workstation" "openldap-clients" "policycoreutils-python")
domainUser="@@{domainCred.username}@@"
domaiinUserPasswd="@@{domainCred.secret}@@"
domainName="@@{domainName}@@"

## now loop through the above array
for i in "${arr[@]}"
do
   if ! rpm -qa | grep -qw $i; then
    sudo yum install $i -y
   fi
done
#restart realm service
sudo systemctl restart realmd
# join now using realm
echo $domaiinUserPasswd | sudo realm join -U $domainUser $domainName
#display available domain
sudo realm list
#verify domain users information
id $domainUser@$domainName
#change behavior by modifying following lines in /etc/sssd/sssd.conf 
#use_fully_qualified_names = False
#fallback_homedir = /home/%u
#apply changes
#sudo systemctl restart sssd