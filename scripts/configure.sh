#!/usr/bin/env bash
#VAGRANT_INSECURE_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"
SSH_USER=${SSH_USERNAME:-vagrant}
SSH_PASS=${SSH_PASSWORD:-vagrant}
SSH_USER_HOME=${SSH_USER_HOME:-/home/${SSH_USER}}
if ! id -u $SSH_USER >/dev/null 2>&1; then
    echo "Creating $SSH_USER user..."
    /usr/sbin/groupadd $SSH_USER
    /usr/sbin/useradd $SSH_USER -g $SSH_USER -G sudo -d $SSH_USER_HOME --create-home
    echo "${SSH_USER}:${SSH_PASS}" | chpasswd
fi
mkdir $SSH_USER_HOME/.ssh
wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
#Ensure we have the correct permissions set
chmod 0700 $SSH_USER_HOME/.ssh
chmod 0600 $SSH_USER_HOME/.ssh/authorized_keys
chown -R $SSH_USER:$SSH_USER $SSH_USER_HOME/.ssh

echo "Installing VirtualBox guest additions..."
#sudo apt-get install -y virtualbox-guest-utils virtualbox-guest-x11 >/dev/null 2>&1
#reboot

# Assuming the following packages are installed
# apt-get install -y linux-headers-$(uname -r) build-essential perl
# apt-get install -y dkms
#VBOX_VERSION=$(cat /home/${SSH_USER}/.vbox_version)
#mount -o loop /home/${SSH_USER}/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
#sh /mnt/VBoxLinuxAdditions.run
#umount /mnt
#rm /home/${SSH_USER}/VBoxGuestAdditions_$VBOX_VERSION.iso
#rm /home/${SSH_USER}/.vbox_version
#if [[ $VBOX_VERSION = "4.3.10" ]]; then
#    ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
#fi