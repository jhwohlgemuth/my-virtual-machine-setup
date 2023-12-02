{ pkgs ? import <nixpkgs> {} }:
with pkgs; [
    autoconf
    nodejs_20
    opam
    ruby
]