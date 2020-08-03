FROM ubuntu

ENV foo=bar
ENV TZ=America/Chicago

# install dependencies
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt install -y \
    build-essential \
    curl \
    git \
    libssl-dev \
    openssh-server \
    pkg-config \
    tree \
    tzdata \
    zsh

# install rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup toolchain install nightly \
    && rustup target add wasm32-unknown-unknown --toolchain nightly
RUN cargo install cargo-audit \
    && cargo install cargo-edit \
    && cargo install wasm-bindgen-cli

# install and configure oh-my-zsh
RUN sh -c "$(curl https://raw.githubusercontent.com/deluan/zsh-in-docker/master/zsh-in-docker.sh)" -- \
    -t agnoster \
    -p colored-man-pages \
    -p encode64 \
    -p extract \
    -p git \
    -p wd \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -p https://github.com/jhwohlgemuth/zsh-pentest

ENTRYPOINT [ "/bin/zsh" ]