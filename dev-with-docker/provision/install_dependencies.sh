#! /bin/sh

apt-get update && apt-get install --no-install-recommends -y \
    apt-utils \
    apt-transport-https \
    binutils \
    build-essential \
    clang \
    cmake \
    cmatrix \
    coqide \
    curl \
    dos2unix \
    ffmpeg \
    fzf \
    git \
    gnupg \
    gnupg2 \
    hexyl \
    httpie \
    jq \
    less \
    libblas-dev \
    libc6-dev \
    libcairo2-dev \
    libcurl4 \
    libedit2 \
    libffi-dev \
    libffi7 \
    libgcc-9-dev \
    libgmp10 \
    libgmp-dev \
    liblapack-dev \
    libmagic-dev \
    libncurses-dev \
    libncurses5 \
    libpango1.0-dev \
    libpython2.7 \
    libsqlite3-0 \
    libsqlite3-dev \
    libssl-dev \
    libstdc++-9-dev \
    libtinfo5 \
    libtinfo-dev \
    libxcb-shape0-dev \
    libxcb-xfixes0-dev \
    libxml2 \
    libz3-dev \
    libzmq3-dev \
    lld \
    lldb \
    nano \
    neovim \
    netbase \
    openssh-server \
    pkg-config \
    python3-dev \
    python3-pip \
    python3-setuptools \
    rlwrap \
    snapd \
    tree \
    tzdata \
    unzip \
    uuid-dev \
    zip \
    zlib1g-dev \
    zsh
apt-get clean
rm -rf /var/lib/apt/lists/*
# This addresses a bug in the Rust build tools [link](https://askubuntu.com/a/1300824)
apt-get update && apt-get install --no-install-recommends -y -o Dpkg::Options::="--force-overwrite" \
    bat \
    ripgrep
apt-get clean
rm -rf /var/lib/apt/lists/*