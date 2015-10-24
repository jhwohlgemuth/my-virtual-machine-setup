#!/usr/bin/env bash
#This line makes the script work on POSIX systems even if edited on Windows
sed -i 's/\r//' fun.sh
#Source install functions
. ./fun.sh

log "Installing nvm"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash >/dev/null 2>&1

log "Installing Atom plugins"
apm install file-icons sublime-block-comment atom-beautify >/dev/null 2>&1
apm install minimap minimap-codeglance minimap-selection minimap-find-and-replace minimap-git-diff >/dev/null 2>&1
apm install hydrogen nuclide-installer >/dev/null 2>&1

if type julia >/dev/null 2>&1; then
    log "Installing IJulia"
    julia -e 'Pkg.add("IJulia")' >/dev/null 2>&1
fi

log "Patching agnoster theme fonts"
wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf >/dev/null 2>&1
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf >/dev/null 2>&1
mkdir ~/.fonts/
mkdir -p ~/.config/fontconfig/conf.d/
mv PowerlineSymbols.otf ~/.fonts/
fc-cache -vf ~/.fonts/ >/dev/null 2>&1
mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/