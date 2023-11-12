#! /bin/sh

apt-get update
apt-get install --no-install-recommends -y opam ruby-full
opam init --compiler=${OCAML_VERSION} --disable-sandboxing --yes
eval $(opam env)
echo 'eval $(opam env)' >> "${HOME}/.zshrc"
opam install dune ocaml-lsp-server odoc ocamlformat utop --yes
eval $(opam env)
opam upgrade
eval $(opam env)
#
# Install Jupyter kernel
#
opam install jupyter --yes
eval $(opam env)
ocaml-jupyter-opam-genspec
jupyter kernelspec install --name "OCaml" "$(opam var share)/jupyter"
sed -i 's/OCaml default/OCaml/' /usr/local/share/jupyter/kernels/ocaml/kernel.json