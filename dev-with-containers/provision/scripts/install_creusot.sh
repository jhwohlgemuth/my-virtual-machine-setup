#! /bin/bash
set -e

requires \
    cargo \
    git \
    why3 \
    z3
main() {
    #
    # Install Creusot
    #
    cd / || exit
    git clone https://github.com/xldenis/creusot
    cd /creusot
    cargo install --path cargo-creusot
    cargo install --path creusot-rustc
    cd "${HOME}" || exit
}
main "$@"