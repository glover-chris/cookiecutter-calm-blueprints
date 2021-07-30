# region headers
# posh-api-template v20190604 / stephane.bourdeaud@nutanix.com
#* author:       stephane.bourdeaud@nutanix.com
#* version:      11/14/2019
#  task_name:    JoinDomain
#  description:  Joins the specified Active Directory domain
# endregion

#region capture Calm variables
$ad_username = "@@{active_directory.username}@@"
$ad_username_secret = "@@{active_directory.secret}@@"
$ad_domain = "@@{domain}@@"
#endregion

#converting password to something we can use
$adminpassword = ConvertTo-SecureString -asPlainText -Force -String "$ad_username_secret"
#creating the credentials object based on the Calm variables
$credential = New-Object System.Management.Automation.PSCredential($ad_username,$adminpassword)
#joining the domain
write-host "$(get-date) [INFO] Joining Active Directory domain $($ad_domain)" -ForegroundColor Green
try {$result = add-computer -domainname $ad_domain -Credential ($credential) -Force -Options JoinWithNewName,AccountCreate -PassThru -ErrorAction Stop -Verbose}
catch {throw "Could not join Active Directory domain : $($_.Exception.Message)"}
write-host "$(get-date) [SUCCESS] Successfully joined Active Directory domain $($ad_domain)" -ForegroundColor Green