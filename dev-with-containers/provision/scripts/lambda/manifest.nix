{ pkgs ? import <nixpkgs> {} }:
with pkgs; [
    elan
    # jupyter
    nodejs_20
    opam
    ruby
    wget
]