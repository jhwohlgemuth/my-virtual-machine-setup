#!/usr/bin/env bash
. ./functions.sh

SSH_USER=${SSH_USERNAME:-vagrant}
USERNAME=${SSH_USER}

log "Checking version of Ubuntu"
. /etc/lsb-release

log "Installing ubuntu-desktop"
apt-get install -y --no-install-recommends ubuntu-desktop >/dev/null 2>&1
apt-get install -y gnome-terminal overlay-scrollbar gnome-session-flashback >/dev/null 2>&1

LIGHTDM_CONFIG=/etc/lightdm/lightdm.conf
GDM_CUSTOM_CONFIG=/etc/gdm/custom.conf

mkdir -p $(dirname ${GDM_CUSTOM_CONFIG})
echo "[daemon]" >> $GDM_CUSTOM_CONFIG
echo "# Enabling automatic login" >> $GDM_CUSTOM_CONFIG
echo "AutomaticLoginEnable=True" >> $GDM_CUSTOM_CONFIG
echo "AutomaticLoginEnable=${USERNAME}" >> $GDM_CUSTOM_CONFIG

log "Configuring lightdm autologin"
echo "[SeatDefaults]" >> $LIGHTDM_CONFIG
echo "autologin-user=${USERNAME}" >> $LIGHTDM_CONFIG

if [ -d /etc/xdg/autostart/ ]; then
    log "Disabling screen blanking"
    NODPMS_CONFIG=/etc/xdg/autostart/nodpms.desktop
    echo "[Desktop Entry]" >> $NODPMS_CONFIG
    echo "Type=Application" >> $NODPMS_CONFIG
    echo "Exec=xset -dpms s off s noblank s 0 0 s noexpose" >> $NODPMS_CONFIG
    echo "Hidden=false" >> $NODPMS_CONFIG
    echo "NoDisplay=false" >> $NODPMS_CONFIG
    echo "X-GNOME-Autostart-enabled=true" >> $NODPMS_CONFIG
    echo "Name[en_US]=nodpms" >> $NODPMS_CONFIG
    echo "Name=nodpms" >> $NODPMS_CONFIG
    echo "Comment[en_US]=" >> $NODPMS_CONFIG
    echo "Comment=" >> $NODPMS_CONFIG
fi
