#! /bin/sh

apt-get update
#
# Install essential dependencies
#
apt-get install --no-install-recommends -y \
    build-essential \
    cmake \
    curl \
    dos2unix \
    figlet \
    fuse-overlayfs \
    fzf \
    git \
    jq \
    less \
    neovim \
    python3-dev \
    python3-venv \
    python3-pip \
    python3-setuptools \
    rlwrap \
    screen \
    tree \
    tzdata \
    unzip \
    zip \
    zsh
#
# Install development dependencies
#
# apt-get install --no-install-recommends -y \
#     apt-utils \
#     apt-transport-https \
#     binutils \
#     binutils-dev \
#     ca-certificates \
#     clang \
#     dirmngr \
#     dbus-user-session \
#     ffmpeg \
#     gir1.2-webkit2-4.0 \
#     gnupg \
#     gnupg2 \
#     libatomic1 \
#     libblas-dev \
#     libc6-dev \
#     libcairo2-dev \
#     libcanberra-gtk3-module \
#     libcurl4 \
#     libedit2 \
#     libffi-dev \
#     libgirepository1.0-dev \
#     libgl1 \
#     libgmp10 \
#     libgmp-dev \
#     liblapack-dev \
#     libmagic-dev \
#     libncurses-dev \
#     libncurses5 \
#     libpango1.0-dev \
#     libpango-1.0-0 \
#     libpoppler-cpp-dev \
#     libpython2.7 \
#     libreoffice \
#     libsqlite3-0 \
#     libsqlite3-dev \
#     libssl-dev \
#     libtinfo5 \
#     libtinfo-dev \
#     libudev-dev \
#     libxcb-shape0-dev \
#     libxcb-xfixes0-dev \
#     libxml2 \
#     libz3-dev \
#     libzmq3-dev \
#     libzmq5 \
#     libzmq5-dev \
#     lld \
#     lldb \
#     netbase \
#     openssh-server \
#     openssl \
#     pkg-config \
#     poppler-utils \
#     slirp4netns \
#     uuid-dev \
#     zlib1g-dev