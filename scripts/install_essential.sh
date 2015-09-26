#!/usr/bin/env bash
START=$(date '+%T')
echo "Updating before installing......."$START
sudo apt-get update -y -qq >/dev/null 2>&1
sudo apt-get upgrade -y -qq >/dev/null 2>&1
sudo apt-get install -f >/dev/null 2>&1
echo "Installing essential software...."$(date '+%T')
sudo apt-get install -y linux-headers-$(uname -r) virtualbox-guest-x11 nfs-common >/dev/null 2>&1
sudo apt-get install -y build-essential make curl wget tmux git dkms fakeroot >/dev/null 2>&1
#Atom editor build dependencies
sudo apt-get install -y libgnome-keyring-dev >/dev/null 2>&1

# Install Java (JRE/JDK)
echo "Installing JRE and JDK..........."$(date '+%T')
sudo apt-get install -y default-jre default-jdk >/dev/null 2>&1

# Install Node and npm
echo "Preparing to install node........"$(date '+%T')
curl -sL https://deb.nodesource.com/setup | sudo bash - >/dev/null 2>&1
echo "Installing node.js and npm......."$(date '+%T')
sudo apt-get install -y nodejs >/dev/null 2>&1
echo "Installing global node modules..."$(date '+%T')
sudo npm install phantomjs casperjs yo bower grunt-cli -g >/dev/null 2>&1

echo "Start: "$START
echo "End:   "$(date '+%T')