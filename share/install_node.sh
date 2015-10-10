#!/usr/bin/env bash
sudo apt-get update
# Install Node and npm
# --------------------
echo "Installing node.js and npm......."$(date '+%T')
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash