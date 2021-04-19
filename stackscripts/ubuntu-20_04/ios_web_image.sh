#!/bin/bash
#<UDF name="username" Label="Limited User Username"/>
#<UDF name="password" Label="Limited User Password"/>
#<UDF name="gituser" Label="Git User Name"/>
#<UDF name="gitemail" Label="Git User Email"/>
#<UDF name="githubuser" Label="Github User Name"/>
#<UDF name="githubrepo" Label="Github Repo"/>

# Update system
echo Updating the system
apt update && apt upgrade -y

# Installing python environment
apt install -y python3-pip python3-venv python3-dev build-essential gfortran sqlite3

# Install relevant image libraries

apt install -y libffi libheif-dev libde265-dev

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
echo Updating kernel parameters to disable IPV6
sed -i -e '/GRUB_CMDLINE_LINUX/ s/"$/ ipv6.disable=1"/' /etc/default/grub
update-grub

# Add a limited rights user
useradd -m -p $PASSWORD -s /bin/bash $USERNAME

# Copy SSH key to limited rights user
rsync --archive --chown=$USERNAME:$USERNAME ~/.ssh /home/$USERNAME

# Git config
cat > /home/$USERNAME/.gitconfig <<EOM
[user]
  name = $GITUSER
  email = $GITEMAIL
EOM
chown $USERNAME:$USERNAME /home/$USERNAME/.gitconfig

# Clone git repo
# Testing location
curl -L https://github.com/$GITHUBUSER/$GITHUBREPO/tarball/master | tar zx

# Reboot
shutdown -r now