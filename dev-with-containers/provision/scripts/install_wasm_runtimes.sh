#! /bin/bash
set -e

requires \
    brew \
    cargo \
    curl \
    rustup
main() {
    #
    # Install Rust WASM/WASI targets and tools
    #
    rustup target add wasm32-wasi
    rustup target add wasm32-unknown-unknown --toolchain nightly
    cargo install \
        cargo-wasi \
        wasm-bindgen-cli \
        wasm-pack
    #
    # Cosmonic (cosmo)
    #
    bash -c "$(curl -fsSL https://cosmonic.sh/install.sh)"
    # shellcheck disable=SC2016
    echo 'export PATH="/root/.cosmo/bin:${PATH}"' >> "${HOME}/.zshrc"
    #
    # Scale
    #
    curl -fsSL https://dl.scale.sh | sh
    #
    # Spin microservices server (spin)
    #
    cd /usr/local/bin || exit
    curl -fsSL https://developer.fermyon.com/downloads/install.sh | bash
    rm -frd crt.pem LICENSE README.md spin.sig
    #
    # WASM workers server (wws)
    #
    cd /usr/local/bin || exit
    curl -fsSL https://workers.wasmlabs.dev/install | bash -s -- --local
    #
    # WasmEdge
    #
    curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash
    # shellcheck disable=SC2016
    echo '. "${HOME}/.wasmedge/env"' >> "${HOME}/.zshrc"
    #
    # WAsmCloud SHell (wash)
    #
    curl -s https://packagecloud.io/install/repositories/wasmcloud/core/script.deb.sh | sudo bash
    apt-get install --no-install-recommends -y wash
    cleanup
    #
    # wasmtime
    #
    curl https://wasmtime.dev/install.sh -sSf | bash
    # shellcheck disable=SC2016
    echo 'export WASMTIME_HOME="${HOME}/.wasmtime"' >> "${HOME}/.zshrc"
    # shellcheck disable=SC2016
    echo 'export PATH="${WASMTIME_HOME}/bin:${PATH}"' >> "${HOME}/.zshrc"
    #
    # wazero
    #
    curl https://wazero.io/install.sh | sh
    #
    # wasmer, wapm, and wasm3
    #
    brew install wasmer wapm wasm3
    brew cleanup --prune=all
}
main "$@"