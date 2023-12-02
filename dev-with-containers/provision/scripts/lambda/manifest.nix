{ pkgs ? import <nixpkgs> {} }:
with pkgs; [
    elan
    nodejs_20
    opam
    ruby
    wget
]