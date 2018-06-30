#!/usr/bin/env bash
SSH_PASSWORD=${SSH_PASSWORD:-vagrant}
SCRIPT_FOLDER=${HOME}/.${SCRIPTS_HOME_DIRECTORY:-jhwohlgemuth}
VERBOSE=false

#Collection of functions for installing and configuring software on Ubuntu
#Organized alphabetically

create_cached_repo() {
    log "Creating nexus3 repository"
    docker run -d -p 8081:8081 --name nexus sonatype/nexus3
}

customize_ohmyzsh() {
    prevent_root $0
    if [ -f "${HOME}/.zshrc" ]; then
      install_powerline_font
      log "Setting zsh terminal theme"
      sed -i '/ZSH_THEME/c ZSH_THEME="agnoster"' ~/.zshrc
      sed -i '/  git/c \ \ git git-extras npm docker encode64 jsontools web-search wd' ~/.zshrc
      echo 'export PATH="${HOME}/bin:${PATH}"' >> ~/.zshrc
      echo 'export NVM_DIR="${HOME}/.nvm"' >> ~/.zshrc
      echo "[ -s '$NVM_DIR/nvm.sh' ] && . '$NVM_DIR/nvm.sh'" >> ~/.zshrc
      echo "dip() { docker inspect --format '{{ .NetworkSettings.IPAddress }}' \$1 ; }" >> ~/.zshrc
      echo "docker_rm_all() { docker stop \$(docker ps -a -q) && docker rm \$(docker ps -a -q) ; }" >> ~/.zshrc
      echo "set_git_user() { git config --global user.name \$1 ; }" >> ~/.zshrc
      echo "set_git_email() { git config --global user.email \$1 ; }" >> ~/.zshrc
      echo "clean() { rm -frd \$1 && mkdir \$1 && cd \$1 ; }" >> ~/.zshrc
      echo "npm completion >/dev/null 2>&1" >> ~/.zshrc
      echo "source ${SCRIPT_FOLDER}/functions.sh" >> ~/.zshrc
      echo 'alias rf="rm -frd"' >> ~/.zshrc
    else
      log 'Failed to find .zshrc file'
    fi
}

fix_ssh_key_permissions() {
    prevent_root $0
    KEY_NAME=${1:-id_rsa}
    chmod 600 ~/.ssh/${KEY_NAME}
    chmod 600 ~/.ssh/${KEY_NAME}.pub
}

fix_enospc_issue() {
    echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p >/dev/null 2>&1
}

install_atom() {
    set_verbosity $1
    log "Installing Atom editor"
    run add-apt-repository -y ppa:webupd8team/atom
    run apt-get update
    run apt-get install -y atom
}

install_cairo() {
    set_verbosity $1
    log "Installing Cairo"
    run apt-get install -y libcairo2-dev libjpeg8-dev libpango1.0-dev libgif-dev build-essential g++
}

install_clojure() {
    prevent_root $0
    log "Installing Clojure tools and dependencies"
    install_sdkman
    sdk install java
    sdk install leiningen
    if [ -f "${SCRIPT_FOLDER}/profiles.clj" ]; then
        mkdir -p $HOME/.lein
        mv ${SCRIPT_FOLDER}/profiles.clj ${HOME}/.lein
    fi
    if type npm >/dev/null 2>&1; then
        log "Installing lumo Clojure REPL"
        npm install -g lumo-cljs >/dev/null 2>&1
    fi
    if type apm >/dev/null 2>&1; then
        log "Installing Clojure Atom plugins"
        apm install parinfer lisp-paredit >/dev/null 2>&1
    fi
}

