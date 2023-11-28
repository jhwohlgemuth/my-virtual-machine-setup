let
    pkgs = import <nixpkgs> {};
in
    {    
        packages = [
            pkgs.bun
            pkgs.htmlq
            pkgs.nodejs_20
            pkgs.elmPackages.elm
        ];
    }