FROM ubuntu:focal

LABEL author="Jason Wohlgemuth"

EXPOSE 1337 4669 8000 8080 8111 46692

ENV TZ America/Chicago
ENV TERM xterm-256color

# Install dependencies
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
    apt-utils \
    apt-transport-https \
    bat \
    build-essential \
    curl \
    git \
    gnupg \
    jq \
    less \
    libssl-dev \
    nano \
    openssh-server \
    pkg-config \
    snapd \
    tree \
    tzdata \
    unzip \
    zip \
    zsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install .NET runtime and SDK
RUN curl -o packages-microsoft-prod.deb https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm -f packages-microsoft-prod.deb
RUN apt-get update && apt-get install -y \
    dotnet-sdk-3.1 \
    dotnet-runtime-3.1 \
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

# Install Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH "/root/.cargo/bin:${PATH}"
RUN rustup toolchain install nightly \
    && rustup target add wasm32-unknown-unknown --toolchain nightly
RUN cargo install cargo-audit \
    && cargo install cargo-edit \
    && cargo install du-dust \
    && cargo install grex \
    && cargo install tokei \
    && cargo install wasm-bindgen-cli \
    && cargo install wasm-pack
    
# Install JVM, Kotlin and Clojure
RUN curl -s "https://get.sdkman.io" | bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN source "$HOME/.sdkman/bin/sdkman-init.sh" \
    && sdk install java \
    && sdk install kotlin \
    && sdk install leiningen \
    && rm -rf "$HOME/.sdkman/archives/*" \
    && rm -rf "$HOME/.sdkman/tmp/*"
RUN curl -O https://download.clojure.org/install/linux-install-1.10.1.561.sh \
    && chmod +x linux-install-1.10.1.561.sh \
    && ./linux-install-1.10.1.561.sh
RUN mkdir ~/.lein
COPY profiles.clj /root/.lein/

# Install Erlang and Elixir
RUN curl --output erlang.deb https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb \
    && dpkg -i erlang.deb \
    && rm erlang.deb
RUN apt-get update && apt-get install -y \
    esl-erlang \
    elixir \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
COPY .iex.exs /root/

ENTRYPOINT [ "/bin/zsh" ]