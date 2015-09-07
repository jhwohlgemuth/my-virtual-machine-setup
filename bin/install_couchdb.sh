#!/usr/bin/env bash
printf "Installing CouchDB dependencies..."
sudo apt-get update >/dev/null 2>&1
sudo apt-get install -y curl >/dev/null 2>&1
printf "Installing CouchDB..."
sudo apt-get install -y couchdb >/dev/null 2>&1
sudo sed -i '/;port/c port = 5984' /etc/couchdb/local.ini
sudo sed -i '/;bind_address/c bind_address = 0.0.0.0' /etc/couchdb/local.ini