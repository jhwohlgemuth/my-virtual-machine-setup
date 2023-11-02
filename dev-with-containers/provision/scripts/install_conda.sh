#! /bin/sh

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
MINIFORGE_NAME=Miniforge3
MINIFORGE_VERSION=23.3.1-1
wget --no-hsts --quiet "https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/${MINIFORGE_NAME}-${MINIFORGE_VERSION}-Linux-$(uname -m).sh" -O /tmp/miniforge.sh
/bin/bash /tmp/miniforge.sh -b -p "${CONDA_DIR}"
rm /tmp/miniforge.sh