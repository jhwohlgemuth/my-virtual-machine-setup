#! /bin/bash
set -e

requires \
    cargo \
    git \
    opam
main() {
    export OPAMYES=1
    #
    # Install opam dependencies
    #
    opam install \
        core_unix \
        easy_logging \
        ocamlgraph \
        odoc \
        ppx_deriving \
        unionFind \
        visitors \
        yojson \
        zarith
    eval "$(opam env)"
    #
    # Install Charon and Aeneas
    #
    mkdir -p /aeneas-toolchain && cd /aeneas-toolchain || exit
    git clone https://github.com/AeneasVerif/charon
    git clone https://github.com/AeneasVerif/aeneas
    cd /aeneas-toolchain/aeneas/compiler && ln -s /aeneas-toolchain/charon/charon-ml charon
    if [ -e charon ] ; then
        cd /aeneas-toolchain/aeneas && make
        chmod +x ./bin/aeneas
        mv ./bin/aeneas /usr/local/bin
    else
        echo "==> [ERROR] Invalid charon link"
    fi
    cd "${HOME}" || exit
    #
    # Install coq-of-rust
    #
    cd / || exit
    git clone https://github.com/formal-land/coq-of-rust
    cd /coq-of-rust && cargo install --path lib/
    cd "${HOME}" && rm -frd /coq-of-rust
}
main "$@"