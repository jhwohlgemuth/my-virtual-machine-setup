#! /bin/sh

apt-get update && apt-get install --no-install-recommends -y \
    coq \
    coqide
apt-get clean
rm -rf /var/lib/apt/lists/*
apt-get clean
rm -rf /var/lib/apt/lists/*