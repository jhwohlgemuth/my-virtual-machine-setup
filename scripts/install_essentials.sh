#!/usr/bin/env bash
apt-get update
# Install Java (JRE/JDK)
# ----------------------
echo "Installing JRE and JDK..........."$(date '+%T')
apt-get install -y default-jre default-jdk >/dev/null 2>&1
# Install Node and npm
# --------------------
echo "Installing node.js and npm......."$(date '+%T')
apt-get install -y nodejs npm >/dev/null 2>&1
ln -s /usr/bin/nodejs /usr/bin/node
echo "Installing global node modules..."$(date '+%T')
npm install phantomjs casperjs yo bower grunt-cli -g >/dev/null 2>&1
# Install Atom Editor and plugins
# -------------------------------
echo "Installing Atom editor..........."$(date '+%T')
apt-get install -y libzmq3-dev python-pip
pip install ipython[notebook]
wget https://github.com/atom/atom/releases/download/v1.1.0-beta.0/atom-amd64.deb
dpkg -i atom-amd64.deb
rm atom-amd64.deb
echo "Installing Atom plugins.........."$(date '+%T')
apm install minimap file-icons atom-beautify imdone-atom hydrogen
# Install Pandoc
# --------------
apt-get install -y texlive texlive-latex-extra pandoc
# Miscellaneous Items
# -------------------
echo "Installing miscellaneous items..."$(date '+%T')
apt-get install -y figlet toilet >/dev/null 2>&1