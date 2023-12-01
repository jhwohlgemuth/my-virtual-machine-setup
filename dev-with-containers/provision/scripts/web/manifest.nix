{ pkgs ? import <nixpkgs> {} }:
{
    inherit (pkgs)
        bun
        # elmPackages_elm
        htmlq
        nodejs_20;
}