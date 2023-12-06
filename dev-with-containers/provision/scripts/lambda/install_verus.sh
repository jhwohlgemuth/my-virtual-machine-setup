#! /bin/bash
set -e

requires \
    git \
    wget
main() {
    #
    # Install Verus
    #
    cd / || exit
    git clone https://github.com/verus-lang/verus
    chmod +x /verus/tools/activate
    /verus/tools/activate
    cd /verus/source
    ./tools/get-z3.sh
    /verus/tools/vargo/target/release/vargo build --release
    ln -s /verus/source/target-verus/release/verus /usr/local/bin/verus
    #
    # Test Verus installation
    #
    verus /verus/source/rust_verify/example/vectors.rs
}
main "$@"