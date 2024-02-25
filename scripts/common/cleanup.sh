#!/usr/bin/env bash
# shellcheck disable=SC1091
. ./functions.sh

# Make sure udev does not block our network - http://6.ptmc.org/?p=164
log "Cleaning up udev rules"
rm -rf /dev/.udev/
rm -f /lib/udev/rules.d/75-persistent-net-generator.rules

log "Cleaning up leftover dhcp leases"
# Ubuntu 10.04
if [ -d "/var/lib/dhcp3" ]; then
    rm /var/lib/dhcp3/*
fi
# Ubuntu 12.04 & 14.04
if [ -d "/var/lib/dhcp" ]; then
    rm /var/lib/dhcp/*
fi

# Add delay to prevent "vagrant reload" from failing
echo "pre-up sleep 2" >> /etc/network/interfaces

log "Cleaning up tmp"
rm -rf /tmp/*

log "Cleaning up apt cache"
apt-get -y autoremove --purge >/dev/null 2>&1
apt-get -y clean >/dev/null 2>&1
apt-get -y autoclean >/dev/null 2>&1

log "Cleaning up installed packages"
dpkg --get-selections | grep -v deinstall >/dev/null 2>&1

log "Removing bash history"
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/vagrant/.bash_history

log "Cleaning up log files"
find /var/log -type f | while read -r f; do echo -ne '' > "$f"; done;

log "Clearing last login information"
true >/var/log/lastlog
true >/var/log/wtmp
true >/var/log/btmp

log "Whiteout root"
count=$(df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}')
(( count-- ))
dd if=/dev/zero of=/tmp/whitespace bs=1024 count="$count" >/dev/null 2>&1
rm /tmp/whitespace

log "Whiteout /boot"
count=$(df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}')
(( count-- ))
dd if=/dev/zero of=/boot/whitespace bs=1024 count="$count" >/dev/null 2>&1
rm /boot/whitespace

log "Zeroing out free space"
dd if=/dev/zero of=/EMPTY bs=1M >/dev/null 2>&1
rm -f /EMPTY

# Make sure we wait until all the data is written to disk, otherwise
# Packer might quite too early before the large files are deleted
sync >/dev/null 2>&1
