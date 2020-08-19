FROM ubuntu:focal

LABEL author="Jason Wohlgemuth"

EXPOSE 1337 4669 8000 8080 46692

ENV TZ America/Chicago
ENV TERM xterm-256color

# Install dependencies
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
    apt-utils \
    bat \
    build-essential \
    curl \
    git \
    jq \
    less \
    libssl-dev \
    nano \
    openssh-server \
    pkg-config \
    snapd \
    tree \
    tzdata \
    zsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install and configure oh-my-zsh
RUN sh -c "$(curl https://raw.githubusercontent.com/deluan/zsh-in-docker/master/zsh-in-docker.sh)" -- \
    -p colored-man-pages \
    -p encode64 \
    -p extract \
    -p git \
    -p history-substring-search \
    -p wd \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -p https://github.com/jhwohlgemuth/zsh-handy-helpers \
    -p https://github.com/jhwohlgemuth/zsh-pentest
# Customize .zshrc
RUN sed -i "s/export TERM=xterm/export TERM=xterm-256color/g" ~/.zshrc \
    && echo "ZLE_RPROMPT_INDENT=0" >> ~/.zshrc \
    && echo "alias bat=batcat" >> ~/.zshrc 

# Install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
ENV PATH "/root/bin:${PATH}"
ENV NVM_DIR "/root/.nvm"
RUN echo ". ${NVM_DIR}/nvm.sh" >> ~/.zshrc

# Install rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH "/root/.cargo/bin:${PATH}"
RUN rustup toolchain install nightly \
    && rustup target add wasm32-unknown-unknown --toolchain nightly
RUN cargo install cargo-audit \
    && cargo install cargo-edit \
    && cargo install grex \
    && cargo install tokei \
    && cargo install wasm-bindgen-cli \
    && cargo install wasm-pack

ENTRYPOINT [ "/bin/zsh" ]