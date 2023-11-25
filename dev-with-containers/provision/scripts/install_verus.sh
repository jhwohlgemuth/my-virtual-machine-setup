#! /bin/bash
set -e

requires \
    direnv \
    git \
    wget
main() {
    #
    # Install Verus
    #
    cd / || exit
    git clone https://github.com/verus-lang/verus
    direnv enable verus
    cd /verus/source
    ./tools/get-z3.sh
    vargo build --release
    ln -s /verus/source/target-verus/release/verus /usr/local/bin/verus
    #
    # Test Verus installation
    #
    verus /verus/source/rust_verify/example/vectors.rs
}
main "$@"