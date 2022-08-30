#! /bin/sh

#
# Install oh-my-zsh
#
sh -c "$(curl https://raw.githubusercontent.com/deluan/zsh-in-docker/master/zsh-in-docker.sh)" -- \
    -p colored-man-pages \
    -p encode64 \
    -p extract \
    -p fzf \
    -p git \
    -p history-substring-search \
    -p wd \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -p https://github.com/jhwohlgemuth/zsh-handy-helpers \
    -p https://github.com/jhwohlgemuth/zsh-pentest \
    -a 'bindkey "\$terminfo[kcuu1]" history-substring-search-up' \
    -a 'bindkey "\$terminfo[kcud1]" history-substring-search-down'
#
# Customize .zshrc
#
sed -i "s/export TERM=xterm/export TERM=xterm-256color/g" ~/.zshrc
echo "ZLE_RPROMPT_INDENT=0" >> ~/.zshrc
echo "alias bat=batcat" >> ~/.zshrc
echo "alias python=python3" >> ~/.zshrc
echo "alias pip=pip3" >> ~/.zshrc