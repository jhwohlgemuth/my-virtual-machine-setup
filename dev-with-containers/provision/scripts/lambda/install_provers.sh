#! /bin/bash
set -e

requires \
    git \
    opam
main() {
    export OPAMYES=1
    #
    # Install Alt-Ergo (free)
    #
    opam install alt-ergo-free
    eval "$(opam env)"
    #
    # Install CVC5
    #
    cd /usr/bin || exit
    curl -o cvc5 -LJ https://github.com/cvc5/cvc5/releases/download/cvc5-1.0.8/cvc5-Linux
    chmod +x cvc5
    cd /root || exit
    #
    # Install eprover
    #
    mkdir -p /eprover && cd /eprover || exit
    git clone https://github.com/eprover/eprover.git
    cd eprover && ./configure && make -j8 && make install
    mv PROVER/* /usr/bin
    cd /root && rm -frd /eprover
    #
    # Install Vampire
    #
    mkdir -p /vampire && cd /vampire || exit
    curl -o source.zip -LJ https://github.com/vprover/vampire/releases/download/snakeForV4.7%2B/vampire-snake-static4starexec.zip
    unzip source.zip
    mv bin/* /usr/bin/
    cd /root && rm -frd /vampire
    #
    # Install Z3
    #
    mkdir -p /z3 && cd /z3 || exit
    git clone https://github.com/Z3Prover/z3
    cd z3 && python scripts/mk_make.py && cd build && make -j8 && make install
    cd /root && rm -frd /z3
    #
    # Install Why3 and add provers
    #
    opam install why3
    eval "$(opam env)"
    why3 config detect
}
main "$@"