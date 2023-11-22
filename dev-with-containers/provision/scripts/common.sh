#! /bin/bash

RED='\033[0;31m'
NC='\033[0m'

function is_command {
    if type "${1}" >/dev/null 2>&1 ; then
        return 0
    else
        return 1
    fi
}
function is_installed {
    if apt list "${1}" 2>/dev/null | grep installed >/dev/null 2>&1 ; then
        return 0
    else
        return 1
    fi
}
function requires {
    if [ -n "$1" ]; then
        ARGS=("$@")
        for ARG in "${ARGS[@]}"; do
            is_command "${ARG}" || is_installed "${ARG}" || kill -SIGINT $$
            # echo "${RED}==> [ERROR]${NC} ${1} not installed"
        done
    fi
}
function install_dotnet_kernel {
    requires \
        dotnet \
        jupyter \
        zsh
    dotnet tool install --global Microsoft.dotnet-interactive
    dotnet interactive jupyter install
    # shellcheck disable=SC2016
    echo 'export PATH="${PATH}:/root/.dotnet/tools"' >> "${HOME}/.zshrc"
}
function install_codon {
    requires \
        curl \
        python \
        zsh
    /bin/bash -c "$(curl -fsSL https://exaloop.io/install.sh)"
    # shellcheck disable=SC2016
    echo 'export PATH="${HOME}/.codon/bin:${PATH}"' >> "${HOME}/.zshrc"
}