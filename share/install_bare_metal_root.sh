#!/usr/bin/env bash
. functions.sh
apt-get install openssh-server ntp nfs-common build-essential -y
apt-get install curl perl dkms git fakeroot tree zsh -y
install_atom
install_docker
