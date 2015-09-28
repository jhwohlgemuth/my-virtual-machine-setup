#!/usr/bin/env bash
#Atom editor build dependencies
sudo apt-get install -y libgnome-keyring-dev >/dev/null 2>&1
# Install Atom Editor and plugins
# -------------------------------
echo "Installing Atom editor..........."$(date '+%T')
mkdir ~/git
cd ~/git
git clone https://github.com/atom/atom
cd ~/git/atom
git fetch -p >/dev/null 2>&1
git checkout $(git describe --tags `git rev-list --tags --max-count=1`) >/dev/null 2>&1
script/build
sudo script/grunt install
echo "Installing Atom plugins..."
apm install minimap file-icons imdone-atom