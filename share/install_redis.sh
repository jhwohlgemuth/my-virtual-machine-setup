#!/usr/bin/env bash
echo "Installing redis server..."
apt-get install -y redis-server >/dev/null 2>&1
# Configure redis-server to accept remote connections
sed -i 's/bind 127.0.0.1/bind 0.0.0.0/' /etc/redis/redis.conf
service redis-server restart >/dev/null 2>&1