#! /bin/bash
set -e

requires \
    git \
    libncurses5 \
    libncurses-dev \
    libsqlite3-dev \
    libssl-dev \
    libzmq3-dev \
    mix \
    openssl
main() {
    #
    # Install IElixir
    #
    cd /opt || exit
    git clone https://github.com/pprzetacznik/IElixir.git
    cd IElixir || exit
    mix local.hex --force
    mix local.rebar --force
    mix deps.get
    mix deps.compile
    mix deps.update erlzmq
    sed -i 's/python/python3/g' install_script.sh
    ./install_script.sh
}
main "$@"