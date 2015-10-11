#!/usr/bin/env bash
SSH_PASSWORD=${SSH_PASSWORD:-vagrant}

echo "Installing Oh-My-Zsh............."$(date '+%T')
curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash -s >/dev/null 2>&1
echo "Setting terminal theme..........."$(date '+%T')
sed -i '/ZSH_THEME/c ZSH_THEME="agnoster"' ~/.zshrc
sed -i '/plugins=(/c plugins=(git git-extras npm encode64 jsontools web-search wd)' ~/.zshrc
echo "export NVM_DIR=/home/vagrant/.nvm" >> ~/.zshrc
echo "[ -s '$NVM_DIR/nvm.sh' ] && . '$NVM_DIR/nvm.sh'" >> ~/.zshrc
echo $SSH_PASSWORD | sudo -S chsh -s $(which zsh) $(whoami)

echo "Turning off screen lock.........."$(date '+%T')
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.lockdown disable-lock-screen 'true'

echo "Installing node & node modules..."$(date '+%T')
. ~/.zshrc
nvm install stable
nvm alias default stable
npm install -g npm
npm install -g grunt-cli phantomjs casperjs yo flow-bin ijavascript

echo "All Done!"
sleep 5
exit