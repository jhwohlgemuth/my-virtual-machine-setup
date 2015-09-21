#!/usr/bin/env bash
printf "Turning off screen lock..."
sudo gsettings set org.gnome.desktop.session idle-delay 0
sudo gsettings set org.gnome.desktop.screensaver lock-enabled false
sudo gsettings set org.gnome.desktop.lockdown disable-lock-screen 'true'

# Install Atom plugins
# --------------------
printf "Installing Atom plugins..."
sudo apm install minimap file-icons

# Personalize terminal
# --------------------
printf "Installing Oh-My-Zsh..."$(date '+%T')
sudo apt-get install -y zsh >/dev/null 2>&1
sudo chsh -s $(which zsh) $(whoami)
sudo curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash -s >/dev/null 2>&1
printf "Patching agnoster theme fonts..."$(date '+%T')
wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf >/dev/null 2>&1
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf >/dev/null 2>&1
sudo mkdir ~/.fonts/
sudo mkdir -p ~/.config/fontconfig/conf.d/
sudo mv PowerlineSymbols.otf ~/.fonts/
fc-cache -vf ~/.fonts/
sudo mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
printf "Setting terminal theme..."
sudo sed -i '/ZSH_THEME/c ZSH_THEME="agnoster"' ~/.zshrc >/dev/null 2>&1
sudo sed -i '/plugins=(/c plugins=(git git-extras npm atom chucknorris encode64 jsontools vagrant web-search wd)' ~/.zshrc >/dev/null 2>&1

# Miscellaneous Items
# -------------------
printf "Installing miscellaneous items..."$(date '+%T')
sudo apt-get install -y figlet toilet >/dev/null 2>&1

printf "Rebooting in 3 seconds..."
sleep 3 && sudo reboot
