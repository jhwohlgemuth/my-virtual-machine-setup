#! /bin/bash
set -e

requires \
    ast-grep \
    direnv \
    fuck \
    locales \
    python3
main() {
    #
    # Customize .zshrc
    #
    locale-gen
    update-locale LANG=${LANG}
    sed -i "/export LC_ALL=/d" "${HOME}/.zshrc"
    sed -i "/export LANG=/d" "${HOME}/.zshrc"
    sed -i "/export LANGUAGE=/d" "${HOME}/.zshrc"
    sed -i "s/export TERM=xterm/export TERM=xterm-256color/g" "${HOME}/.zshrc"
    # shellcheck disable=SC2016
    {
        echo 'bindkey "\$terminfo[kcuu1]" history-substring-search-up'
        echo 'bindkey "\$terminfo[kcud1]" history-substring-search-down'
        echo 'ZLE_RPROMPT_INDENT=0'
        echo 'eval "$(direnv hook zsh)"' >> "${HOME}/.zshrc"
        echo 'eval "$(thefuck --alias oops)"' >> "${HOME}/.zshrc"
        echo "source ${HOME}/.p10k.zsh"
        echo 'alias python=python3'
        echo 'alias pip=pip3'
        echo 'alias sgrep=ast-grep' >> "${HOME}/.zshrc"
    } >> "${HOME}/.zshrc"
}
main "$@"