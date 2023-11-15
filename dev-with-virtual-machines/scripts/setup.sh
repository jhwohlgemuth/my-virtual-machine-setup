#!/usr/bin/env bash
if [[ $(whoami) == "root" ]]; then
    echo "✘ Setup should not be run as root"
    return 0
fi
main() {
    disable_auto_update
    turn_off_screen_lock
    turn_on_workspaces
    install_ohmyzsh
    customize_ohmyzsh
    customize_run_commands
    log "Installing node"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    nvm install node
    nvm alias default node
    log_done_message
}
# shellcheck disable=SC1090
customize_ohmyzsh() {
    CONFIG=$HOME/.zshrc
    if [ -f "${CONFIG}" ]; then
        install_ohmyzsh_plugins
        install_powerline_font
        THEME="agnoster"
        PLUGINS="colored-man-pages extract git encode64 jsontools nmap web-search wd zsh-pentest zsh-syntax-highlighting zsh-autosuggestions"
        log "Setting zsh terminal theme ($THEME)"
        sed -i '1s;^;ZSH_DISABLE_COMPFIX="true"\n;' $CONFIG
        sed -i.bak "s/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"$THEME\"/" $CONFIG
        sed -i.bak "s/plugins=(git)/plugins=($PLUGINS)/" $CONFIG
    else
        log "Failed to find ${CONFIG} file"
    fi
}
customize_run_commands() {
    CONFIG=${1:-$HOME/.zshrc}
    SCRIPT_FOLDER=${HOME}/.${SCRIPTS_HOME_DIRECTORY:-jhwohlgemuth}
    add_nvm() {
        CONFIG=${1:-$HOME/.zshrc}
        echo 'export PATH="${HOME}/bin:${PATH}"' >> $CONFIG
        echo 'export NVM_DIR="${HOME}/.nvm"' >> $CONFIG
        echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\"" >> $CONFIG
        echo "npm completion >/dev/null 2>&1" >> $CONFIG
    }
    if [ -f "${CONFIG}" ]; then
        [ -f $SCRIPT_FOLDER/functions.sh ] && echo "source ${SCRIPT_FOLDER}/functions.sh" >> $CONFIG
        [[ $(grep 'NVM_DIR' $CONFIG) ]] || add_nvm $CONFIG
    else
        log "Failed to find ${CONFIG} file"
    fi
}
disable_auto_update() {
    sed -i '/APT::Periodic::Update-Package-Lists "1";/c APT::Periodic::Update-Package-Lists "0";' /etc/apt/apt.conf.d/10periodic
}
install_ohmyzsh() {
    log "Installing Oh-My-Zsh"
    curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash -s
    echo vagrant | sudo -S chsh -s "$(command -v zsh)" "$(whoami)"
}
install_ohmyzsh_plugins() {
    BASE=$ZSH_CUSTOM/plugins
    PLUGINS=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins
    [[ -d $BASE/zsh-handy-helpers ]] || git clone https://github.com/jhwohlgemuth/zsh-handy-helpers.git "$PLUGINS"/zsh-handy-helpers
    [[ -d $BASE/zsh-pentest ]] || git clone https://github.com/jhwohlgemuth/zsh-pentest.git "$PLUGINS"/zsh-pentest
    [[ -d $BASE/zsh-syntax-highlighting ]] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGINS"/zsh-syntax-highlighting
    [[ -d $BASE/zsh-autosuggestions ]] || git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS"/zsh-autosuggestions
}
install_powerline_font() {
    log "Installing powerline font"
    curl -O https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
    curl -O https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
    mkdir ~/.fonts/
    mkdir -p ~/.config/fontconfig/conf.d/
    mv PowerlineSymbols.otf ~/.fonts/
    fc-cache -vf ~/.fonts/
    mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
}
log() {
    TIMEZONE=Central
    MAXLEN=60
    MSG=$1
    for i in $(seq ${#MSG} $MAXLEN)
    do
        MSG=$MSG.
    done
    MSG=$MSG$(TZ=":US/$TIMEZONE" date +%T)
    echo "$MSG"
}
log_done_message() {
    if type toilet >/dev/null 2>&1; then
        toilet -f pagga -F border --gay All Done!
    else
        log "All Done!"
    fi
}
turn_off_screen_lock() {
    log "Turning off screen lock"
    gsettings set org.gnome.desktop.session idle-delay 0
    gsettings set org.gnome.desktop.screensaver lock-enabled false
    gsettings set org.gnome.desktop.lockdown disable-lock-screen 'true'
}
turn_on_workspaces() {
    log "Turning on workspaces (unity)"
    gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize 2
    gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize 2
}
main