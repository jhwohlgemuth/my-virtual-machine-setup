#!/usr/bin/env bash
if [[ $(whoami) == "root" ]]; then
    echo "✘ Script should not be run as root"
    return 0
fi
main() {
    install_firacode
    install_nvm
    install_rust
}
install_firacode() {
    log "Installing Fira Code font"
    fonts_dir="${HOME}/.local/share/fonts"
    if [ ! -d "${fonts_dir}" ]; then
        log "Creating fonts directory"
        mkdir -p "${fonts_dir}"
    else
        log "Found fonts dir: $fonts_dir"
    fi
    for type in Bold Light Medium Regular Retina; do
        file_path="${HOME}/.local/share/fonts/FiraCode-${type}.ttf"
        file_url="https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-${type}.ttf?raw=true"
        if [ ! -e "${file_path}" ]; then
            log "Downloading font - ${type}"
            wget -O "${file_path}" "${file_url}"
        else
            log "✔ Found existing file: ${type}"
        fi;
    done
    log "Running fc-cache"
    fc-cache -f
}
install_nvm() {
    log "Installing nvm"
    curl -so- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash
}
install_rust() {
    log "Installing Rust"
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    echo "source ${HOME}/.cargo/env" >> ~/.zshrc
    # shellcheck disable=SC1090,SC1091
    . "${HOME}"/.cargo/env
    rustup toolchain install nightly
    rustup target add wasm32-unknown-unknown --toolchain nightly
    cargo install cargo-audit
    cargo install cargo-edit
    cargo install tokei
    cargo install wasm-bindgen-cli
}
log() {
    TIMEZONE=Central
    MAXLEN=60
    MSG=$1
    for i in $(seq ${#MSG} $MAXLEN)
    do
        MSG=$MSG.
    done
    MSG=$MSG$(TZ=":US/$TIMEZONE" date +%T)
    echo "$MSG"
}
main
