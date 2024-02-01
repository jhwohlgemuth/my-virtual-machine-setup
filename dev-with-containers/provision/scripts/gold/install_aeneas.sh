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
    cd /aeneas-toolchain/charon && make build-charon-rust build-charon-ml
    mv /aeneas-toolchain/charon/bin/* /usr/local/bin/
    if is_command charon ; then
        cd /aeneas-toolchain/aeneas && make
        chmod +x ./bin/aeneas
        mv ./bin/aeneas /usr/local/bin
        #
        # Install coq-of-rust
        #
        cd / || exit
        git clone https://github.com/formal-land/coq-of-rust
        cd /coq-of-rust && cargo install --path lib/
        cd "${HOME}" && rm -frd /coq-of-rust
    else
        echo "==> [ERROR] Invalid charon link"
        cd / || exit
        rm -frd /aeneas-toolchain
    fi
    cd "${HOME}" || exit
}
main "$@"