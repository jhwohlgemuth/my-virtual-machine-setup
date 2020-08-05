FROM ubuntu

ENV foo bar

# install dependencies
ENV TZ America/Chicago
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt install -y \
    apt-utils \
    build-essential \
    curl \
    git \
    libssl-dev \
    nano \
    openssh-server \
    pkg-config \
    tree \
    tzdata \
    zsh

# install and configure oh-my-zsh
RUN sh -c "$(curl https://raw.githubusercontent.com/deluan/zsh-in-docker/master/zsh-in-docker.sh)" -- \
    -p colored-man-pages \
    -p encode64 \
    -p extract \
    -p git \
    -p history-substring-search \
    -p wd \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -p https://github.com/jhwohlgemuth/zsh-pentest

# install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
ENV PATH "/root/bin:${PATH}"
ENV NVM_DIR "/root/.nvm"
RUN echo ". /${NVM_DIR}/nvm.sh" >> ~/.zshrc

# install rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH "/root/.cargo/bin:${PATH}"
RUN rustup toolchain install nightly \
    && rustup target add wasm32-unknown-unknown --toolchain nightly
RUN cargo install cargo-audit \
    && cargo install cargo-edit \
    && cargo install wasm-bindgen-cli

ENTRYPOINT [ "/bin/zsh" ]