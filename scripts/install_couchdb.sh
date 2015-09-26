#!/usr/bin/env bash
echo "Installing CouchDB dependencies..."
sudo apt-get update >/dev/null 2>&1
sudo apt-get install -y curl >/dev/null 2>&1
echo "Installing CouchDB..."
sudo apt-get install -y couchdb >/dev/null 2>&1
echo "Configuring /etc/couchdb/local.ini ..."
sudo sed -i '/;port/c port = 5984' /etc/couchdb/local.ini
sudo sed -i '/;bind_address/c bind_address = 0.0.0.0' /etc/couchdb/local.ini
lineNumber=$(($(echo $(grep -n '\[couch_httpd_auth\]' /etc/couchdb/local.ini) | awk -F':' '{print $1}')+1))
sudo sed -i "$lineNumber"'ipublic_fields = appdotnet, avatar, avatarMedium, avatarLarge, date, email, fields, freenode, fullname, github, homepage, name, roles, twitter, type, _id, _rev' /etc/couchdb/local.ini
sudo sed -i "$(($lineNumber+1))"'iusers_db_public = true' /etc/couchdb/local.ini
lineNumber=$(($(echo $(grep -n '\[httpd\]' /etc/couchdb/local.ini) | awk -F':' '{print $1}')+1))
sudo sed -i "$lineNumber"'isecure_rewrites = false' /etc/couchdb/local.ini
lineNumber=$(($(echo $(grep -n '\[couchdb\]' /etc/couchdb/local.ini) | awk -F':' '{print $1}')+1))
sudo sed -i "$lineNumber"'idelayed_commits = false' /etc/couchdb/local.ini