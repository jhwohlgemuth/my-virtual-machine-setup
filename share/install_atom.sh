#!/usr/bin/env bash
# Install Atom Editor and plugins
# -------------------------------
echo "Installing Atom editor..........."$(date '+%T')
wget https://github.com/atom/atom/releases/download/v1.0.19/atom-amd64.deb >/dev/null 2>&1
dpkg --install atom-amd64.deb >/dev/null 2>&1
rm atom-amd64.deb
apm install minimap file-icons sublime-block-comment