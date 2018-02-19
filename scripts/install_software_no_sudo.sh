#!/usr/bin/env bash
#Make setup.sh executable
chmod +x setup.sh
#Source install functions
. ./functions.sh

log "Installing nvm"
curl -so- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash >/dev/null 2>&1

log "Installing rvm"
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 >/dev/null 2>&1
curl -sSL https://get.rvm.io | bash -s stable >/dev/null 2>&1

install_powerline_font #needed for agnoster oh-my-zsh theme

SCRIPT_FOLDER=.${ORG_NAME:-jhwohlgemuth}
mkdir -p ~/${SCRIPT_FOLDER}

if [[ -e functions.sh ]]; then
    mv functions.sh ~/${SCRIPT_FOLDER}
fi

if [[ -e setup.sh ]]; then
    mv setup.sh ~/${SCRIPT_FOLDER}
fi

if [[ -e profiles.clj ]]; then
    mv profiles.clj ~/${SCRIPT_FOLDER}
fi

if type atom >/dev/null 2>&1; then
    mv snippets.cson ~/.atom
else
    mv snippets.cson ~/${SCRIPT_FOLDER}
fi
