#!/usr/bin/env bash
SSH_USER=${SSH_USERNAME:-vagrant}
# Install Atom Editor and plugins
# -------------------------------
echo "Installing Atom editor..........."$(date '+%T')
cd $HOME
sudo -u $SSH_USER wget https://github.com/atom/atom/releases/download/v1.0.19/atom-amd64.deb >/dev/null 2>&1
dpkg --install atom-amd64.deb >/dev/null 2>&1
rm atom-amd64.deb
apm install minimap file-icons sublime-block-comment