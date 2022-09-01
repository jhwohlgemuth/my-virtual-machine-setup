#! /bin/sh

#
# Install miniconda (conda)
#
curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
mkdir /root/.conda
bash Miniconda3-latest-Linux-x86_64.sh -b
rm -f Miniconda3-latest-Linux-x86_64.sh
#
# Install mamba
#
/root/miniconda3/bin/conda update --name base conda
/root/miniconda3/bin/conda install --name base --channel conda-forge mamba
zsh -c "/root/miniconda3/bin/conda init zsh"