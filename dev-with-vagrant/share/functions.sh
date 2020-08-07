#!/usr/bin/env bash
# shellcheck disable=SC2120
NODE_MODULES=(
    deoptigate
    fx
    grasp
    ipt
    jay
    jscpd
    lumo-cljs
    nodemon
    now
    npmrc
    npm-run-all
    npm-check-updates
    nrm
    nsp
    ntl
    nve
    plato
    release
    snyk
    stacks-cli
    stmux
    surge
    thanks
    tldr
)
VSCODE_EXTENSIONS=(
    ms-vscode.atom-keybindings
    formulahendry.auto-rename-tag
    jetmartin.bats
    shan.code-settings-sync
    wmaurer.change-case
    bierner.color-info
    bierner.lit-html
    deerawan.vscode-faker
    ms-dotnettools.csharp
    GrapeCity.gc-excelviewer
    wix.glean
    icsharpcode.ilspy-vscode
    sirtori.indenticator
    Ionide.Ionide-FAKE
    Ionide.Ionide-fsharp
    Ionide.Ionide-Paket
    silvenon.mdx
    techer.open-in-browser
    christian-kohler.path-intellisense
    ms-vscode.powershell
    2gua.rainbow-brackets
    mechatroner.rainbow-csv
    freebroccolo.reasonml
    ms-vscode-remote.remote-containers
    ms-vscode-remote.remote-ssh
    ms-vscode-remote.remote-ssh-edit
    ms-vscode-remote.remote-wsl
    rafamel.subtle-brackets
    softwaredotcom.swdc-vscode
    tabnine.tabnine-vscode
    marcostazi.VS-code-vagrantfile
    visualstudioexptteam.vscodeintellicode
    ms-azuretools.vscode-docker
    emmanuelbeziat.vscode-great-icons
    kisstkondoros.vscode-gutter-preview
    wix.vscode-import-cost
    akamud.vscode-javascript-snippet-pack
    johnpapa.vscode-peacock
    cssho.vscode-svgviewer
    akamud.vscode-javascript-snippet-pack
    akamud.vscode-theme-onedark
)
#Collection of functions for installing and configuring software on Ubuntu
#Organized alphabetically
install_couchdb() {
    log "Installing CouchDB"
    apt-get install -y curl
    apt-get install -y couchdb
    sed -i '/;port/c port = 5984' /etc/couchdb/local.ini
    sed -i '/;bind_address/c bind_address = 0.0.0.0' /etc/couchdb/local.ini
    lineNumber=$(($(echo $(grep -n '\[couch_httpd_auth\]' /etc/couchdb/local.ini) | awk -F':' '{print $1}')+1))
    sed -i "$lineNumber"'ipublic_fields = appdotnet, avatar, avatarMedium, avatarLarge, date, email, fields, freenode, fullname, github, homepage, name, roles, twitter, type, _id, _rev' /etc/couchdb/local.ini
    sed -i "$(($lineNumber+1))"'iusers_db_public = true' /etc/couchdb/local.ini
    lineNumber=$(($(echo $(grep -n '\[httpd\]' /etc/couchdb/local.ini) | awk -F':' '{print $1}')+1))
    sed -i "$lineNumber"'isecure_rewrites = false' /etc/couchdb/local.ini
    lineNumber=$(($(echo $(grep -n '\[couchdb\]' /etc/couchdb/local.ini) | awk -F':' '{print $1}')+1))
    sed -i "$lineNumber"'idelayed_commits = false' /etc/couchdb/local.ini
    #The default port can be changed by editing /etc/couchdb/local.ini
}
install_docker_compose() {
    log "Installing Docker Compose"
    curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-"$(uname -s)"-"$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
}
install_dotnet() {
    log "Registering Microsoft key and feed"
    wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
    dpkg -i packages-microsoft-prod.deb
    log "Installing dependencies"
    apt-get install apt-transport-https -y
    update
    log "Installing .NET SDK"
    apt-get install dotnet-sdk-2.1 -y --allow-unauthenticated
    rm -frd packages-microsoft-prod.deb
}
install_jenkins() {
    log "Preparing to install Jenkins"
    wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
    sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
    apt-get update
    log "Installing Jenkins"
    apt-get install -y jenkins
}
install_mongodb() {
    log "Installing MongoDB"
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
    apt-get update
    apt-get install -y mongodb-org
    # Change config file to allow external connections
    sed -i '/bind_ip/c # bind_ip = 127.0.0.1' /etc/mongod.conf
    # Change default port to 8000
    #sudo sed -i '/#port/c port = 8000' /etc/mongod.conf >/dev/null 2>&1
    service mongod restart
    #The default port can be changed by editing /etc/mongod.conf
}
install_nix() {
    log "Installing Nix"
    # curl https://nixos.org/nix/install | sh
    mkdir /etc/nix; echo 'use-sqlite-wal = false' | sudo tee -a /etc/nix/nix.conf && sh <(curl https://nixos.org/releases/nix/nix-2.1.3/install) 
    if [ -f "${HOME}/.zshrc" ]; then
        echo "source ${HOME}/.nix-profile/etc/profile.d/nix.sh" >> ${HOME}/.zshrc
    fi
}
install_python() {
    log "Installing advanced Python support"
    apt-get install -y libzmq3-dev python-pip python-dev
    apt-get install -y libblas-dev libatlas-base-dev liblapack-dev gfortran libfreetype6-dev libpng-dev
    pip install --upgrade pip
    pip install --upgrade virtualenv
    pip install ipython[notebook]
}
install_R() {
    log "Installing R"
    add-apt-repository ppa:marutter/rrutter -y
    apt-get update -y
    apt-get upgrade -y
    apt-get install -y r-base
}
install_redis() {
    log "Installing redis"
    apt-get install -y redis-server
    #Configure redis-server to accept remote connections
    sed -i 's/bind 127.0.0.1/bind 0.0.0.0/' /etc/redis/redis.conf
    service redis-server restart
    #The default port can be changed by editing /etc/redis/redis.conf
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