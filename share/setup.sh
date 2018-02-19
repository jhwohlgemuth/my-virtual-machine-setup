#!/usr/bin/env bash
if [ `whoami` == 'root' ]; then
    echo "✘ Setup should not be run as root"
    return 0
fi

#Set environment variables
SSH_PASSWORD=${SSH_PASSWORD:-vagrant}
ORG_NAME=${ORG_NAME:-jhwohlgemuth}

#Source log function
. ${HOME}/.${ORG_NAME}/functions.sh

#Install and configure oh-my-zsh, customize .zshrc
if [ -f "${HOME}/.zshrc" ]; then
  log "Installing Oh-My-Zsh"
  curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash -s >/dev/null 2>&1
  log "Setting zsh terminal theme"
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
  echo "source ${HOME}/.${ORG_NAME}/functions.sh" >> ~/.zshrc
  echo 'alias rf="rm -frd"' >> ~/.zshrc
  echo $SSH_PASSWORD | sudo -S chsh -s $(which zsh) $(whoami)
  . ${HOME}/.zshrc
else
  log 'Failed to install and configure oh-my-zsh'
fi

log "Turning on workspaces (unity)"
gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize 2
gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize 2

log "Turning off screen lock"
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.lockdown disable-lock-screen 'true'

log "Installing node"
nvm install node && nvm alias default node

install_popular_node_modules
install_popular_atom_plugins

log "Installing Ruby and ruby gems"
. ${HOME}/.rvm/scripts/rvm
rvm use --default --install 2.1
gem install jekyll

if type toilet >/dev/null 2>&1; then
    toilet -f pagga -F border --gay All Done!
else
    log "All Done!"
fi
