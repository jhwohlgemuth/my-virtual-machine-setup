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

log "Turning on workspaces (unity)"
gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize 2
gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize 2

log "Turning off screen lock"
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.lockdown disable-lock-screen 'true'

#Install version managers and font
install_nvm
install_rvm

install_ohmyzsh
customize_ohmyzsh

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
