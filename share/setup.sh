#!/usr/bin/env bash
if [ `whoami` == 'root' ]; then
    echo "✘ Setup should not be run as root"
    return 0
fi

ORG_NAME=${ORG_NAME:-jhwohlgemuth}

#Source log function
. ${HOME}/.${ORG_NAME}/functions.sh

turn_on_workspaces
turn_off_screen_lock

install_ohmyzsh
customize_ohmyzsh

install_nvm
install_rvm

log "Installing node"
. ${HOME}/.zshrc
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
