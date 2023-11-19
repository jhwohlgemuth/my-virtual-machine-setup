#! /bin/sh
set -e
#
# Install Rust WASM/WASI targets and tools
#
if rustup >/dev/null 2>&1; then
    rustup target add wasm32-wasi
    rustup target add wasm32-unknown-unknown --toolchain nightly
    cargo install \
        cargo-wasi \
        wasm-bindgen-cli \
        wasm-pack
else
    echo "==> [WARN] rustup is NOT installed"
fi
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
if type /home/linuxbrew/.linuxbrew/bin/brew >/dev/null 2>&1; then
    /home/linuxbrew/.linuxbrew/bin/brew install wasmer wapm wasm3
    /home/linuxbrew/.linuxbrew/bin/brew cleanup --prune=all
else
    echo "==> [WARN] brew is NOT installed"
fi
