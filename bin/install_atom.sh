#!/usr/bin/env bash
# Install Atom Editor and plugins
# -------------------------------
printf "Installing Atom editor..........."$(date '+%T')
mkdir ~/git
cd ~/git
git clone https://github.com/atom/atom
cd ~/git/atom
git fetch -p >/dev/null 2>&1
git checkout $(git describe --tags `git rev-list --tags --max-count=1`) >/dev/null 2>&1
script/build
sudo script/grunt install
echo "Installing Atom plugins..."
sudo apm install minimap file-icons