{ pkgs ? import <nixpkgs> {} }:
with pkgs; [
    asdf-vm
    ast-grep
    bat
    btop
    direnv
    du-dust
    grex
    pipx
    ripgrep
    thefuck
    up
    yq
]