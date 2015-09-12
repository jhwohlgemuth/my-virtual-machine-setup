#!/usr/bin/env bash

# Install TeamCity
printf "Downloading TeamCity..."
mkdir /downloads
cd /downloads
sudo wget http://download.jetbrains.com/teamcity/TeamCity-8.1.5.tar.gz >/dev/null 2>&1
printf "Extracting TeamCity..."
cd ../var
sudo tar zxvf ../downloads/TeamCity-8.1.5.tar.gz >/dev/null 2>&1
printf "Starting TeamCity..."
cd /var/TeamCity
sudo ./bin/runAll.sh start >/dev/null 2>&1
printf "Adding TeamCity as a service..."
cat <<'EOF' > /etc/init.d/teamcity
#! /bin/sh
# /etc/init.d/teamcity
#
# Carry out specific functions when asked to by the system
case "$1" in
  start)
    printf "Starting Teamcity "
    /var/TeamCity/bin/runAll.sh start
    ;;
  stop)
    printf "Stopping Teamcity"
    /var/TeamCity/bin/runAll.sh stop
    ;;
  *)
    printf "Usage: /etc/init.d/teamcity {start|stop}"
    exit 1
    ;;
esac
exit 0
EOF
printf "Adding TeamCity to startup..."
sudo chmod 755 /etc/init.d/teamcity >/dev/null 2>&1
sudo update-rc.d teamcity defaults >/dev/null 2>&1
sudo rm -rf /downloads
