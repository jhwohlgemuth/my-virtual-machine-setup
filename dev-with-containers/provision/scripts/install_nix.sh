#! /bin/sh
set -e
#
# install Nix
#
curl -L https://nixos.org/nix/install | sh -s -- --daemon --yes
# shellcheck disable=SC1091
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
#
# Enable experimental features
#
echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf
#
# Customize Nix shell
#
{
  echo "export NIX_SHELL_PRESERVE_PROMPT=1"
  echo "alias nix-shell='nix-shell --run zsh'"
} >> "${HOME}/.zshrc"