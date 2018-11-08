#!/usr/bin/env bash
# shellcheck disable=SC2120

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
    prevent_root "$0"
    if [ -f "${HOME}/.zshrc" ]; then
      install_powerline_font
      log "Setting zsh terminal theme"
      sed -i '/ZSH_THEME/c ZSH_THEME="agnoster"' ~/.zshrc
      sed -i '/  git/c \ \ git git-extras npm docker encode64 jsontools web-search wd' ~/.zshrc
      echo 'export PATH="${HOME}/bin:${PATH}"' >> ~/.zshrc
      echo 'export NVM_DIR="${HOME}/.nvm"' >> ~/.zshrc
      echo "[ -s '$NVM_DIR/nvm.sh' ] && . '$NVM_DIR/nvm.sh'" >> ~/.zshrc
      echo "npm completion >/dev/null 2>&1" >> ~/.zshrc
      # General functions
      echo "clean() { rm -frd \$1 && mkdir \$1 && cd \$1 ; }" >> ~/.zshrc
      # Docker functions
      echo "dip() { docker inspect --format '{{ .NetworkSettings.IPAddress }}' \$1 ; }" >> ~/.zshrc
      echo "docker_rm_all() { docker stop \$(docker ps -a -q) && docker rm \$(docker ps -a -q) ; }" >> ~/.zshrc
      # Git functions
      echo "set_git_user() { git config --global user.name \$1 ; }" >> ~/.zshrc
      echo "set_git_email() { git config --global user.email \$1 ; }" >> ~/.zshrc
      # Aliases
      echo "alias did=\"vim + 'normal Go' +'r!date' ~/did.txt\"" >> ~/.zshrc
      echo 'alias rf="rm -frd"' >> ~/.zshrc
      # External functions
      echo "source ${SCRIPT_FOLDER}/functions.sh" >> ~/.zshrc
    else
      log 'Failed to find .zshrc file'
    fi
}

fix_ssh_key_permissions() {
    prevent_root "$0"
    KEY_NAME=${1:-id_rsa}
    chmod 600 ~/.ssh/"${KEY_NAME}"
    chmod 600 ~/.ssh/"${KEY_NAME}".pub
}

fix_enospc_issue() {
    echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p >/dev/null 2>&1
}

install_atom() {
    set_verbosity "$1"
    log "Installing Atom editor"
    run add-apt-repository -y ppa:webupd8team/atom
    run apt-get update
    run apt-get install -y atom
}

install_cairo() {
    set_verbosity "$1"
    log "Installing Cairo"
    run apt-get install -y libcairo2-dev libjpeg8-dev libpango1.0-dev libgif-dev build-essential g++
}

install_clojure() {
    prevent_root "$0"
    set_verbosity "$1"
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
        run npm install -g lumo-cljs
    fi
    if type apm >/dev/null 2>&1; then
        log "Installing Clojure Atom plugins"
        run apm install parinfer lisp-paredit
    fi
}

install_couchdb() {
    set_verbosity "$1"
    log "Installing CouchDB"
    run apt-get install -y curl
    run apt-get install -y couchdb
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
    set_verbosity "$1"
    log "Preparing Docker dependencies"
    update
    run apt-get install apt-transport-https ca-certificates curl software-properties-common -y
    run curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    run apt-key fingerprint 0EBFCD88
    run add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
    update
    log "Installing Docker CE"
    run apt-get install docker-ce -y
}

install_docker_compose() {
    set_verbosity "$1"
    log "Installing Docker Compose"
    run curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-"$(uname -s)"-"$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
}

install_dotnet() {
    set_verbosity "$1"
    log "Registering Microsoft key and feed"
    run wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
    run dpkg -i packages-microsoft-prod.deb
    log "Installing dependencies"
    run apt-get install apt-transport-https -y
    update
    log "Installing .NET SDK"
    run apt-get install dotnet-sdk-2.1 -y --allow-unauthenticated
    rm -frd packages-microsoft-prod.deb
}

install_firacode() {
    prevent_root "$0"
    set_verbosity "$1"
    log "Installing Fira Code font"
    fonts_dir="${HOME}/.local/share/fonts"
    if [ ! -d "${fonts_dir}" ]; then
        run echo "Creating fonts directory"
        run mkdir -p "${fonts_dir}"
    else
        run echo "Found fonts dir: $fonts_dir"
    fi
    for type in Bold Light Medium Regular Retina; do
        file_path="${HOME}/.local/share/fonts/FiraCode-${type}.ttf"
        file_url="https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-${type}.ttf?raw=true"
        if [ ! -e "${file_path}" ]; then
            log "Downloading font - ${type}"
            run wget -O "${file_path}" "${file_url}"
        else
            log "✔ Found existing file: ${type}"
        fi;
    done
    run echo "Running fc-cache"
    run fc-cache -f
}

