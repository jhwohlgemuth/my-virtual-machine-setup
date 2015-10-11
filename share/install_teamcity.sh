#!/usr/bin/env bash

# Install TeamCity
echo "Downloading TeamCity..."
mkdir /downloads
cd /downloads
wget http://download.jetbrains.com/teamcity/TeamCity-8.1.5.tar.gz >/dev/null 2>&1
echo "Extracting TeamCity..."
cd ../var
tar zxvf ../downloads/TeamCity-8.1.5.tar.gz >/dev/null 2>&1
echo "Starting TeamCity..."
cd /var/TeamCity
./bin/runAll.sh start >/dev/null 2>&1
echo "Adding TeamCity as a service..."
cat <<'EOF' > /etc/init.d/teamcity
#! /bin/sh
# /etc/init.d/teamcity
#
# Carry out specific functions when asked to by the system
case "$1" in
  start)
    echo "Starting Teamcity "
    /var/TeamCity/bin/runAll.sh start
    ;;
  stop)
    echo "Stopping Teamcity"
    /var/TeamCity/bin/runAll.sh stop
    ;;
  *)
    echo "Usage: /etc/init.d/teamcity {start|stop}"
    exit 1
    ;;
esac
exit 0
EOF
echo "Adding TeamCity to startup..."
chmod 755 /etc/init.d/teamcity >/dev/null 2>&1
update-rc.d teamcity defaults >/dev/null 2>&1
rm -rf /downloads
