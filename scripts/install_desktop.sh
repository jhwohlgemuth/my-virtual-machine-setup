#!/bin/bash
TIMEZONE=Central
SSH_USER=${SSH_USERNAME:-vagrant}
USERNAME=${SSH_USER}
LIGHTDM_CONFIG=/etc/lightdm/lightdm.conf
GDM_CUSTOM_CONFIG=/etc/gdm/custom.conf
echo "Installing desktop................"$(TZ=":US/$TIMEZONE" date +%T)
apt-get install --no-install-recommends -y ubuntu-desktop >/dev/null 2>&1
apt-get install -y gnome-terminal overlay-scrollbar gnome-session-fallback >/dev/null 2>&1
apt-get install -y firefox chromium-browser indicator-multiload >/dev/null 2>&1
apt-get install -y figlet toilet >/dev/null 2>&1
mkdir -p $(dirname ${GDM_CUSTOM_CONFIG})
echo "[daemon]" >> $GDM_CUSTOM_CONFIG
echo "# Enabling automatic login" >> $GDM_CUSTOM_CONFIG
echo "AutomaticLoginEnable=True" >> $GDM_CUSTOM_CONFIG
echo "AutomaticLoginEnable=${USERNAME}" >> $GDM_CUSTOM_CONFIG
echo "==> Configuring lightdm autologin"
echo "[SeatDefaults]" >> $LIGHTDM_CONFIG
echo "autologin-user=${USERNAME}" >> $LIGHTDM_CONFIG
