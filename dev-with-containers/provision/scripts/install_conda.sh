#! /bin/bash
set -e

requires curl zsh
main() {
    #
    # Install miniconda (conda)
    #
    curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    mkdir /root/.conda
    bash Miniconda3-latest-Linux-x86_64.sh -b
    rm -f Miniconda3-latest-Linux-x86_64.sh
    /root/miniconda3/bin/conda update --name base conda
    zsh -c "/root/miniconda3/bin/conda init zsh"
    zsh -c "/root/miniconda3/bin/conda init powershell"
    #
    # Install mamba
    #
    local VERSION="${MAMBA_VERSION:-"23.3.1-1"}"
    local NAME=Miniforge3
    local SCRIPT_PATH=/tmp/miniforge.sh
    curl -o "${SCRIPT_PATH}" -LJ "https://github.com/conda-forge/miniforge/releases/download/${VERSION}/${NAME}-${VERSION}-Linux-$(uname -m).sh"
    /bin/bash "${SCRIPT_PATH}" -bu -p "${CONDA_DIR}"
}
main "$@"