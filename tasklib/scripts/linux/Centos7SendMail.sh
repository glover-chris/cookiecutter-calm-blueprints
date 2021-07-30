#!/bin/bash

# region headers
# * author:     stephane.bourdeaud@nutanix.com
# * version:    v1.0/20210504 - cita-starter version
# task_name:    SendMail
# description:  sends an email notification to the Calm user including vm details.               
# output vars:  none
# dependencies: none
# endregion

sudo sed -i 's/MaxSessions 1/MaxSessions 10/' /etc/ssh/sshd_config
sudo sed -i 's/#Subsystem/Subsystem/' /etc/ssh/sshd_config
sudo /bin/systemctl restart sshd.service
From=@@{email_sender}@@
To=@@{requester_email}@@
Subject="Your VM  @@{vm_name}@@ is ready!"
Body="<html><body><p>Hello @@{vm_requester_name}@@,</p><p>You had requested a Linux VM, we have successfully deployed your instance and you can start using it using the following informations:
<br>Service type: Linux instance<br>Machine ip address: @@{address}@@
<br>Instance name: @@{vm_name}@@
<br>Login: @@{linux.username}@@
<br>Password: none: using your private ssh key<br>
For security reasons, please do not share your password or key with anyone.<br><br>Regards,<br><p>The Cloud Team</p></body></html>"
echo "
import email.message
import smtplib
server = smtplib.SMTP("\"@@{smtp_server}@@\"", 25)
msg = email.message.Message()
msg['Subject'] = "\"${Subject}\""
msg['From'] = "\"${From}\""
msg['To'] = "\"${To}\""
html_content="\"${Body}\""
msg.add_header('Content-Type', 'text/html')
msg.set_payload(html_content)
server.sendmail(msg['From'], [msg['To']], msg.as_string())" | tee  ~/send_notification
echo "Sending user notification"
python ~/send_notification
rm ~/send_notification