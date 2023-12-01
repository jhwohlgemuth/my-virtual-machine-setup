{ pkgs ? import <nixpkgs> {} }:
with pkgs; [
    bun
    elmPackages.elm
    htmlq
    nodejs_20
]