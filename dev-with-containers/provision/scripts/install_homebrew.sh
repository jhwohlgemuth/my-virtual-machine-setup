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
        asdf \
        ast-grep \
        bat \
        btop \
        direnv \
        dust \
        grex \
        pkgxdev/made/pkgx \
        pipx \
        pixi \
        ripgrep \
        thefuck \
        up \
        yq
    /home/linuxbrew/.linuxbrew/bin/brew cleanup --prune=all
    # shellcheck disable=SC2016
    {
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
        echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" 
        echo 'eval "$(direnv hook zsh)"'
        echo 'eval "$(thefuck --alias oops)"'
        echo 'alias sgrep=ast-grep'
    } >> "${HOME}/.zshrc"
    eval "$(pkgx integrate)"
}
main "$@"