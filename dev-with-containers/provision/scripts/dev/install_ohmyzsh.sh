#! /bin/bash
set -e

requires curl
main() {
    #
    # Install oh-my-zsh
    #
    sh -c "$(curl https://raw.githubusercontent.com/deluan/zsh-in-docker/master/zsh-in-docker.sh)" -- \
        -p colored-man-pages \
        -p encode64 \
        -p fzf \
        -p git \
        -p history-substring-search \
        -p wd \
        -p https://github.com/zsh-users/zsh-autosuggestions \
        -p https://github.com/zsh-users/zsh-syntax-highlighting \
        -p https://github.com/conda-incubator/conda-zsh-completion \
        -p https://github.com/jhwohlgemuth/zsh-handy-helpers \
        -p https://github.com/jhwohlgemuth/zsh-pentest
}
main "$@"