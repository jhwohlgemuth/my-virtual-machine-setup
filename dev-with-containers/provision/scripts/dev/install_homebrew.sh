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
        pkgxdev/made/pkgx \
        pixi
    /home/linuxbrew/.linuxbrew/bin/brew cleanup --prune=all
    eval "$(pkgx integrate)"
}
main "$@"