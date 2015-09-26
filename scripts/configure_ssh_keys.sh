#!/usr/bin/env bash
sudo mkdir -p /home/vagrant/.ssh
wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
#Ensure we have the correct permissions set
sudo chmod 0700 /home/vagrant/.ssh
sudo chmod 0600 /home/vagrant/.ssh/authorized_keys
sudo chown -R vagrant /home/vagrant/.ssh