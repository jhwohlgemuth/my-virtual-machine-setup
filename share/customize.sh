#!/usr/bin/env bash
echo "Turning off screen lock..."
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.lockdown disable-lock-screen 'true'

# Personalize terminal
# --------------------
echo "Installing Oh-My-Zsh..."$(date '+%T')
apt-get install -y zsh >/dev/null 2>&1
curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash -s >/dev/null 2>&1
echo "Patching agnoster theme fonts..."$(date '+%T')
wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf >/dev/null 2>&1
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf >/dev/null 2>&1
mkdir ~/.fonts/
mkdir -p ~/.config/fontconfig/conf.d/
mv PowerlineSymbols.otf ~/.fonts/
fc-cache -vf ~/.fonts/
mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
echo "Setting terminal theme..."
sed -i '/ZSH_THEME/c ZSH_THEME="agnoster"' ~/.zshrc >/dev/null 2>&1
sed -i '/plugins=(/c plugins=(git git-extras npm encode64 jsontools vagrant web-search wd)' ~/.zshrc >/dev/null 2>&1
chsh -s $(which zsh) $(whoami)

# Atom Plugins
# ------------
echo "Installing Atom plugins.........."$(date '+%T')
apm install minimap file-icons sublime-block-comment

toilet -f pagga -F border --gay All Done!
echo "Please log out"