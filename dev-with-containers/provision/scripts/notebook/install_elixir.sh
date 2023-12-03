#! /bin/bash
set -e

requires \
    asdf \
    curl \
    fop \
    libncurses5 \
    libncurses-dev \
    openssl \
    xsltproc
main() {
    local ERL_VERSION="${ERL_VERSION:-"latest"}"
    local ELIXIR_VERSION="${ELIXIR_VERSION:-"latest"}"
    #
    # Install Erlang/OTP
    #
    asdf plugin add erlang
    asdf install erlang "${ERL_VERSION}"
    asdf global erlang "${ERL_VERSION}"
    #
    # Install Elixir
    #
    asdf plugin add elixir
    asdf install elixir "${ELIXIR_VERSION}"
    asdf global elixir "${ELIXIR_VERSION}"
}
main "$@"