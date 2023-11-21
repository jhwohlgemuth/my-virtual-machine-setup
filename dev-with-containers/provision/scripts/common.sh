#! /bin/bash

function is_command {
    if type "${1}" >/dev/null 2>&1; then
        echo "==> [INFO] ${1} found"
        pass
    else
        echo "==> [ERROR] ${1} not found"
        return 1
    fi
}
function requires {
    for ARG in "${ARGS[@]}"; do
        is_command "${ARG}"
    done
}
function install_dotnet_kernel {
    requires dotnet jupyter zsh
    dotnet tool install --global Microsoft.dotnet-interactive
    dotnet interactive jupyter install
    # shellcheck disable=SC2016
    echo 'export PATH="${PATH}:/root/.dotnet/tools"' >> "${HOME}/.zshrc"
}
function install_codon {
    requires curl python zsh
    /bin/bash -c "$(curl -fsSL https://exaloop.io/install.sh)"
    # shellcheck disable=SC2016
    echo 'export PATH="${HOME}/.codon/bin:${PATH}"' >> "${HOME}/.zshrc"
}