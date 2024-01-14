{ pkgs ? import <nixpkgs> {} }:
with pkgs; [
    asdf-vm
    ast-grep
    bat
    btop
    direnv
    du-dust
    grex
    ripgrep
    thefuck
    up
    yq
]