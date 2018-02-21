#!/usr/bin/env bash
SCRIPT_FOLDER=.${ORG_NAME:-jhwohlgemuth}
mkdir -p ~/${SCRIPT_FOLDER}

#Make setup.sh executable
chmod +x setup.sh

#Source install functions
. ./functions.sh

#Install version managers and font
install_nvm
install_rvm
install_powerline_font #needed for agnoster oh-my-zsh theme

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
