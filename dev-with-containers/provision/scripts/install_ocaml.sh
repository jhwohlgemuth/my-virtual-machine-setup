#! /bin/sh

apt-get update
apt-get install --no-install-recommends -y autoconf opam ruby-full
opam init --compiler="${OCAML_VERSION:-4.14.1}" --disable-sandboxing --yes
eval "$(opam env)"
# shellcheck disable=SC2016
echo 'eval "$(opam env)"' >> "${HOME}/.zshrc"
opam --yes install \
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
opam install --yes jupyter
eval "$(opam env)"
ocaml-jupyter-opam-genspec
jupyter kernelspec install --name "OCaml" "$(opam var share)/jupyter"
sed -i 's/OCaml default/OCaml/' /usr/local/share/jupyter/kernels/ocaml/kernel.json