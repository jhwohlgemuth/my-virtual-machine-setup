#!/usr/bin/env bash
TIMEZONE=Central
SSH_PASSWORD=${SSH_PASSWORD:-vagrant}

echo "Installing Oh-My-Zsh.............."$(TZ=":US/$TIMEZONE" date +%T)
curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash -s >/dev/null 2>&1
echo "Setting terminal theme............"$(TZ=":US/$TIMEZONE" date +%T)
sed -i '/ZSH_THEME/c ZSH_THEME="agnoster"' ~/.zshrc
sed -i '/plugins=(/c plugins=(git git-extras npm encode64 jsontools web-search wd)' ~/.zshrc
echo "export NVM_DIR=/home/vagrant/.nvm" >> ~/.zshrc
echo "[ -s '$NVM_DIR/nvm.sh' ] && . '$NVM_DIR/nvm.sh'" >> ~/.zshrc
echo $SSH_PASSWORD | sudo -S chsh -s $(which zsh) $(whoami)

echo "Turning on workspaces (unity)....."$(TZ=":US/$TIMEZONE" date +%T)
gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize 2
gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize 2

echo "Turning off screen lock..........."$(TZ=":US/$TIMEZONE" date +%T)
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.lockdown disable-lock-screen 'true'

echo "Installing node & node modules...."$(TZ=":US/$TIMEZONE" date +%T)
. ~/.zshrc
nvm install stable && nvm alias default stable
npm install -g grunt-cli phantomjs casperjs yo flow-bin nodemon ijavascript vmd
npm install -g sinopia && echo "[`date`] Sinopia server INSTALLED" > /var/log/npm-proxy.log

if type toilet >/dev/null 2>&1; then
    toilet -f pagga -F border --gay All Done!
else
    echo "All Done!"
fi
