FROM jhwohlgemuth/base

LABEL author="Jason Wohlgemuth"

EXPOSE 1337 3449 4669 8000 8080 8111 46692

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
    && cargo install broot \
    && cargo install cargo-edit \
    && cargo install du-dust \
    && cargo install grex \
    && cargo install tokei \
    && cargo install wasm-bindgen-cli \
    && cargo install wasm-pack

# Install .NET runtime and SDK
ARG DEBIAN_FRONTEND=noninteractive
RUN curl -o packages-microsoft-prod.deb https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm -f packages-microsoft-prod.deb
RUN apt-get update && apt-get install -y \
    dotnet-sdk-3.1 \
    dotnet-runtime-3.1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install JVM, Maven, Kotlin and Clojure
RUN curl -s "https://get.sdkman.io" | bash
RUN bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && \
    yes | sdk install java && \
    yes | sdk install maven && \
    yes | sdk install kotlin && \
    yes | sdk install leiningen && \
    rm -rf $HOME/.sdkman/archives/* && \
    rm -rf $HOME/.sdkman/tmp/*"
RUN curl -O https://download.clojure.org/install/linux-install-1.10.1.561.sh \
    && chmod +x linux-install-1.10.1.561.sh \
    && ./linux-install-1.10.1.561.sh
RUN mkdir ~/.lein
COPY ./dev-with-docker/profiles.clj /root/.lein/

# Install Erlang and Elixir
RUN curl --output erlang.deb https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb \
    && dpkg -i erlang.deb \
    && rm erlang.deb
RUN apt-get update && apt-get install -y \
    esl-erlang \
    elixir \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
COPY ./dev-with-docker/.iex.exs /root/

# Install Go
RUN wget -c https://dl.google.com/go/go1.16.5.linux-amd64.tar.gz -O - | tar -xz -C /usr/local
ENV PATH "${PATH}:/usr/local/go/bin"

# Install OCaml
RUN apt-get update && apt-get install -y \
    ocaml \
    opam \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "/bin/zsh" ]