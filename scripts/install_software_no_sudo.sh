#!/usr/bin/env bash
echo "Installing nvm..................."$(date '+%T')
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash

echo "Installing Atom plugins.........."$(date '+%T')
apm install file-icons sublime-block-comment atom-beautify
apm install minimap minimap-codeglance minimap-selection minimap-find-and-replace
apm install hydrogen nuclide-installer

echo "Patching agnoster theme fonts...."$(date '+%T')
wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf >/dev/null 2>&1
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf >/dev/null 2>&1
mkdir ~/.fonts/
mkdir -p ~/.config/fontconfig/conf.d/
mv PowerlineSymbols.otf ~/.fonts/
fc-cache -vf ~/.fonts/
mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/