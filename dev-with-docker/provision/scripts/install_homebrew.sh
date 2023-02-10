#! /bin/bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# shellcheck disable=SC2016
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "${HOME}/.zshrc"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install \
    broot \
    dust \
    grex \
    htmlq \
    thefuck \
    tokei \
    up \
    yq
# shellcheck disable=SC2016
echo 'eval "$(thefuck --alias oops)"' >> "${HOME}/.zshrc"