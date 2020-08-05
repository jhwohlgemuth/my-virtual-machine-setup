#!/usr/bin/env bash
. ./functions.sh

# Disable the release upgrader
log "Disabling the release upgrader"
sed -i.bak 's/^Prompt=.*$/Prompt=never/' /etc/update-manager/release-upgrades

log "Checking version of Ubuntu"
. /etc/lsb-release

if [[ $DISTRIB_RELEASE == 16.04 || $DISTRIB_RELEASE == 16.10 ]]; then
    log "Disabling periodic apt upgrades"
    echo 'APT::Periodic::Enable "0";' >> /etc/apt/apt.conf.d/10periodic
fi

log "Updating list of repositories"
apt-get -y update >/dev/null 2>&1

if [[ $UPDATE  =~ true || $UPDATE =~ 1 || $UPDATE =~ yes ]]; then
    log "Performing dist-upgrade (all packages and kernel)"
    apt-get -y dist-upgrade --force-yes >/dev/null 2>&1
    reboot
    sleep 60
fi
