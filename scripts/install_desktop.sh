#!/usr/bin/env bash
# Inpsired by https://github.com/boxcutter/ubuntu
START=$(date '+%T')
# Install desktop environment
# ---------------------------
echo "Installing desktop..............."$START
sudo apt-get install -y ubuntu-desktop gnome-session-fallback >/dev/null 2>&1

USERNAME=${SSH_USERNAME:-vagrant}
LIGHTDM_CONFIG=/etc/lightdm/lightdm.conf
GDM_CUSTOM_CONFIG=/etc/gdm/custom.conf

mkdir -p $(dirname ${GDM_CUSTOM_CONFIG})
echo "[daemon]" >> $GDM_CUSTOM_CONFIG
echo "# Enabling automatic login" >> $GDM_CUSTOM_CONFIG
echo "AutomaticLoginEnable=True" >> $GDM_CUSTOM_CONFIG
echo "AutomaticLoginEnable=${USERNAME}" >> $GDM_CUSTOM_CONFIG

echo "==> Configuring lightdm autologin"
#if [ -f $LIGHTDM_CONFIG ]; then
    echo "[SeatDefaults]" >> $LIGHTDM_CONFIG
    echo "autologin-user=${USERNAME}" >> $LIGHTDM_CONFIG
#fi

# Install Google Chrome
# ---------------------
echo "Installing Google Chrome........."$(date '+%T')
sudo apt-get install -y libxss1 libappindicator1 libindicator7 >/dev/null 2>&1
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb >/dev/null 2>&1
sudo apt-get install -f >/dev/null 2>&1
sudo dpkg -i google-chrome*.deb >/dev/null 2>&1
sudo rm google-chrome-stable_current_amd64.deb

echo "Start: "$START
echo "End:   "$(date '+%T')