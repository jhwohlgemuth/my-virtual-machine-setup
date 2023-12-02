#! /bin/bash
set -e

requires \
    jupyter \
    libgmp-dev \
    libzmq5 \
    libzmq3-dev \
    opam \
    pkg-config \
    ruby
main() {
    export OPAMYES=1
    # ocaml-jupyter does not support OCaml 5.0
    # See https://github.com/akabe/ocaml-jupyter/pull/199
    opam init --compiler="${OCAML_VERSION:-4.14.1}" --disable-sandboxing --yes
    eval "$(opam env)"
    # shellcheck disable=SC2016
    echo 'eval "$(opam env)"' >> "${HOME}/.zshrc"
    opam install \
        dune \
        ocaml-lsp-server \
        odoc \
        ocamlformat \
        utop
    eval "$(opam env)"
    opam upgrade
    eval "$(opam env)"
    #
    # Install Jupyter kernel
    #
    opam install jupyter
    eval "$(opam env)"
    ocaml-jupyter-opam-genspec
    jupyter kernelspec install --name "OCaml" "$(opam var share)/jupyter"
    sed -i 's/OCaml default/OCaml/' /usr/local/share/jupyter/kernels/ocaml/kernel.json
}
main "$@"