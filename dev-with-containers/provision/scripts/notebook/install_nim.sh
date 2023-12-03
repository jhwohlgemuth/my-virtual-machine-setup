#! /bin/bash
set -e

requires \
    curl \
    libzmq5
main() {
    curl https://nim-lang.org/choosenim/init.sh -sSf > init.sh
    sh init.sh -y
    rm init.sh
    export PATH="${PATH}:/root/.nimble/bin"
    choosenim stable
    nimble install jupyternim -y
    # shellcheck disable=SC2016
    echo 'export PATH="${PATH}:/root/.nimble/bin"' >> "${HOME}/.zshrc"
}
main "$@"