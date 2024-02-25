#!/usr/bin/env bash
if [[ $(whoami) != "root" ]]; then
    echo "✘ Script should be run as root"
    return 0
fi
main() {
    update
    install_docker
    install_vscode
}
install_docker() {
    update "$1"
    log "Preparing Docker dependencies"
    apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
    log "Adding GPG key"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    apt-key fingerprint 0EBFCD88
    log "Adding repository"
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
    update "$1"
    log "Installing Docker CE"
    apt-get install docker-ce docker-ce-cli containerd.io -y
}
install_vscode() {
    if type snap >/dev/null 2>&1; then
        log "Installing VS Code snap"
        snap install code --classic
    else
        curl -s https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
        mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
        sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' >/dev/null 2>&1
        update
        log "Installing VS Code"
        apt-get install code -y --force-yes
    fi
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
update() {
    log "Updating"
    apt-key update
    apt-get update
}
main