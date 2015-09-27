#!/usr/bin/env bash
# Disable the release upgrader
echo "Disabling the release upgrader..."
sed -i.bak 's/^Prompt=.*$/Prompt=never/' /etc/update-manager/release-upgrades
echo "Updating before installing......."
sudo apt-get update -y -qq >/dev/null 2>&1
echo "Performing dist-upgrade (all packages and kernel)..." >/dev/null 2>&1
apt-get -y dist-upgrade --force-yes >/dev/null 2>&1
reboot
sleep 60