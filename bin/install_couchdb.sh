#!/usr/bin/env bash
printf "Installing CouchDB dependencies..."
sudo apt-get update >/dev/null 2>&1
sudo apt-get install -y curl >/dev/null 2>&1
printf "Installing CouchDB..."
sudo apt-get install -y couchdb >/dev/null 2>&1
sudo sed -i '/;port/c port = 5984' /etc/couchdb/local.ini
sudo sed -i '/;bind_address/c bind_address = 0.0.0.0' /etc/couchdb/local.ini

lineNumber=$(($(echo $(grep -n '\[httpd\]' /etc/couchdb/local.ini) | awk -F':' '{print $1}')+1))
sudo sed -i "$lineNumber"'secure_rewrites = false' /etc/couchdb/local.ini

lineNumber=$(($(echo $(grep -n '\[couch_httpd_auth\]' /etc/couchdb/local.ini) | awk -F':' '{print $1}')+1))
sudo sed -i "$lineNumber"'secure_rewrites = false' /etc/couchdb/local.ini

function update_ini(){
  local str=$1
  local path=$2
  lineNumber=$(($(echo $(grep -n '\[httpd\]' /etc/couchdb/local.ini) | awk -F':' '{print $1}')+1))
  sed -i "$lineNumber""$str" $path
}