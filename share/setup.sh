#!/usr/bin/env bash
if [[ $(whoami) == "root" ]]; then
    echo "✘ Setup should not be run as root"
    return 0
fi

ORG_NAME=${ORG_NAME:-jhwohlgemuth}

# Source log function
# shellcheck disable=SC1090
. "${HOME}"/."${ORG_NAME}"/functions.sh

turn_on_workspaces
turn_off_screen_lock

install_ohmyzsh
customize_ohmyzsh
customize_run_commands
fix_enospc_issue

log "Installing node"
# shellcheck disable=SC1090
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install node
nvm alias default node
install_node_modules

log "Installing Ruby and ruby gems"
# shellcheck disable=SC1090
. "${HOME}"/.rvm/scripts/rvm
rvm use --default --install 2.4

if type toilet >/dev/null 2>&1; then
    toilet -f pagga -F border --gay All Done!
else
    log "All Done!"
fi
