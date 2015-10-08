#!/usr/bin/env bash
# Install Atom Editor and plugins
# -------------------------------
echo "Installing Atom editor..........."$(date '+%T')
apt-get install -y libzmq3-dev python-pip python-dev >/dev/null 2>&1
pip install --upgrade pip
pip install --upgrade virtualenv
pip install ipython[notebook] >/dev/null 2>&1
wget https://github.com/atom/atom/releases/download/v1.0.19/atom-amd64.deb >/dev/null 2>&1
dpkg --install atom-amd64.deb >/dev/null 2>&1
rm atom-amd64.deb