install_fsharp() {
    set_verbosity "$1"
    install_mono
    log "Installing F#"
    run apt-get install fsharp -y
}

install_heroku() {
    set_verbosity "$1"
    log "Installing Heroku CLI"
    run add-apt-repository "deb https://cli-assets.heroku.com/branches/stable/apt ./"
    run curl -L https://cli-assets.heroku.com/apt/release.key | apt-key add -
    update
    run apt-get install heroku
}

install_ionide() {
    prevent_root "$0"
    set_verbosity "$1"
    if type code >/dev/null 2>&1; then
        log "Installing Ionide IDE"
        run code --install-extension Ionide.Ionide-fsharp
    else
        echo "✘ Ionide requires VS Code. Please install VS Code."
    fi
}

install_java8() {
    set_verbosity "$1"
    log "Installing JRE and JDK"
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
    run add-apt-repository -y ppa:webupd8team/java
    run apt-get update
    run apt-get install -y oracle-java8-installer
}

install_jenkins() {
    set_verbosity "$1"
    log "Preparing to install Jenkins"
    run wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
    run sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
    run apt-get update
    log "Installing Jenkins"
    run apt-get install -y jenkins
}

install_julia() {
    set_verbosity "$1"
    log "Adding Julia language PPA"
    run apt-get install -y software-properties-common python-software-properties
    run add-apt-repository -y ppa:staticfloat/juliareleases
    run add-apt-repository -y ppa:staticfloat/julia-deps
    run apt-get update
    log "Installing Julia language"
    run apt-get install -y julia
}

install_lein() {
    prevent_root "$0"
    set_verbosity "$1"
    log "Installing lein"
    mkdir -p "${HOME}"/bin
    run curl -L https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -o "${HOME}"/bin/lein
    chmod a+x "${HOME}"/bin/lein
    run lein
    if [ -f "${SCRIPT_FOLDER}/profiles.clj" ]; then
        mkdir -p "$HOME"/.lein
        mv "${SCRIPT_FOLDER}"/profiles.clj "${HOME}"/.lein
    fi
}

install_mesa() {
    set_verbosity "$1"
    log "Installing mesa"
    run apt-add-repository ppa:xorg-edgers
    run apt-get update
    run apt-get install libdrm-dev
    run apt-get build-dep mesa
    wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key|sudo apt-key add -
    run apt-get install -y clang-3.6 clang-3.6-doc libclang-common-3.6-dev
    run apt-get install -y libclang-3.6-dev libclang1-3.6 libclang1-3.6-dbg
    run apt-get install -y libllvm-3.6-ocaml-dev libllvm3.6 libllvm3.6-dbg
    run apt-get install -y lldb-3.6 llvm-3.6 llvm-3.6-dev llvm-3.6-doc
    run apt-get install -y llvm-3.6-examples llvm-3.6-runtime clang-modernize-3.6
    run apt-get install -y clang-format-3.6 python-clang-3.6 lldb-3.6-dev
    run apt-get install -y libx11-xcb-dev libx11-xcb1 libxcb-glx0-dev libxcb-dri2-0-dev
    run apt-get install -y libxcb-dri3-dev libxshmfence-dev libxcb-sync-dev llvm
}

install_mongodb() {
    set_verbosity "$1"
    log "Installing MongoDB"
    run apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
    echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list >/dev/null 2>&1
    run apt-get update
    run apt-get install -y mongodb-org
    # Change config file to allow external connections
    run sed -i '/bind_ip/c # bind_ip = 127.0.0.1' /etc/mongod.conf
    # Change default port to 8000
    #sudo sed -i '/#port/c port = 8000' /etc/mongod.conf >/dev/null 2>&1
    run service mongod restart
    #The default port can be changed by editing /etc/mongod.conf
}

install_mono() {
    set_verbosity "$1"
    log "Adding mono repository"
    run apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
    # echo "deb http://download.mono-project.com/repo/ubuntu stable-trusty main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list >/dev/null 2>&1
    echo "deb https://download.mono-project.com/repo/ubuntu stable-xenial main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list >/dev/null 2>&1
    run apt-get install apt-transport-https --yes
    update
    log "Installing mono"
    run apt-get install mono-devel -y --force-yes
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
    set_verbosity "$1"
    log "Installing OPAM"
    run wget -q https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh -O - | sh -s /usr/local/bin
}

