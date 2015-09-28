#!/usr/bin/env bash
echo "Installing build-essential package..."
sudo apt-get install -y build-essential >/dev/null 2>&1
echo "Installing redis server..."
sudo apt-get install -y redis-server >/dev/null 2>&1
# Configure redis-server to accept remote connections
sudo sed -i 's/bind 127.0.0.1/bind 0.0.0.0/' /etc/redis/redis.conf
sudo service redis-server restart >/dev/null 2>&1