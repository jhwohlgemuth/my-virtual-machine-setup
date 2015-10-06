#!/usr/bin/env bash
# Install Atom Editor and plugins
# -------------------------------
echo "Installing Atom editor..........."$(date '+%T')
sudo apt-get install -y libzmq3-dev python-pip >/dev/null 2>&1
sudo pip install ipython[notebook] >/dev/null 2>&1
wget https://github.com/atom/atom/releases/download/v1.1.0-beta.0/atom-amd64.deb >/dev/null 2>&1
dpkg -i atom-amd64.deb >/dev/null 2>&1
rm atom-amd64.deb