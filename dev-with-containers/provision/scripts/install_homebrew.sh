#! /bin/bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# shellcheck disable=SC2016
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "${HOME}/.zshrc"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install \
    asdf \
    ast-grep \
    bat \
    broot \
    btop \
    direnv \
    dust \
    grex \
    pkgxdev/made/pkgx \
    pipx \
    pixi \
    ripgrep \
    thefuck \
    tokei \
    up \
    yq
eval "$(pkgx integrate)"
/home/linuxbrew/.linuxbrew/bin/brew cleanup --prune=all
# shellcheck disable=SC2016
{
    echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" 
    echo 'eval "$(direnv hook zsh)"'
    echo 'eval "$(thefuck --alias oops)"'
    echo 'alias sgrep=ast-grep'
} >> "${HOME}/.zshrc"