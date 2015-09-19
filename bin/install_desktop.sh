#!/usr/bin/env bash

# Install desktop environment
printf "Installing desktop software..."
sudo apt-get update >/dev/null 2>&1
sudo apt-get install -y xinit
sudo apt-get update -y virtualbox-guest-utils >/dev/null 2>&1
sudo apt-get install -y ubuntu-desktop >/dev/null 2>&1
sudo apt-get install -y gnome-session-flashback >/dev/null 2>&1
printf "Installing Oh-My-Zsh..."
sudo apt-get install -y zsh >/dev/null 2>&1
sudo chsh -s $(which zsh)
printf "Patching agnoster theme fonts..."
wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf >/dev/null 2>&1
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf >/dev/null 2>&1
mv PowerlineSymbols.otf ~/.fonts/
fc-cache -vf ~/.fonts/
mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

# Miscellaneous Items
sudo apt-get install -y figlet >/dev/null 2>&1
sudo apt-get install -y toilet >/dev/null 2>&1
