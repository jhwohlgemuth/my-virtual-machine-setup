#! /bin/sh

apt-get update
apt-get install --no-install-recommends -y ocaml opam
opam init --disable-sandboxing --yes
eval $(opam env)
echo 'eval $(opam env)' >> "${HOME}/.zshrc"
opam install jupyter merlin dune --yes
eval $(opam env)
opam upgrade
eval $(opam env)
#
# Install Jupyter kernel
#
ocaml-jupyter-opam-genspec
jupyter kernelspec install --name "OCaml" "$(opam var share)/jupyter"
sed -i 's/OCaml default/OCaml/' /usr/local/share/jupyter/kernels/ocaml/kernel.json