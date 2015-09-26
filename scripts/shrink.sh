#!/usr/bin/env bash
sudo apt-get clean -y
sudo apt-get autoclean - y

# Zero free space to aid VM compression
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY

find /var/lib/apt -type f | xargs sudo rm -f
find /var/lib/doc -type f | xargs sudo rm -f

# Remove bash history
unset HISTFILE
sudo rm -f /root/.bash_history
sudo rm -f /home/vagrant/.bash_history