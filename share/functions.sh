#!/usr/bin/env bash
# shellcheck disable=SC2120

SSH_PASSWORD=${SSH_PASSWORD:-vagrant}
SCRIPT_FOLDER=${HOME}/.${SCRIPTS_HOME_DIRECTORY:-jhwohlgemuth}

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
prevent_user() {
    if [[ "$1" == $(whoami) ]]; then
        echo "✘ ${2} should NOT be run as ${1}"
        exit 0
    fi
}
prevent_root() {
    prevent_user root "$1"
}
iter() {
    if [[ -f "$2" ]]
    then
        while read line; do
            $1 $line
        done < $2
    fi
}
install_crate() {
    prevent_root "$0"
    if type cargo >/dev/null 2>&1; then
        cargo install $1
    fi
}
install_extension() {
    prevent_root "$0"
    if type code >/dev/null 2>&1; then
        code --install-extension $1
    fi
}
install_module() {
    prevent_root "$0"
    if type npm >/dev/null 2>&1; then
        npm install --global $1
    fi
}
install_nix() {
    # prevent_root "$0"
    log "Installing Nix"
    # curl https://nixos.org/nix/install | sh
    mkdir /etc/nix; echo 'use-sqlite-wal = false' | sudo tee -a /etc/nix/nix.conf && sh <(curl https://nixos.org/releases/nix/nix-2.1.3/install) 
    if [ -f "${HOME}/.zshrc" ]; then
        echo "source ${HOME}/.nix-profile/etc/profile.d/nix.sh" >> ${HOME}/.zshrc
    fi
}
install_nix_package() {
    prevent_root "$0"
    if type nix-env >/dev/null 2>&1; then
        nix-env --install $1
    fi
}

#Collection of functions for installing and configuring software on Ubuntu
#Organized alphabetically

create_cached_repo() {
    log "Creating nexus3 repository"
    docker run -d -p 8081:8081 --name nexus sonatype/nexus3
}

customize_run_commands() {
    prevent_root "$0"
    CONFIG=${1:-$HOME/.zshrc}
    add_nvm() {
        CONFIG=${1:-$HOME/.zshrc}
        echo 'export PATH="${HOME}/bin:${PATH}"' >> $CONFIG
        echo 'export NVM_DIR="${HOME}/.nvm"' >> $CONFIG
        echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\"" >> $CONFIG
        echo "npm completion >/dev/null 2>&1" >> $CONFIG
    }
    if [ -f "${CONFIG}" ]; then
        [ -f $SCRIPT_FOLDER/functions.sh ] && echo "source ${SCRIPT_FOLDER}/functions.sh" >> $CONFIG
        #
        # General functions
        #
        [[ `grep 'clean()' $CONFIG` ]] || echo "clean() { rm -frd \$1 && mkdir \$1 && cd \$1 ; }" >> $CONFIG
        #
        # Docker functions
        #
        [[ `grep 'dip()' $CONFIG` ]] || echo "dip() { docker inspect --format '{{ .NetworkSettings.IPAddress }}' \$1 ; }" >> $CONFIG
        [[ `grep 'docker_rm_all' $CONFIG` ]] ||  echo "docker_rm_all() { docker stop \$(docker ps -a -q) && docker rm \$(docker ps -a -q) ; }" >> $CONFIG
        #
        # External functions
        #
        [[ `grep 'NVM_DIR' $CONFIG` ]] || add_nvm $CONFIG
    else
        log "Failed to find ${CONFIG} file"
    fi
}

customize_ohmyzsh() {
    prevent_root "$0"
    CONFIG=$HOME/.zshrc
    if [ -f "${CONFIG}" ]; then
        install_powerline_font
        install_zsh_plugins
        log "Setting zsh terminal theme"
        sed -i '/ZSH_THEME/c ZSH_THEME="agnoster"' $CONFIG
        sed -i '/plugins=(git)/c plugins=(colored-man-pages extract git git-extras npm docker encode64 jsontools web-search wd zsh-syntax-highlighting zsh-autosuggestions)' $CONFIG
    else
        log "Failed to find ${CONFIG} file"
    fi
}

disable_auto_update() {
    sed -i '/APT::Periodic::Update-Package-Lists "1";/c APT::Periodic::Update-Package-Lists "0";' /etc/apt/apt.conf.d/10periodic
}

fix_ssh_key_permissions() {
    prevent_root "$0"
    chmod 600 ~/.ssh/config
}

fix_enospc_issue() {
    echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p >/dev/null 2>&1
}

install_atom() {
    log "Installing Atom editor"
    add-apt-repository -y ppa:webupd8team/atom > $SCRIPT_FOLDER/log
    apt-get update > $SCRIPT_FOLDER/log
    apt-get install -y atom > $SCRIPT_FOLDER/log
}

install_cairo() {
    log "Installing Cairo"
    apt-get install -y libcairo2-dev libjpeg8-dev libpango1.0-dev libgif-dev build-essential g++ > $SCRIPT_FOLDER/log
}

install_clojure() {
    prevent_root "$0"
    log "Installing Clojure tools and dependencies"
    install_sdkman
    sdk install java
    sdk install leiningen
    if [ -f "${SCRIPT_FOLDER}/profiles.clj" ]; then
        mkdir -p "$HOME"/.lein
        mv "${SCRIPT_FOLDER}"/profiles.clj "${HOME}"/.lein
    fi
    if type npm >/dev/null 2>&1; then
        log "Installing lumo Clojure REPL"
        npm install -g lumo-cljs > $SCRIPT_FOLDER/log
    fi
    if type apm >/dev/null 2>&1; then
        log "Installing Clojure Atom plugins"
        apm install parinfer lisp-paredit > $SCRIPT_FOLDER/log
    fi
}

install_couchdb() {
    log "Installing CouchDB"
    apt-get install -y curl > $SCRIPT_FOLDER/log
    apt-get install -y couchdb > $SCRIPT_FOLDER/log
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
    update "$1"
    log "Preparing Docker dependencies"
    apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y > $SCRIPT_FOLDER/log
    log "Adding GPG key"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - > $SCRIPT_FOLDER/log
    apt-key fingerprint 0EBFCD88 > $SCRIPT_FOLDER/log
    log "Adding repository"
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable" > $SCRIPT_FOLDER/log
    update "$1"
    log "Installing Docker CE"
    apt-get install docker-ce docker-ce-cli containerd.io -y > $SCRIPT_FOLDER/log
}

install_docker_compose() {
    log "Installing Docker Compose"
    curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-"$(uname -s)"-"$(uname -m)" -o /usr/local/bin/docker-compose > $SCRIPT_FOLDER/log
    chmod +x /usr/local/bin/docker-compose
}

install_dotnet() {
    log "Registering Microsoft key and feed"
    wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb > $SCRIPT_FOLDER/log
    dpkg -i packages-microsoft-prod.deb > $SCRIPT_FOLDER/log
    log "Installing dependencies"
    apt-get install apt-transport-https -y > $SCRIPT_FOLDER/log
    update
    log "Installing .NET SDK"
    apt-get install dotnet-sdk-2.1 -y --allow-unauthenticated > $SCRIPT_FOLDER/log
    rm -frd packages-microsoft-prod.deb
}

install_firacode() {
    prevent_root "$0"
    log "Installing Fira Code font"
    fonts_dir="${HOME}/.local/share/fonts"
    if [ ! -d "${fonts_dir}" ]; then
        log "Creating fonts directory"
        mkdir -p "${fonts_dir}" > $SCRIPT_FOLDER/log
    else
        log "Found fonts dir: $fonts_dir"
    fi
    for type in Bold Light Medium Regular Retina; do
        file_path="${HOME}/.local/share/fonts/FiraCode-${type}.ttf"
        file_url="https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-${type}.ttf?raw=true"
        if [ ! -e "${file_path}" ]; then
            log "Downloading font - ${type}"
            wget -O "${file_path}" "${file_url}" > $SCRIPT_FOLDER/log
        else
            log "✔ Found existing file: ${type}"
        fi;
    done
    log "Running fc-cache"
    fc-cache -f > $SCRIPT_FOLDER/log
}

install_fsharp() {
    install_mono
    log "Installing F#"
    apt-get install fsharp -y > $SCRIPT_FOLDER/log
}

install_heroku() {
    log "Installing Heroku CLI"
    add-apt-repository "deb https://cli-assets.heroku.com/branches/stable/apt ./" > $SCRIPT_FOLDER/log
    curl -L https://cli-assets.heroku.com/apt/release.key | apt-key add - > $SCRIPT_FOLDER/log
    update
    apt-get install heroku > $SCRIPT_FOLDER/log
}

install_ionide() {
    prevent_root "$0"
    if type code >/dev/null 2>&1; then
        log "Installing Ionide IDE"
        code --install-extension Ionide.Ionide-fsharp > $SCRIPT_FOLDER/log
    else
        echo "✘ Ionide requires VS Code. Please install VS Code."
    fi
}

install_java8() {
    log "Installing JRE and JDK"
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
    add-apt-repository -y ppa:webupd8team/java > $SCRIPT_FOLDER/log
    apt-get update > $SCRIPT_FOLDER/log
    apt-get install -y oracle-java8-installer > $SCRIPT_FOLDER/log
}

install_jenkins() {
    log "Preparing to install Jenkins"
    wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add - > $SCRIPT_FOLDER/log
    sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list' > $SCRIPT_FOLDER/log
    apt-get update > $SCRIPT_FOLDER/log
    log "Installing Jenkins"
    apt-get install -y jenkins > $SCRIPT_FOLDER/log
}

install_julia() {
    log "Adding Julia language PPA"
    apt-get install -y software-properties-common python-software-properties > $SCRIPT_FOLDER/log
    add-apt-repository -y ppa:staticfloat/juliareleases > $SCRIPT_FOLDER/log
    add-apt-repository -y ppa:staticfloat/julia-deps > $SCRIPT_FOLDER/log
    apt-get update > $SCRIPT_FOLDER/log
    log "Installing Julia language"
    apt-get install -y julia > $SCRIPT_FOLDER/log
}

install_lein() {
    prevent_root "$0"
    log "Installing lein"
    mkdir -p "${HOME}"/bin
    curl -L https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -o "${HOME}"/bin/lein > $SCRIPT_FOLDER/log
    chmod a+x "${HOME}"/bin/lein
    lein > $SCRIPT_FOLDER/log
    if [ -f "${SCRIPT_FOLDER}/profiles.clj" ]; then
        mkdir -p "$HOME"/.lein
        mv "${SCRIPT_FOLDER}"/profiles.clj "${HOME}"/.lein
    fi
}

install_mesa() {
    log "Installing mesa"
    apt-add-repository ppa:xorg-edgers > $SCRIPT_FOLDER/log
    apt-get update > $SCRIPT_FOLDER/log
    apt-get install libdrm-dev > $SCRIPT_FOLDER/log
    apt-get build-dep mesa > $SCRIPT_FOLDER/log
    wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key|sudo apt-key add -
    apt-get install -y clang-3.6 clang-3.6-doc libclang-common-3.6-dev > $SCRIPT_FOLDER/log
    apt-get install -y libclang-3.6-dev libclang1-3.6 libclang1-3.6-dbg > $SCRIPT_FOLDER/log
    apt-get install -y libllvm-3.6-ocaml-dev libllvm3.6 libllvm3.6-dbg > $SCRIPT_FOLDER/log
    apt-get install -y lldb-3.6 llvm-3.6 llvm-3.6-dev llvm-3.6-doc > $SCRIPT_FOLDER/log
    apt-get install -y llvm-3.6-examples llvm-3.6-runtime clang-modernize-3.6 > $SCRIPT_FOLDER/log
    apt-get install -y clang-format-3.6 python-clang-3.6 lldb-3.6-dev > $SCRIPT_FOLDER/log
    apt-get install -y libx11-xcb-dev libx11-xcb1 libxcb-glx0-dev libxcb-dri2-0-dev > $SCRIPT_FOLDER/log
    apt-get install -y libxcb-dri3-dev libxshmfence-dev libxcb-sync-dev llvm > $SCRIPT_FOLDER/log
}

install_mongodb() {
    log "Installing MongoDB"
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4 > $SCRIPT_FOLDER/log
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list > $SCRIPT_FOLDER/log
    apt-get update > $SCRIPT_FOLDER/log
    apt-get install -y mongodb-org > $SCRIPT_FOLDER/log
    # Change config file to allow external connections
    sed -i '/bind_ip/c # bind_ip = 127.0.0.1' /etc/mongod.conf > $SCRIPT_FOLDER/log
    # Change default port to 8000
    #sudo sed -i '/#port/c port = 8000' /etc/mongod.conf >/dev/null 2>&1
    service mongod restart > $SCRIPT_FOLDER/log
    #The default port can be changed by editing /etc/mongod.conf
}

install_mono() {
    log "Adding mono repository"
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF > $SCRIPT_FOLDER/log
    # echo "deb http://download.mono-project.com/repo/ubuntu stable-trusty main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list >/dev/null 2>&1
    echo "deb https://download.mono-project.com/repo/ubuntu stable-xenial main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list >/dev/null 2>&1
    apt-get install apt-transport-https --yes > $SCRIPT_FOLDER/log
    update
    log "Installing mono"
    apt-get install mono-devel -y --force-yes > $SCRIPT_FOLDER/log
}

install_nvm() {
    prevent_root "$0"
    log "Installing nvm"
    curl -so- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash
}

install_ohmyzsh() {
    prevent_root "$0"
    log "Installing Oh-My-Zsh"
    curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash -s
    echo "$SSH_PASSWORD" | sudo -S chsh -s "$(command -v zsh)" "$(whoami)"
}

install_opam() {
    log "Installing OPAM"
    wget -q https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh -O - | sh -s /usr/local/bin > $SCRIPT_FOLDER/log
}

install_pandoc() {
    log "Installing Pandoc"
    apt-get install -y texlive texlive-latex-extra pandoc > $SCRIPT_FOLDER/log
}

install_planck() {
    log "Adding Planck Clojure REPL PPA"
    add-apt-repository ppa:mfikes/planck -y > $SCRIPT_FOLDER/log
    apt-get update > $SCRIPT_FOLDER/log
    log "Installing Planck"
    apt-get install -y planck > $SCRIPT_FOLDER/log
}

install_popular_atom_plugins() {
    prevent_root "$0"
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
    prevent_root "$0"
    npm install -g plato nodemon stmux deoptigate
    npm install -g ntl nsp nrm npmrc npm-run-all npm-check-updates
    npm install -g jay snyk grasp tldr stacks-cli thanks release surge now
}

install_powerline_font() {
    prevent_root "$0"
    log "Installing powerline font"
    wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf > $SCRIPT_FOLDER/log
    wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf > $SCRIPT_FOLDER/log
    mkdir ~/.fonts/
    mkdir -p ~/.config/fontconfig/conf.d/
    mv PowerlineSymbols.otf ~/.fonts/
    fc-cache -vf ~/.fonts/ > $SCRIPT_FOLDER/log
    mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
}

install_python() {
    log "Installing advanced Python support"
    apt-get install -y libzmq3-dev python-pip python-dev > $SCRIPT_FOLDER/log
    apt-get install -y libblas-dev libatlas-base-dev liblapack-dev gfortran libfreetype6-dev libpng-dev > $SCRIPT_FOLDER/log
    pip install --upgrade pip > $SCRIPT_FOLDER/log
    pip install --upgrade virtualenv > $SCRIPT_FOLDER/log
    pip install ipython[notebook] > $SCRIPT_FOLDER/log
}

install_R() {
    log "Installing R"
    add-apt-repository ppa:marutter/rrutter -y > $SCRIPT_FOLDER/log
    apt-get update -y > $SCRIPT_FOLDER/log
    apt-get upgrade -y > $SCRIPT_FOLDER/log
    apt-get install -y r-base > $SCRIPT_FOLDER/log
}

install_reason() {
    prevent_root "$0"
    log "Installing ReasonML support"
    npm install -g reason-cli@3.1.0-linux bs-platform create-react-app > $SCRIPT_FOLDER/log
    if type apm >/dev/null 2>&1; then
        log "Installing Atom ReasonML language support"
        apm install language-reason language-ocaml > $SCRIPT_FOLDER/log
    fi
    if type code >/dev/null 2>&1; then
        log "Installing VS Code ReasonML IDE"
        code --install-extension freebroccolo.reasonml > $SCRIPT_FOLDER/log
    fi
}

install_redis() {
    log "Installing redis"
    apt-get install -y redis-server > $SCRIPT_FOLDER/log
    #Configure redis-server to accept remote connections
    sed -i 's/bind 127.0.0.1/bind 0.0.0.0/' /etc/redis/redis.conf
    service redis-server restart > $SCRIPT_FOLDER/log
    #The default port can be changed by editing /etc/redis/redis.conf
}

install_rlwrap() {
    log "Installing rlwrap"
    git clone https://github.com/hanslub42/rlwrap.git > $SCRIPT_FOLDER/log
    cd rlwrap || return
    autoreconf --install > $SCRIPT_FOLDER/log
    ./configure > $SCRIPT_FOLDER/log
    make > $SCRIPT_FOLDER/log
    make check
    make install > $SCRIPT_FOLDER/log
    cd ..
    rm -frd rlwrap
}

install_rust() {
    prevent_root "$0"
    log "Installing Rust"
    curl https://sh.rustup.rs -sSf | sh -s -- -y > $SCRIPT_FOLDER/log
    echo "source ${HOME}/.cargo/env" >> ~/.zshrc
    # shellcheck disable=SC1090,SC1091
    . "${HOME}"/.cargo/env
    rustup toolchain install nightly > $SCRIPT_FOLDER/log
    rustup target add wasm32-unknown-unknown --toolchain nightly > $SCRIPT_FOLDER/log
    if type apm >/dev/null 2>&1; then
        log "Installing Atom Rust IDE"
        apm install ide-rust > $SCRIPT_FOLDER/log
    fi
    log "Installing wasm-gc"
    cargo install --git https://github.com/alexcrichton/wasm-gc > $SCRIPT_FOLDER/log
    log "Installing wasm-bindgen"
    cargo install wasm-bindgen-cli > $SCRIPT_FOLDER/log
    log "Installing just"
    cargo install just > $SCRIPT_FOLDER/log
    log "Installing cargo-edit"
    cargo install cargo-edit > $SCRIPT_FOLDER/log
    log "Installing cargo-audit"
    cargo install cargo-audit > $SCRIPT_FOLDER/log
    log "Installing tokei (line counting CLI tool)"
    cargo install tokei > $SCRIPT_FOLDER/log
}

install_rvm() {
    prevent_root "$0"
    log "Installing rvm"
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    curl -sSL https://get.rvm.io | bash -s stable
}

install_sdkman() {
    prevent_root "$0"
    log "Installing SDKMAN!"
    curl -s "https://get.sdkman.io" | bash
    # shellcheck disable=SC1090,SC1091
    source "$HOME/.sdkman/bin/sdkman-init.sh"
}

install_vscode() {
    curl -s https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg > $SCRIPT_FOLDER/log
    mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' >/dev/null 2>&1
    update
    log "Installing VSCode"
    apt-get install code -y --force-yes > $SCRIPT_FOLDER/log
}

install_vscode_extensions() {
    prevent_root "$0"
    if type code >/dev/null 2>&1; then
        code --install-extension 2gua.rainbow-brackets
        code --install-extension akamud.vscode-javascript-snippet-pack
        code --install-extension akamud.vscode-theme-onedark
        code --install-extension bierner.color-info
        code --install-extension bierner.lit-html
        code --install-extension christian-kohler.path-intellisense
        code --install-extension cssho.vscode-svgviewer
        code --install-extension deerawan.vscode-faker
        code --install-extension emmanuelbeziat.vscode-great-icons
        code --install-extension kisstkondoros.vscode-gutter-preview
        code --install-extension ms-vscode.atom-keybindings
        code --install-extension pnp.polacode
        code --install-extension Shan.code-settings-sync
        code --install-extension sidthesloth.html5-boilerplate
        code --install-extension SirTori.indenticator
        code --install-extension techer.open-in-browser
        code --install-extension wix.glean
        code --install-extension wix.vscode-import-cost
        code --install-extension wmaurer.change-case
    else
        log "Please install VSCode before installing VSCode plugins"
    fi
}

install_zsh_plugins() {
    BASE=$ZSH_CUSTOM/plugins
    [[ -d $BASE/pentest ]] || git clone https://github.com/jhwohlgemuth/oh-my-zsh-pentest-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/pentest
    [[ -d $BASE/zsh-syntax-highlighting ]] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    [[ -d $BASE/zsh-autosuggestions ]] || git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

setup_github_ssh() {
    prevent_root "$0"
    PASSPHRASE=${1:-123456}
    KEY_NAME=${2:-id_rsa}
    echo -n "Generating key pair......"
    ssh-keygen -q -b 4096 -t rsa -N "${PASSPHRASE}" -f ~/.ssh/"${KEY_NAME}"
    echo "DONE"
    if [[ -e ~/.ssh/"${KEY_NAME}".pub ]]; then
        if type xclip >/dev/null 2>&1; then
            cat ~/.ssh/"${KEY_NAME}".pub | xclip -sel clip
            echo "✔ Public key has been saved to clipboard"
        else
            cat ~/.ssh/"${KEY_NAME}".pub
        fi
        if [[ -s ~/.ssh/"${KEY_NAME}" ]]; then
            echo $'\n#GitHub alias\nHost me\n\tHostname github.com\n\tUser git\n\tIdentityFile ~/.ssh/'${KEY_NAME}$'\n' >> ~/.ssh/config
            echo "✔ git@me alias added to ~/.ssh/config for ${KEY_NAME}"
        fi
    else
        echo "Something went wrong, please try again."
    fi
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
update() {
    log "Updating"
    apt-key update > $SCRIPT_FOLDER/log
    apt-get update > $SCRIPT_FOLDER/log
}
