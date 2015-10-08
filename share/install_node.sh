#!/usr/bin/env bash
sudo apt-get update
# Install Node and npm
# --------------------
echo "Installing node.js and npm......."$(date '+%T')
echo 'export PATH=$HOME/local/bin:$PATH' >> ~/.bashrc
. ~/.bashrc
mkdir ~/local
mkdir ~/node-latest-install
cd ~/node-latest-install
curl http://nodejs.org/dist/node-latest.tar.gz | tar xz --strip-components=1
./configure --prefix=~/local
make install >/dev/null 2>&1
wget https://www.npmjs.org/install.sh >/dev/null 2>&1
sh install.sh