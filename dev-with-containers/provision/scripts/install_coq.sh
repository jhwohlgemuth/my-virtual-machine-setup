#! /bin/sh
#
# Install Coq language and packages
#
opam repo add coq-released https://coq.inria.fr/opam/released
opam repo add coq-core-dev https://coq.inria.fr/opam/core-dev
opam repo add coq-extra-dev https://coq.inria.fr/opam/extra-dev
opam pin add coq "${COQ_VERSION:-8.18.0}"
opam install --yes \
    coq-hammer \
    vscoq-language-server
#
# Install Jupyter kernel
#
if type /opt/conda/bin/mamba >/dev/null 2>&1; then
    /opt/conda/bin/mamba create \
        --name coq \
        --channel conda-forge \
        --yes \
        python=3.10 \
        coq-jupyter=1.6.0
    /opt/conda/bin/mamba clean -yaf
else
    echo "==> [WARN] mamba is NOT installed"
fi
#
# Install Aeneas, Creusot, and coq-of-rust 
#
echo "WIP"