#! /bin/bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# shellcheck disable=SC2016
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "${HOME}/.zshrc"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install thefuck up yq
# shellcheck disable=SC2016
echo 'eval "$(thefuck --alias oops)"' >> "${HOME}/.zshrc"