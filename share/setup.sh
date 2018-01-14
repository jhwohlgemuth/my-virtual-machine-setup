#!/usr/bin/env bash
SSH_USER=${SSH_USER:-vagrant}
SSH_PASSWORD=${SSH_PASSWORD:-vagrant}
ORG_NAME=${ORG_NAME:-jhwohlgemuth}

#Source log function
. ~/.${ORG_NAME}/functions.sh

log "Installing Oh-My-Zsh"
curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash -s >/dev/null 2>&1

log "Setting terminal theme"
sed -i '/ZSH_THEME/c ZSH_THEME="agnoster"' ~/.zshrc
sed -i '/  git/c \ \ git git-extras npm docker encode64 jsontools web-search wd' ~/.zshrc
echo 'export NVM_DIR="${HOME}/.nvm"' >> ~/.zshrc
echo 'export PATH="${HOME}/bin:${PATH}"' >> ~/.zshrc
echo "[ -s '$NVM_DIR/nvm.sh' ] && . '$NVM_DIR/nvm.sh'" >> ~/.zshrc
echo "dip() { docker inspect --format '{{ .NetworkSettings.IPAddress }}' \$1 ; }" >> ~/.zshrc
echo "docker_rm_all() { docker stop \$(docker ps -a -q) && docker rm \$(docker ps -a -q) ; }" >> ~/.zshrc
echo "set_git_user() { git config --global user.name \$1 ; }" >> ~/.zshrc
echo "set_git_email() { git config --global user.email \$1 ; }" >> ~/.zshrc
echo "clean() { rm -frd \$1 && mkdir \$1 && cd \$1 ; }" >> ~/.zshrc
echo "npm completion >/dev/null 2>&1" >> ~/.zshrc
echo "source /home/${SSH_USER}/.${ORG_NAME}/functions.sh" >> ~/.zshrc
echo 'alias rf="rm -frd"' >> ~/.zshrc
echo $SSH_PASSWORD | sudo -S chsh -s $(which zsh) $(whoami)

log "Turning on workspaces (unity)"
gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize 2
gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize 2

log "Turning off screen lock"
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.lockdown disable-lock-screen 'true'

log "Installing node & node modules"
. ~/.zshrc
nvm install node && nvm alias default node
npm install -g grunt-cli yo flow-bin plato nodemon ijavascript stmux
npm install -g snyk ntl nsp npm-check-updates npmrc grasp tldr
npm install -g lumo-cljs
npm install -g verdaccio

log "Installing Ruby and ruby gems"
. ~/.rvm/scripts/rvm
rvm use --default --install 2.1
gem install jekyll

if type toilet >/dev/null 2>&1; then
    toilet -f pagga -F border --gay All Done!
else
    log "All Done!"
fi
