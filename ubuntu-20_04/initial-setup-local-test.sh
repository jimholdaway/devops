#/bin/bash

# Update system
#echo Updating the system...
#apt update && apt upgrade -y

# Disable password, root and IPV6 connections over SSH
echo Disabling password, root and IPV6 connections over SSH...
sed -i -e "s/PermitRootLogin yes/PermitRootLogin no/" sshd_config
sed -i -e "s/#PermitRootLogin no/PermitRootLogin no/" sshd_config
sed -i -e "s/PasswordAuthentication yes/PasswordAuthentication no/" sshd_config
sed -i -e "s/#PasswordAuthentication no/PasswordAuthentication no/" sshd_config
sed -i -e "s/AddressFamily any/AddressFamily inet/" sshd_config
sed -i -e "s/#AddressFamily any/AddressFamily inet/" sshd_config
sed -i -e "s/#AddressFamily inet/AddressFamily inet/" sshd_config
sed -i -e "s/AddressFamily inet6/AddressFamily inet/" sshd_config
sed -i -e "s/#AddressFamily inet6/AddressFamily inet/" sshd_config

# Simple SSH only UFW firewall
echo Writing simple SSH only UFW (firewall) rules...
sed -i -e "s/IPV6=yes/IPV6=no/" ufw
#ufw default deny incoming
#ufw default allow outgoing
#ufw allow OpenSSH
#ufw disable
#ufw --force enable

# Set kernel parameters to deactivate IPV6
# Note: Normal to edit sysctl and make chnage persistent to achieve this
#       At present a bug in Ubuntu 20.04/linode/both? prevents this change
#       From being persistent. Thus kernel parameters are set in grub config
echo Updating kernel parameters to disable IPV6...
sed '/GRUB_CMDLINE_LINUX_DEFAULT/ s/"$/ ipv6.disable=1"/' grub
sed '/GRUB_CMDLINE_LINUX/ s/"$/ ipv6.disable=1"/' grub
