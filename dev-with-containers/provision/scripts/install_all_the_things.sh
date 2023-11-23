#! /bin/bash

apt-get update
#
# Install development dependencies
#
apt-get install --no-install-recommends -y \
    apt-utils \
    apt-transport-https \
    binutils \
    binutils-dev \
    ca-certificates \
    clang \
    dirmngr \
    dbus-user-session \
    ffmpeg \
    fop \
    gir1.2-webkit2-4.0 \
    gnupg \
    gnupg2 \
    libatomic1 \
    libblas-dev \
    libc6-dev \
    libcairo2-dev \
    libcanberra-gtk3-module \
    libcurl4 \
    libedit2 \
    libffi-dev \
    libgirepository1.0-dev \
    libgl1 \
    libgmp10 \
    libgmp-dev \
    liblapack-dev \
    libmagic-dev \
    libncurses-dev \
    libncurses5 \
    libpango1.0-dev \
    libpango-1.0-0 \
    libpoppler-cpp-dev \
    libpython2.7 \
    libreoffice \
    libsqlite3-0 \
    libsqlite3-dev \
    libssl-dev \
    libtinfo5 \
    libtinfo-dev \
    libudev-dev \
    libxcb-shape0-dev \
    libxcb-xfixes0-dev \
    libxml2 \
    libz3-dev \
    libzmq3-dev \
    libzmq5 \
    libzmq5-dev \
    lld \
    lldb \
    netbase \
    openssh-server \
    openssl \
    pkg-config \
    poppler-utils \
    slirp4netns \
    uuid-dev \
    xsltproc \
    zlib1g-dev