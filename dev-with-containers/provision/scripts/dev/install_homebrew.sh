#! /bin/bash
set -e

requires curl
main() {
    #
    # Install Homebrew
    #
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    #
    # Install Homebrew packages
    #
    /home/linuxbrew/.linuxbrew/bin/brew install \
        jandedobbeleer/oh-my-posh/oh-my-posh \
        pixi \
        pkgxdev/made/pkgx
    /home/linuxbrew/.linuxbrew/bin/brew cleanup --prune=all
    # shellcheck disable=SC2016
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "${HOME}/.zshrc"
    eval "$(pkgx integrate)"
}
main "$@"