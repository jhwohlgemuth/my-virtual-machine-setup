#! /bin/bash

function requires {
    for ARG in "${ARGS[@]}"; do
        if type "${ARG}" >/dev/null 2>&1; then
            pass
        else
            echo "==> [ERROR] ${ARG} not found"
            exit 1
        fi
    done
}
function install_dotnet_kernel {
    requires dotnet jupyter zsh
    dotnet tool install --global Microsoft.dotnet-interactive
    dotnet interactive jupyter install
    # shellcheck disable=SC2016
    echo 'export PATH="${PATH}:/root/.dotnet/tools"' >> "${HOME}/.zshrc"
}