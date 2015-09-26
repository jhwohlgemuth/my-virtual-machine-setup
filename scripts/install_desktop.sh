#!/usr/bin/env bash
START=$(date '+%T')
# Install desktop environment
# ---------------------------
echo "Installing desktop..............."$START
sudo apt-get install -y ubuntu-desktop gnome-session-fallback >/dev/null 2>&1

# Install Google Chrome
# ---------------------
echo "Installing Google Chrome........."$(date '+%T')
sudo apt-get install -y libxss1 libappindicator1 libindicator7 >/dev/null 2>&1
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb >/dev/null 2>&1
sudo apt-get install -f >/dev/null 2>&1
sudo dpkg -i google-chrome*.deb >/dev/null 2>&1
sudo rm google-chrome-stable_current_amd64.deb

echo "Start: "$START
echo "End:   "$(date '+%T')