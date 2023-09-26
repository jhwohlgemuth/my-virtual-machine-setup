#!/usr/bin/env bash
# shellcheck disable=SC1091
. ./functions.sh

log "Recording box generation date"
date > /etc/vagrant_box_build_date

log "Customizing message of the day"
MOTD_FILE=/etc/motd
PLATFORM_RELEASE=$(lsb_release -sd)
PLATFORM_MSG=$(printf '%s' "$PLATFORM_RELEASE")
BUILT_MSG="$(printf 'built %s' $(date +%Y-%m-%d))"
printf '%0.1s' "-"{1..64} > ${MOTD_FILE}
{
    printf '\n'
    printf '%2s%-30s%30s\n' " " "${PLATFORM_MSG}" "${BUILT_MSG}"
    printf '%0.1s' "-"{1..64}
    printf '\n'
} >> ${MOTD_FILE}
