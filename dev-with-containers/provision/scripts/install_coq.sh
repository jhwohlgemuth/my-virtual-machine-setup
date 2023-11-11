#! /bin/sh

# apt-get update
# apt-get install --no-install-recommends -y coq

#
# Install Provers: eprover, Vampire, Z3
#
echo "WIP"
#
# Install Coq language and packages
#
opam repo add coq-released https://coq.inria.fr/opam/released
opam repo add coq-core-dev https://coq.inria.fr/opam/core-dev
opam repo add coq-extra-dev https://coq.inria.fr/opam/extra-dev
opam pin add coq 8.18.0
opam install coq-hammer coq-lsp
#
# Install Jupyter kernel
#
/opt/conda/bin/mamba create --name coq --channel conda-forge --yes coq-jupyter=1.6.0 python=3.10
/opt/conda/bin/mamba clean -yaf
#
# Install Aeneas, Creusot, and coq-of-rust 
#
RUN echo "WIP"