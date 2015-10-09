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
curl -sL http://nodejs.org/dist/node-latest.tar.gz | tar xz --strip-components=1
./configure --prefix=~/local >/dev/null 2>&1
make install >/dev/null 2>&1
curl -sL https://www.npmjs.org/install.sh && sh install.sh >/dev/null 2>&1