install_couchdb() {
    log "Installing CouchDB"
    apt-get install -y curl >/dev/null 2>&1
    apt-get install -y couchdb >/dev/null 2>&1
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

install_docker() {
    log "Preparing Docker dependencies"
    update
    apt-get install apt-transport-https ca-certificates curl software-properties-common -y >/dev/null 2>&1
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - >/dev/null 2>&1
    apt-key fingerprint 0EBFCD88 >/dev/null 2>&1
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable" >/dev/null 2>&1
    update
    log "Installing Docker CE"
    apt-get install docker-ce -y >/dev/null 2>&1
}

install_docker_compose() {
    log "Installing Docker Compose"
    curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose >/dev/null 2>&1
    chmod +x /usr/local/bin/docker-compose
}

install_fsharp() {
    install_mono
    log "Installing F#"
    apt-get install fsharp -y >/dev/null 2>&1
}

install_heroku() {
    log "Installing Heroku CLI"
    add-apt-repository "deb https://cli-assets.heroku.com/branches/stable/apt ./" >/dev/null 2>&1
    curl -L https://cli-assets.heroku.com/apt/release.key | apt-key add - >/dev/null 2>&1
    apt-get update >/dev/null 2>&1
    apt-get install heroku >/dev/null 2>&1
}

install_ionide() {
    prevent_root $0
    if type code >/dev/null 2>&1; then
        log "Installing Ionide IDE"
        code --install-extension Ionide.Ionide-fsharp >/dev/null 2>&1
    else
        echo "✘ Ionide requires VS Code. Please install VS Code."
    fi
}

install_java8() {
    log "Installing JRE and JDK"
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
    add-apt-repository -y ppa:webupd8team/java >/dev/null 2>&1
    apt-get update >/dev/null 2>&1
    apt-get install -y oracle-java8-installer >/dev/null 2>&1
}

install_jenkins() {
    log "Preparing to install Jenkins"
    wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add - >/dev/null 2>&1
    sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list' >/dev/null 2>&1
    apt-get update >/dev/null 2>&1
    log "Installing Jenkins"
    apt-get install -y jenkins >/dev/null 2>&1
}

install_julia() {
    log "Adding Julia language PPA"
    apt-get install -y software-properties-common python-software-properties >/dev/null 2>&1
    add-apt-repository -y ppa:staticfloat/juliareleases >/dev/null 2>&1
    add-apt-repository -y ppa:staticfloat/julia-deps >/dev/null 2>&1
    apt-get update >/dev/null 2>&1
    log "Installing Julia language"
    apt-get install -y julia >/dev/null 2>&1
}

install_lein() {
    prevent_root $0
    log "Installing lein"
    mkdir -p ${HOME}/bin
    curl -L https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -o ${HOME}/bin/lein >/dev/null 2>&1
    chmod a+x ${HOME}/bin/lein
    lein >/dev/null 2>&1
    if [ -f "${SCRIPT_FOLDER}/profiles.clj" ]; then
        mkdir -p $HOME/.lein
        mv ${SCRIPT_FOLDER}/profiles.clj ${HOME}/.lein
    fi
}

install_mesa() {
    log "Installing mesa"
    apt-add-repository ppa:xorg-edgers >/dev/null 2>&1
    apt-get update >/dev/null 2>&1
    apt-get install libdrm-dev >/dev/null 2>&1
    apt-get build-dep mesa >/dev/null 2>&1
    wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key|sudo apt-key add -
    apt-get install -y clang-3.6 clang-3.6-doc libclang-common-3.6-dev >/dev/null 2>&1
    apt-get install -y libclang-3.6-dev libclang1-3.6 libclang1-3.6-dbg >/dev/null 2>&1
    apt-get install -y libllvm-3.6-ocaml-dev libllvm3.6 libllvm3.6-dbg >/dev/null 2>&1
    apt-get install -y lldb-3.6 llvm-3.6 llvm-3.6-dev llvm-3.6-doc >/dev/null 2>&1
    apt-get install -y llvm-3.6-examples llvm-3.6-runtime clang-modernize-3.6 >/dev/null 2>&1
    apt-get install -y clang-format-3.6 python-clang-3.6 lldb-3.6-dev >/dev/null 2>&1
    apt-get install -y libx11-xcb-dev libx11-xcb1 libxcb-glx0-dev libxcb-dri2-0-dev >/dev/null 2>&1
    apt-get install -y libxcb-dri3-dev libxshmfence-dev libxcb-sync-dev llvm >/dev/null 2>&1
}

install_mongodb() {
    log "Installing MongoDB"
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 >/dev/null 2>&1
    echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list >/dev/null 2>&1
    apt-get update >/dev/null 2>&1
    apt-get install -y mongodb-org >/dev/null 2>&1
    # Change config file to allow external connections
    sed -i '/bind_ip/c # bind_ip = 127.0.0.1' /etc/mongod.conf >/dev/null 2>&1
    # Change default port to 8000
    #sudo sed -i '/#port/c port = 8000' /etc/mongod.conf >/dev/null 2>&1
    service mongod restart >/dev/null 2>&1
    #The default port can be changed by editing /etc/mongod.conf
}

install_mono() {
    log "Adding mono repository"
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF >/dev/null 2>&1
    echo "deb http://download.mono-project.com/repo/ubuntu stable-trusty main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list >/dev/null 2>&1
    update
    log "Installing mono"
    apt-get install mono-devel -y --force-yes >/dev/null 2>&1
}

install_nvm() {
    prevent_root $0
    log "Installing nvm"
    curl -so- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash >/dev/null 2>&1
}

install_ohmyzsh() {
    prevent_root $0
    log "Installing Oh-My-Zsh"
    curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash -s >/dev/null 2>&1
    echo $SSH_PASSWORD | sudo -S chsh -s $(which zsh) $(whoami)
}

install_opam() {
    log "Installing OPAM"
    wget -q https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh -O - | sh -s /usr/local/bin >/dev/null 2>&1
}

install_pandoc() {
    log "Installing Pandoc"
    apt-get install -y texlive texlive-latex-extra pandoc >/dev/null 2>&1
}

install_planck() {
    log "Adding Planck Clojure REPL PPA"
    add-apt-repository ppa:mfikes/planck -y >/dev/null 2>&1
    apt-get update >/dev/null 2>&1
    log "Installing Planck"
    apt-get install -y planck >/dev/null 2>&1
}

install_popular_atom_plugins() {
    prevent_root $0
    if type apm >/dev/null 2>&1; then
        log "Installing Atom plugins"
        #editor and language plugins
        apm install file-icons sublime-block-comment atom-beautify language-babel emmet atom-alignment atom-ternjs atom-terminal color-picker pigments atom-quokka editorconfig
        #minimap plugins
        apm install minimap minimap-selection minimap-find-and-replace minimap-git-diff
        #svg plugins
        apm install language-svg svg-preview
    else
        log "Please install Atom before installing Atom plugins"
    fi
}

install_popular_node_modules() {
    prevent_root $0
    npm install -g grunt-cli yo plato nodemon stmux
    npm install -g flow-bin flow-typed
    npm install -g snyk ntl nsp npm-check-updates npmrc grasp tldr stacks-cli thanks bit-bin release
}

install_powerline_font() {
    prevent_root $0
    log "Installing powerline font"
    wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf >/dev/null 2>&1
    wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf >/dev/null 2>&1
    mkdir ~/.fonts/
    mkdir -p ~/.config/fontconfig/conf.d/
    mv PowerlineSymbols.otf ~/.fonts/
    fc-cache -vf ~/.fonts/ >/dev/null 2>&1
    mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
}

install_python() {
    log "Installing advanced Python support"
    apt-get install -y libzmq3-dev python-pip python-dev >/dev/null 2>&1
    apt-get install -y libblas-dev libatlas-base-dev liblapack-dev gfortran libfreetype6-dev libpng-dev >/dev/null 2>&1
    pip install --upgrade pip >/dev/null 2>&1
    pip install --upgrade virtualenv >/dev/null 2>&1
    pip install ipython[notebook] >/dev/null 2>&1
}

install_R() {
    log "Installing R"
    add-apt-repository ppa:marutter/rrutter -y >/dev/null 2>&1
    apt-get update -y >/dev/null 2>&1
    apt-get upgrade -y >/dev/null 2>&1
    apt-get install -y r-base >/dev/null 2>&1
}

install_reason() {
    prevent_root $0
    log "Installing ReasonML support"
    npm install -g reason-cli@3.1.0-linux bs-platform create-react-app >/dev/null 2>&1
    if type apm >/dev/null 2>&1; then
        log "Installing Atom ReasonML language support"
        apm install language-reason language-ocaml >/dev/null 2>&1
    fi
    if type code >/dev/null 2>&1; then
        log "Installing VS Code ReasonML IDE"
        code --install-extension freebroccolo.reasonml >/dev/null 2>&1
    fi
}

install_redis() {
    log "Installing redis"
    apt-get install -y redis-server >/dev/null 2>&1
    #Configure redis-server to accept remote connections
    sed -i 's/bind 127.0.0.1/bind 0.0.0.0/' /etc/redis/redis.conf
    service redis-server restart >/dev/null 2>&1
    #The default port can be changed by editing /etc/redis/redis.conf
}

install_rlwrap() {
    log "Installing rlwrap"
    git clone https://github.com/hanslub42/rlwrap.git >/dev/null 2>&1
    cd rlwrap
    autoreconf --install  >/dev/null 2>&1
    ./configure >/dev/null 2>&1
    make >/dev/null 2>&1
    make check
    make install >/dev/null 2>&1
    cd ..
    rm -frd rlwrap
}

install_rust() {
    prevent_root $0
    log "Installing Rust"
    curl https://sh.rustup.rs -sSf | sh -s -- -y >/dev/null 2>&1
    echo "source ${HOME}/.cargo/env" >> ~/.zshrc
    . ${HOME}/.cargo/env
    rustup toolchain install nightly >/dev/null 2>&1
    rustup target add wasm32-unknown-unknown --toolchain nightly >/dev/null 2>&1
    if type apm >/dev/null 2>&1; then
        log "Installing Atom Rust IDE"
        apm install ide-rust >/dev/null 2>&1
    fi
    log "Installing wasm-gc"
    cargo install --git https://github.com/alexcrichton/wasm-gc >/dev/null 2>&1
    log "Installing wasm-bindgen"
    cargo install wasm-bindgen-cli >/dev/null 2>&1
    log "Installing just"
    cargo install just >/dev/null 2>&1
    log "Installing tokei (line counting CLI tool)"
    cargo install tokei >/dev/null 2>&1
}

install_rvm() {
    prevent_root $0
    log "Installing rvm"
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 >/dev/null 2>&1
    curl -sSL https://get.rvm.io | bash -s stable >/dev/null 2>&1
}

install_sdkman() {
    prevent_root $0
    log "Installing SDKMAN!"
    curl -s "https://get.sdkman.io" | bash >/dev/null 2>&1
    source "$HOME/.sdkman/bin/sdkman-init.sh"
}

install_vscode() {
    curl -s https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg >/dev/null 2>&1
    mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' >/dev/null 2>&1
    update
    log "Installing VSCode"
    apt-get install code -y --force-yes >/dev/null 2>&1
}

install_vscode_extensions() {
    prevent_root $0
    if type code >/dev/null 2>&1; then
        code --install-extension akamud.vscode-theme-onedark
        code --install-extension emmanuelbeziat.vscode-great-icons
        code --install-extension pnp.polacode
        code --install-extension bierner.color-info
        code --install-extension wix.vscode-import-cost
        code --install-extension techer.open-in-browser
        code --install-extension Shan.code-settings-sync
        code --install-extension kisstkondoros.vscode-gutter-preview
    else
        log "Please install VSCode before installing VSCode plugins"
    fi
}

log() {
    TIMEZONE=Central
    MAXLEN=50
    MSG=$1
    for i in $(seq ${#MSG} $MAXLEN)
    do
        MSG=$MSG.
    done
    MSG=$MSG$(TZ=":US/$TIMEZONE" date +%T)
    echo $MSG
}

prevent_user() {
    if [ `whoami` == $1 ]; then
        echo "✘ ${2} should NOT be run as ${1}"
        exit 0
    fi
}

prevent_root() {
    prevent_user root $1
}

run() {
    if $VERBOSE; then
        $@
    else
        $@ &>/dev/null
    fi
}

set_verbosity() {
    if [[ "$1" == "--verbose" ]]; then
        VERBOSE=true
    else
        VERBOSE=false
    fi
}

setup_github_ssh() {
    prevent_root $0
    PASSPHRASE=${1:-123456}
    KEY_NAME=${2:-id_rsa}
    echo -n "Generating key pair......"
    ssh-keygen -q -b 4096 -t rsa -N ${PASSPHRASE} -f ~/.ssh/${KEY_NAME}
    echo "DONE"
    if [[ -e ~/.ssh/${KEY_NAME}.pub ]]; then
        if type xclip >/dev/null 2>&1; then
            cat ~/.ssh/${KEY_NAME}.pub | xclip -sel clip
            echo "✔ Public key has been saved to clipboard"
        else
            cat ~/.ssh/${KEY_NAME}.pub
        fi
        if [[ -s ~/.ssh/${KEY_NAME} ]]; then
            echo $'\n#GitHub alias\nHost me\n\tHostname github.com\n\tUser git\n\tIdentityFile ~/.ssh/'${KEY_NAME}$'\n' >> ~/.ssh/config
            echo "✔ git@me alias added to ~/.ssh/config for ${KEY_NAME}"
        fi
    else
        echo "Something went wrong, please try again."
    fi
}

turn_off_screen_lock() {
    prevent_root $0
    log "Turning off screen lock"
    gsettings set org.gnome.desktop.session idle-delay 0
    gsettings set org.gnome.desktop.screensaver lock-enabled false
    gsettings set org.gnome.desktop.lockdown disable-lock-screen 'true'
}

turn_on_workspaces() {
    prevent_root $0
    log "Turning on workspaces (unity)"
    gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize 2
    gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize 2
}

update() {
    set_verbosity $1
    log "Updating"
    run apt-key update
    run apt-get update
}
