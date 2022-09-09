FROM jhwohlgemuth/base

LABEL author="Jason Wohlgemuth"

EXPOSE 1337 3449 4669 8000 8080 8111 46692
#
# Install Rust
#
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH "${PATH}:/root/.cargo/bin"
RUN rustup toolchain install nightly \
    && rustup target add wasm32-unknown-unknown --toolchain nightly \
    && cargo install \
        cargo-audit \
        cargo-edit \
        evcxr_repl \
        wasm-bindgen-cli \
        wasm-pack \
        broot \
        du-dust \
        grex \
        htmlq \
        tokei
#
# Install Java, Scala, and Kotlin
#
SHELL ["/bin/bash", "-c"]
RUN curl -s "https://get.sdkman.io" | bash \
    && source "${HOME}/.sdkman/bin/sdkman-init.sh" \
    && yes | sdk install hadoop \
    && yes | sdk install java 18-open \
    && yes | sdk install kotlin \
    && yes | sdk install leiningen \
    && yes | sdk install scala \
    && yes | sdk install spark \
    && rm -rf "${HOME}/.sdkman/archives/*" \
    && rm -rf "${HOME}/.sdkman/tmp/*"
SHELL ["/bin/sh", "-c"]
#
# Install Clojure
#
RUN curl -O https://download.clojure.org/install/linux-install-1.10.1.561.sh \
    && chmod +x linux-install-1.10.1.561.sh \
    && ./linux-install-1.10.1.561.sh \
    && mkdir /root/.lein
COPY ./config/profiles.clj /root/.lein/
#
# Install kerl and Erlang
#
WORKDIR /usr/local/bin
ENV ERL_VERSION "23.3.4.11"
# ENV ERL_VERSION "24.2.1"
RUN apt-get update && apt-get install --no-install-recommends -y \
        fop \
        libxml2-utils \
        xsltproc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl -O https://raw.githubusercontent.com/kerl/kerl/master/kerl \
    && chmod a+x kerl \
    && kerl build ${ERL_VERSION} \
    && kerl install ${ERL_VERSION} "${HOME}/kerl/${ERL_VERSION}" \
    && . "${HOME}/kerl/${ERL_VERSION}/activate" \
    && echo "source ${HOME}/kerl/${ERL_VERSION}/activate" >> "${HOME}/.zshrc"
#
# Install kerl, kiex, and Elixir
#
SHELL ["/bin/bash", "-c"]
WORKDIR /root
ENV ELIXIR_VERSION "1.12.3"
# ENV ELIXIR_VERSION "1.13.3"
RUN curl -sSL https://raw.githubusercontent.com/taylor/kiex/master/install | bash -s \
    && echo "source ${HOME}/.kiex/scripts/kiex" >> "${HOME}/.zshrc" \
    && source "${HOME}/kerl/${ERL_VERSION}"/activate \
    && source "${HOME}/.kiex/scripts/kiex" \
    && kiex install ${ELIXIR_VERSION} \
    && kiex use ${ELIXIR_VERSION} \
    && kiex default ${ELIXIR_VERSION}
COPY ./config/.iex.exs /root/
SHELL ["/bin/sh", "-c"]
#
# Install Go
#
WORKDIR /root
RUN curl -o- https://dl.google.com/go/go1.16.5.linux-amd64.tar.gz | tar -xz -C /usr/local
ENV PATH "${PATH}:/usr/local/go/bin"
#
# Install Haskell
#
WORKDIR /root
RUN curl -sSL https://get.haskellstack.org/ | sh
#
# Install OCaml
#
WORKDIR /root
RUN apt-get update && apt-get install --no-install-recommends -y ocaml opam \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
#
# Install R and Ruby
#
WORKDIR /root
RUN apt-get update && apt-get install --no-install-recommends -y r-base ruby-full \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && R -e "install.packages(c('formatR', 'jsonlite'), repos='http://cran.rstudio.com')"
ENV PATH "${PATH}:/root/.gem/ruby/2.7.0/bin"
#
# Install Swift
#
ENV SWIFT_SIGNING_KEY 'A62AE125BBBFBB96A6E042EC925CC1CCED3D1561'
ENV SWIFT_PLATFORM 'ubuntu20.04'
ENV SWIFT_BRANCH 'swift-5.5.3-release'
ENV SWIFT_VERSION 'swift-5.5.3-RELEASE'
ENV SWIFT_WEBROOT 'https://download.swift.org'
RUN SWIFT_WEBDIR="${SWIFT_WEBROOT}/${SWIFT_BRANCH}/$(echo ${SWIFT_PLATFORM} | tr -d .)" \
    && SWIFT_BIN_URL="${SWIFT_WEBDIR}/${SWIFT_VERSION}/${SWIFT_VERSION}-${SWIFT_PLATFORM}.tar.gz" \
    && curl -fsSL ${SWIFT_BIN_URL} -o swift.tar.gz \
    && tar -xzf swift.tar.gz --directory / --strip-components=1 \
    && chmod -R o+r /usr/lib/swift

WORKDIR /root/dev
ENTRYPOINT [ "/bin/zsh" ]