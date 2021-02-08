#!/bin/bash
#<UDF name="username" Label="Limited User Username"/>
#<UDF name="password" Label="Limited User Password"/>

'''
Initial setup up Ubuntu 20.04 VPS.

The end result is an up to date Ubuntu server with a User Defined Field defined non-administrative rights user.

Required: Public SSH key to be used to connect saved in Linode account

Note: after this script has been used only connection by SSH key is allowed.

Using script implements

 - upgrading packages
 -hardening SSH
  -denying root login
  -denying password authentication
  -only allowing SSH connection over IPV4
 -simple firewall
  -allow incoming SSH port 22
  -deny all other incoming
  -allow all outgoing
  -IPV4 only
-deactivates IPV6
-add non-admin user
-copies SSH key that was chosen on create linode interface over to user
'''

# Update system
echo Updating the system
apt update && apt upgrade -y

# Disable password, root and IPV6 connections over SSH
echo Disabling password, root and IPV6 connections over SSH...
sed -i -e "s/PermitRootLogin yes/PermitRootLogin no/" /etc/ssh/sshd_config
sed -i -e "s/#PermitRootLogin no/PermitRootLogin no/" /etc/ssh/sshd_config
sed -i -e "s/PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config
sed -i -e "s/#PasswordAuthentication no/PasswordAuthentication no/" /etc/ssh/sshd_config
sed -i -e "s/AddressFamily any/AddressFamily inet/" /etc/ssh/sshd_config
sed -i -e "s/#AddressFamily any/AddressFamily inet/" /etc/ssh/sshd_config
sed -i -e "s/#AddressFamily inet/AddressFamily inet/" /etc/ssh/sshd_config
sed -i -e "s/AddressFamily inet6/AddressFamily inet/" /etc/ssh/sshd_config
sed -i -e "s/#AddressFamily inet6/AddressFamily inet/" /etc/ssh/sshd_config

# Simple SSH only UFW firewall
echo Writing simple SSH only UFW rules
sed -i -e "s/IPV6=yes/IPV6=no/" /etc/default/ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow OpenSSH
ufw disable
ufw --force enable

# Set kernel parameters to deactivate IPV6
# Note: Normal to edit sysctl and make change persistent to achieve this
#       At present a bug in Ubuntu 20.04/linode/both? prevents this change
#       From being persistent. Thus kernel parameters are set in grub config
echo Updating kernel parameters to disable IPV6
sed -i -e '/GRUB_CMDLINE_LINUX/ s/"$/ ipv6.disable=1"/' /etc/default/grub
update-grub

# Add a limited rights user
useradd -m -p $PASSWORD -s /bin/bash $USERNAME

# Copy SSH key to limited rights user
rsync --archive --chown=$USERNAME:$USERNAME ~/.ssh /home/$USERNAME

# Reboot
shutdown -r now