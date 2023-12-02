#! /bin/bash
set -e

requires \
    apt-utils \
    mamba \
    opam
main() {
    #
    # Install Coq language and packages
    #
    opam repo add coq-released https://coq.inria.fr/opam/released
    opam repo add coq-core-dev https://coq.inria.fr/opam/core-dev
    opam repo add coq-extra-dev https://coq.inria.fr/opam/extra-dev
    opam pin add coq "${COQ_VERSION:-8.18.0}" --yes
    opam install --yes \
        coq-hammer \
        vscoq-language-server
    #
    # Install Coq Jupyter kernel
    #
    mamba create \
        --name coq \
        --channel conda-forge \
        --yes \
        python=3.10 \
        coq-jupyter=1.6.0
    mamba clean -yaf
}
main "$@"