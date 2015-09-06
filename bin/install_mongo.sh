#!/usr/bin/env bash

printf "Installing MongoDB..."
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 >/dev/null 2>&1
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list >/dev/null 2>&1
sudo apt-get update >/dev/null 2>&1
sudo apt-get install -y mongodb-org >/dev/null 2>&1
# Change config file to allow external connections
sudo sed -i '/bind_ip/c # bind_ip = 127.0.0.1' /etc/mongod.conf >/dev/null 2>&1
# Change default port to 8000
#sudo sed -i '/#port/c port = 8000' /etc/mongod.conf >/dev/null 2>&1
sudo service mongod restart >/dev/null 2>&1
