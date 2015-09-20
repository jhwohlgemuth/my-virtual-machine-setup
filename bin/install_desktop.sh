#!/usr/bin/env bash
START=$(date '+%T')
# Install desktop environment
# ---------------------------
printf "Installing desktop..."$START
sudo apt-get install -y ubuntu-desktop gnome-session-fallback >/dev/null 2>&1

# Personalize terminal
# --------------------
printf "Patching agnoster theme fonts..."$(date '+%T')
wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf >/dev/null 2>&1
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf >/dev/null 2>&1
sudo mkdir ~/.fonts/
sudo mkdir -p ~/.config/fontconfig/conf.d/
sudo mv PowerlineSymbols.otf ~/.fonts/
fc-cache -vf ~/.fonts/
sudo mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

# Install Google Chrome
# ---------------------
printf "Installing Google Chrome..."$(date '+%T')
sudo apt-get install -y libxss1 libappindicator1 libindicator7 >/dev/null 2>&1
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb >/dev/null 2>&1
sudo apt-get install -f >/dev/null 2>&1
sudo dpkg -i google-chrome*.deb

# Install Atom Editor
# -------------------
printf "Installing Atom dependencies..."$(date '+%T')
sudo apt-get install -y libgnome-keyring-dev >/dev/null 2>&1
printf "Installing Atom editor..."$(date '+%T')
mkdir ~/git
cd ~/git
git clone https://github.com/atom/atom
cd ~/git/atom
git fetch -p >/dev/null 2>&1
git checkout $(git describe --tags `git rev-list --tags --max-count=1`) >/dev/null 2>&1
sudo script/build >/dev/null 2>&1
sudo script/grunt install >/dev/null 2>&1

# Miscellaneous Items
# -------------------
printf "Installing miscellaneous items..."$(date '+%T')
sudo apt-get install -y figlet toilet >/dev/null 2>&1

printf "Start: "$START
printf "End:   "$(date '+%T')