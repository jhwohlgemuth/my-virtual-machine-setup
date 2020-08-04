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

# install nvm
ENV ZSH_CONFIG="${HOME}/.zshrc"
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
ENV NVM_DIR="${HOME}/.nvm"
ENV PATH="${HOME}/bin:${PATH}"
RUN echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\"" >> $ZSH_CONFIG \
    && echo "npm completion >/dev/null 2>&1" >> $ZSH_CONFIG

# install rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup toolchain install nightly \
    && rustup target add wasm32-unknown-unknown --toolchain nightly
RUN cargo install cargo-audit \
    && cargo install cargo-edit \
    && cargo install wasm-bindgen-cli

ENTRYPOINT [ "/bin/zsh" ]