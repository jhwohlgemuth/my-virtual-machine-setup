#!/usr/bin/env bash
TIMEZONE=Central
echo "Installing nvm...................."$(TZ=":US/$TIMEZONE" date +%T)
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash >/dev/null 2>&1

echo "Installing Atom plugins..........."$(TZ=":US/$TIMEZONE" date +%T)
apm install file-icons sublime-block-comment atom-beautify
apm install minimap minimap-codeglance minimap-selection minimap-find-and-replace minimap-git-diff
apm install hydrogen nuclide-installer

if type julia >/dev/null 2>&1; then
    echo "Installing IJulia................."$(TZ=":US/$TIMEZONE" date +%T)
    julia -e 'Pkg.add("IJulia")' >/dev/null 2>&1
fi

echo "Patching agnoster theme fonts....."$(TZ=":US/$TIMEZONE" date +%T)
wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf >/dev/null 2>&1
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf >/dev/null 2>&1
mkdir ~/.fonts/
mkdir -p ~/.config/fontconfig/conf.d/
mv PowerlineSymbols.otf ~/.fonts/
fc-cache -vf ~/.fonts/
mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/