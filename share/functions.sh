#!/usr/bin/env bash
check_sudo() {
    if [[ $(whoami) != root ]]; then
        echo "root privileges are required!"
        echo "use sudo -s before sourcing functions.sh and try again as root"
        exit 0
    fi
}

install_atom() {
    log "Installing Atom editor"
    add-apt-repository -y ppa:webupd8team/atom >/dev/null 2>&1
    apt-get update >/dev/null 2>&1
    apt-get install -y atom >/dev/null 2>&1
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
}

install_desktop() {
    log "Installing desktop"
    SSH_USER=${SSH_USERNAME:-vagrant}
    USERNAME=${SSH_USER}
    LIGHTDM_CONFIG=/etc/lightdm/lightdm.conf
    GDM_CUSTOM_CONFIG=/etc/gdm/custom.conf
    apt-get install -y --no-install-recommends ubuntu-desktop >/dev/null 2>&1
    apt-get install -y gnome-terminal overlay-scrollbar gnome-session-fallback >/dev/null 2>&1
    apt-get install -y firefox chromium-browser indicator-multiload >/dev/null 2>&1
    apt-get install -y figlet toilet >/dev/null 2>&1
    mkdir -p $(dirname ${GDM_CUSTOM_CONFIG})
    echo "[daemon]" >> $GDM_CUSTOM_CONFIG
    echo "# Enabling automatic login" >> $GDM_CUSTOM_CONFIG
    echo "AutomaticLoginEnable=True" >> $GDM_CUSTOM_CONFIG
    echo "AutomaticLoginEnable=${USERNAME}" >> $GDM_CUSTOM_CONFIG
    echo "==> Configuring lightdm autologin"
    echo "[SeatDefaults]" >> $LIGHTDM_CONFIG
    echo "autologin-user=${USERNAME}" >> $LIGHTDM_CONFIG
}

install_java8() {
    log "Installing JRE and JDK"
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
    add-apt-repository -y ppa:webupd8team/java >/dev/null 2>&1
    apt-get update >/dev/null 2>&1
    apt-get install -y oracle-java8-installer >/dev/null 2>&1
}

install_jenkins() {
    # Jenkins will be launched as a daemon up on start.
    # See /etc/init.d/jenkins for more details.
    # The 'jenkins' user is created to run this service.
    # Log file will be placed in /var/log/jenkins/jenkins.log.
    # Check this file if you are troubleshooting Jenkins.
    # /etc/default/jenkins will capture configuration parameters for the launch like e.g JENKINS_HOME
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
}

install_pandoc() {
    log "Installing Pandoc"
    apt-get install -y texlive texlive-latex-extra pandoc >/dev/null 2>&1
}

install_python() {
    log "Installing Python"
    apt-get install -y libzmq3-dev python-pip python-dev >/dev/null 2>&1
    apt-get install -y libblas-dev libatlas-base-dev liblapack-dev gfortran libfreetype6-dev libpng-dev >/dev/null 2>&1
    pip install --upgrade pip
    pip install --upgrade virtualenv
    pip install ipython[notebook] >/dev/null 2>&1
}

install_redis() {
    log "Installing redis"
    apt-get install -y redis-server >/dev/null 2>&1
    #Configure redis-server to accept remote connections
    sed -i 's/bind 127.0.0.1/bind 0.0.0.0/' /etc/redis/redis.conf
    service redis-server restart >/dev/null 2>&1
}

update() {
    log "Updating"
    apt-get update >/dev/null 2>&1
}

log() {
    TIMEZONE=Central
    MAXLEN=35
    MSG=$1
    for i in $(seq ${#MSG} $MAXLEN)
    do
        MSG=$MSG.
    done
    echo $MSG$(TZ=":US/$TIMEZONE" date +%T)
}

fix_ssh_key_permissions() {
    chmod 600 ~/.ssh/id_rsa
    chmod 600 ~/.ssh/id_rsa.pub
}