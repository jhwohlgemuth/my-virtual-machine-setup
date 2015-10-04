#!/usr/bin/env bash
# Install Atom Editor and plugins
# -------------------------------
echo "Installing Atom editor..........."$(date '+%T')
apt-get update
apt-get install -y python-pip
pip install ipython[notebook]
wget https://github.com/atom/atom/releases/download/v1.1.0-beta.0/atom-amd64.deb
sudo dpkg -i atom-amd64.deb
sudo rm atom-amd64.deb

echo "Installing Atom plugins..."
apm install minimap file-icons atom-beautify imdone-atom