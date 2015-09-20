#!/usr/bin/env bash
printf "Installing Oh-My-Zsh..."$(date '+%T')
sudo apt-get install -y zsh >/dev/null 2>&1
sudo chsh -s $(which zsh) $(whoami)
sudo curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash -s >/dev/null 2>&1
sudo chsh -s $(which zsh) $(whoami)
