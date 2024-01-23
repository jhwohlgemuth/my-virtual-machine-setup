{ pkgs ? import <nixpkgs> {} }:
with pkgs; [
    asdf-vm
    ast-grep
    bat
    btop
    direnv
    du-dust
    grex
    gum
    ripgrep
    thefuck
    up
    yq
]