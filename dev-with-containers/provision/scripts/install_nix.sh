#! /bin/sh
set -e

curl -L https://nixos.org/nix/install | sh -s -- --daemon --yes
# shellcheck disable=SC1091
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi