#! /bin/sh

apt-get update
apt-get install --no-install-recommends -y wget
wget https://github.com/apptainer/apptainer/releases/download/v1.2.4/apptainer_1.2.4_amd64.deb
apt install -y ./apptainer_1.2.4_amd64.deb
rm ./apptainer_1.2.4_amd64.deb