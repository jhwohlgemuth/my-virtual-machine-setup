#!/usr/bin/env bash
# Install Java (JRE/JDK)
# ----------------------
echo "Installing JRE and JDK..........."$(date '+%T')
apt-get install -y default-jre default-jdk >/dev/null 2>&1
# Install Node and npm
# --------------------
echo "Preparing to install node........"$(date '+%T')
curl -sL https://deb.nodesource.com/setup | sudo bash - >/dev/null 2>&1
echo "Installing node.js and npm......."$(date '+%T')
apt-get install -y nodejs >/dev/null 2>&1
echo "Installing global node modules..."$(date '+%T')
npm install phantomjs casperjs yo bower grunt-cli -g >/dev/null 2>&1
# Install Google Chrome
# ---------------------
echo "Installing Google Chrome........."
apt-get install -y libxss1 libappindicator1 libindicator7 >/dev/null 2>&1
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb >/dev/null 2>&1
apt-get install -f >/dev/null 2>&1
dpkg -i google-chrome*.deb >/dev/null 2>&1
rm google-chrome-stable_current_amd64.deb