install_pandoc() {
    set_verbosity "$1"
    log "Installing Pandoc"
    run apt-get install -y texlive texlive-latex-extra pandoc
}

install_planck() {
    set_verbosity "$1"
    log "Adding Planck Clojure REPL PPA"
    run add-apt-repository ppa:mfikes/planck -y
    run apt-get update
    log "Installing Planck"
    run apt-get install -y planck
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
    npm install -g grunt-cli yo plato nodemon stmux
    npm install -g flow-bin flow-typed
    npm install -g snyk ntl nsp npm-check-updates npmrc grasp tldr stacks-cli thanks release surge now
}

install_powerline_font() {
    prevent_root "$0"
    set_verbosity "$1"
    log "Installing powerline font"
    run wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
    run wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
    mkdir ~/.fonts/
    mkdir -p ~/.config/fontconfig/conf.d/
    mv PowerlineSymbols.otf ~/.fonts/
    run fc-cache -vf ~/.fonts/
    mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
}

install_python() {
    set_verbosity "$1"
    log "Installing advanced Python support"
    run apt-get install -y libzmq3-dev python-pip python-dev
    run apt-get install -y libblas-dev libatlas-base-dev liblapack-dev gfortran libfreetype6-dev libpng-dev
    run pip install --upgrade pip
    run pip install --upgrade virtualenv
    run pip install ipython[notebook]
}

install_R() {
    set_verbosity "$1"
    log "Installing R"
    run add-apt-repository ppa:marutter/rrutter -y
    run apt-get update -y
    run apt-get upgrade -y
    run apt-get install -y r-base
}

install_reason() {
    prevent_root "$0"
    set_verbosity "$1"
    log "Installing ReasonML support"
    run npm install -g reason-cli@3.1.0-linux bs-platform create-react-app
    if type apm >/dev/null 2>&1; then
        log "Installing Atom ReasonML language support"
        run apm install language-reason language-ocaml
    fi
    if type code >/dev/null 2>&1; then
        log "Installing VS Code ReasonML IDE"
        run code --install-extension freebroccolo.reasonml
    fi
}

install_redis() {
    set_verbosity "$1"
    log "Installing redis"
    run apt-get install -y redis-server
    #Configure redis-server to accept remote connections
    sed -i 's/bind 127.0.0.1/bind 0.0.0.0/' /etc/redis/redis.conf
    run service redis-server restart
    #The default port can be changed by editing /etc/redis/redis.conf
}

install_rlwrap() {
    set_verbosity "$1"
    log "Installing rlwrap"
    run git clone https://github.com/hanslub42/rlwrap.git
    cd rlwrap || return
    run autoreconf --install
    run ./configure
    run make
    make check
    run make install
    cd ..
    rm -frd rlwrap
}

install_rust() {
    prevent_root "$0"
    set_verbosity "$1"
    log "Installing Rust"
    run curl https://sh.rustup.rs -sSf | sh -s -- -y
    echo "source ${HOME}/.cargo/env" >> ~/.zshrc
    # shellcheck disable=SC1090,SC1091
    . "${HOME}"/.cargo/env
    run rustup toolchain install nightly
    run rustup target add wasm32-unknown-unknown --toolchain nightly
    if type apm >/dev/null 2>&1; then
        log "Installing Atom Rust IDE"
        run apm install ide-rust
    fi
    log "Installing wasm-gc"
    run cargo install --git https://github.com/alexcrichton/wasm-gc
    log "Installing wasm-bindgen"
    run cargo install wasm-bindgen-cli
    log "Installing just"
    run cargo install just
    log "Installing tokei (line counting CLI tool)"
    run cargo install tokei
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
    set_verbosity "$1"
    run curl -s https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' >/dev/null 2>&1
    update
    log "Installing VSCode"
    run apt-get install code -y --force-yes
}

install_vscode_extensions() {
    prevent_root "$0"
    if type code >/dev/null 2>&1; then
        code --install-extension 2gua.rainbow-brackets
        code --install-extension akamud.vscode-theme-onedark
        code --install-extension bierner.color-info
        code --install-extension bierner.lit-html
        code --install-extension christian-kohler.path-intellisense
        code --install-extension cssho.vscode-svgviewer
        code --install-extension deerawan.vscode-faker
        code --install-extension emmanuelbeziat.vscode-great-icons
        code --install-extension kisstkondoros.vscode-gutter-preview
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

log() {
    TIMEZONE=Central
    MAXLEN=50
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

run() {
    if $VERBOSE; then
        "$@"
    else
        "$@" &>/dev/null
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
    set_verbosity "$1"
    log "Updating"
    run apt-key update
    run apt-get update
}
