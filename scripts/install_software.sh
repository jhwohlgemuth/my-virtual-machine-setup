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
# Miscellaneous Items
# -------------------
echo "Installing miscellaneous items..."$(date '+%T')
apt-get install -y figlet toilet >/dev/null 2>&1