#! /bin/bash

main() {
    requires \
        dotnet \
        jupyter \
        zsh
    dotnet tool install --global Microsoft.dotnet-interactive
    dotnet interactive jupyter install
    # shellcheck disable=SC2016
    echo 'export PATH="${PATH}:/root/.dotnet/tools"' >> "${HOME}/.zshrc"
}
main "$@"