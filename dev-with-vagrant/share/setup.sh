#!/usr/bin/env bash
if [[ $(whoami) == "root" ]]; then
    echo "✘ Setup should not be run as root"
    return 0
fi
# Source log function
# shellcheck disable=SC1090
. "${HOME}"/.jhwohlgemuth/functions.sh
# shellcheck disable=SC1090
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
disable_auto_update() {
    sed -i '/APT::Periodic::Update-Package-Lists "1";/c APT::Periodic::Update-Package-Lists "0";' /etc/apt/apt.conf.d/10periodic
}
turn_off_screen_lock() {
    prevent_root "$0"
    log "Turning off screen lock"
    gsettings set org.gnome.desktop.session idle-delay 0
    gsettings set org.gnome.desktop.screensaver lock-enabled false
    gsettings set org.gnome.desktop.lockdown disable-lock-screen 'true'
}
turn_on_workspaces() {
    prevent_root "$0"
    log "Turning on workspaces (unity)"
    gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize 2
    gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize 2
}
disable_auto_update
turn_off_screen_lock
turn_on_workspaces
install_ohmyzsh
customize_ohmyzsh
customize_run_commands

log "Installing node"
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
