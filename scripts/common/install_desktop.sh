#!/usr/bin/env bash
# shellcheck disable=SC1091
. ./functions.sh

SSH_USER=${SSH_USERNAME:-vagrant}
USERNAME=${SSH_USER}

log "Checking version of Ubuntu"
# shellcheck disable=SC1091
. /etc/lsb-release

log "Installing desktop"
apt-get install -y --no-install-recommends ubuntu-desktop >/dev/null 2>&1
log "Installing terminal and flashback"
apt-get install -y gnome-terminal overlay-scrollbar gnome-session-flashback >/dev/null 2>&1
log "Installing useful applications"
apt-get install -y firefox chromium-browser ubuntu-restricted-addons htop indicator-multiload xclip tree >/dev/null 2>&1
apt-get install -y figlet toilet >/dev/null 2>&1

LIGHTDM_CONFIG=/etc/lightdm/lightdm.conf
GDM_CUSTOM_CONFIG=/etc/gdm/custom.conf

mkdir -p $(dirname "${GDM_CUSTOM_CONFIG}")
{
    echo "[daemon]"
    echo "# Enabling automatic login"
    echo "AutomaticLoginEnable=True"
    echo "AutomaticLoginEnable=${USERNAME}"
} >> $GDM_CUSTOM_CONFIG

log "Configuring lightdm autologin"
echo "[SeatDefaults]" >> $LIGHTDM_CONFIG
echo "autologin-user=${USERNAME}" >> $LIGHTDM_CONFIG

if [ -d /etc/xdg/autostart/ ]; then
    log "Disabling screen blanking"
    NODPMS_CONFIG=/etc/xdg/autostart/nodpms.desktop
    {
        echo "[Desktop Entry]"
        echo "Type=Application"
        echo "Exec=xset -dpms s off s noblank s 0 0 s noexpose"
        echo "Hidden=false"
        echo "NoDisplay=false"
        echo "X-GNOME-Autostart-enabled=true"
        echo "Name[en_US]=nodpms"
        echo "Name=nodpms"
        echo "Comment[en_US]="
        echo "Comment="
    } >> $NODPMS_CONFIG
fi
