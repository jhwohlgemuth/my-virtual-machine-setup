#! /bin/bash
set -e

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
    requires dotnet zsh
    dotnet tool install --global Microsoft.dotnet-interactive
    dotnet interactive jupyter install
    echo 'export PATH="${PATH}:/root/.dotnet/tools"' >> "${HOME}/.zshrc"
}