FROM jhwohlgemuth/base

LABEL author="Jason Wohlgemuth"

EXPOSE 1337 3449 4669 8000 8080 8111 46692

# Install conda
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
RUN curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh

# Install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
ENV PATH "/root/bin:${PATH}"
ENV NVM_DIR "/root/.nvm"
RUN echo ". ${NVM_DIR}/nvm.sh" >> ~/.zshrc

# Install Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH "/root/.cargo/bin:${PATH}"
RUN rustup toolchain install nightly \
    && rustup target add wasm32-unknown-unknown --toolchain nightly \
    && cargo install \
        cargo-audit \
        cargo-edit \
        evcxr_repl \
        wasm-bindgen-cli \
        wasm-pack

# Install .NET runtime and SDK
ARG DEBIAN_FRONTEND=noninteractive
RUN curl -O https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm -f packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install --no-install-recommends -y dotnet-sdk-5.0 dotnet-runtime-5.0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Java and Kotlin
RUN curl -s "https://get.sdkman.io" | bash \
    && bash -c "source $HOME/.sdkman/bin/sdkman-init.sh \
        && yes | sdk install java \
        && yes | sdk install kotlin \
        && yes | sdk install leiningen \
        && rm -rf $HOME/.sdkman/archives/* \
        && rm -rf $HOME/.sdkman/tmp/*"

# Install Clojure
RUN curl -O https://download.clojure.org/install/linux-install-1.10.1.561.sh \
    && chmod +x linux-install-1.10.1.561.sh \
    && ./linux-install-1.10.1.561.sh \
    && mkdir ~/.lein
COPY ./dev-with-docker/config/profiles.clj /root/.lein/

# Install Erlang and Elixir
RUN curl --output erlang.deb https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb \
    && dpkg -i erlang.deb \
    && rm erlang.deb \
    && apt-get update && apt-get install --no-install-recommends -y \
    esl-erlang \
    elixir \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
COPY ./dev-with-docker/config/.iex.exs /root/

# Install Go
RUN curl -o- https://dl.google.com/go/go1.16.5.linux-amd64.tar.gz | tar -xz -C /usr/local
ENV PATH "${PATH}:/usr/local/go/bin"

# Install OCaml
RUN apt-get update && apt-get install --no-install-recommends -y ocaml opam \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install R
RUN apt-get update && apt-get install --no-install-recommends -y r-base \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && R -e "install.packages(c('formatR', 'jsonlite'), repos='http://cran.rstudio.com')"
    
# Install Haskell
RUN curl -sSL https://get.haskellstack.org/ | sh

# Install PowerShell
RUN apt-get update && apt-get install --no-install-recommends -y powershell \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install and Configure Jupyter server
ENV JUPYTER_ROOT /root/.jupyter
ENV CERTS_DIR /root/certs
RUN mkdir -p /root/dev/notebooks && mkdir -p "${JUPYTER_ROOT}/custom" && mkdir -p $CERTS_DIR
COPY ./dev-with-docker/jupyter/jupyter_notebook_config.py $JUPYTER_ROOT
COPY ./dev-with-docker/jupyter/custom.css "${JUPYTER_ROOT}/custom"
COPY ./dev-with-docker/jupyter/ca.cnf $CERTS_DIR
WORKDIR $CERTS_DIR
RUN openssl req -new -x509 -days 365 -out my.pem -config ca.cnf
WORKDIR /root/dev
# Install Jupyter
RUN pip install --no-cache-dir \
        autopep8 \
        ipychart \
        jill \
        jupyter \
        jupyterlab \
        jupyter_contrib_nbextensions \
        jupyter-manim \
        jupyter-tabnine \
        jut \
        kotlin-jupyter-kernel \
        yapf\
    && pip install Pygments --upgrade --no-cache-dir \
    && jupyter contrib nbextension install --user \
    && jupyter nbextension install --py jupyter_tabnine --user \
    # && jupyter nbextension enable code_prettify/code_prettify --user \
    && jupyter nbextension enable --py jupyter_tabnine --user \
    && jupyter serverextension enable --py jupyter_tabnine --user
# Install language kernels
# .NET (C#, F#, and PowerShell)
ENV PATH "/root/.dotnet/tools:${PATH}"
RUN dotnet tool install --global Microsoft.dotnet-interactive && dotnet interactive jupyter install
# Julia
RUN jill install --confirm && julia -e 'using Pkg;Pkg.add("IJulia")'
# R
RUN R -e "install.packages('IRkernel')" && R -e "IRkernel::installspec()"
# Rust
RUN cargo install evcxr_jupyter && evcxr_jupyter --install
# Clojure
# Note: Clojure kernel will not be useable until after https://github.com/clojupyter/clojupyter/issues/122 (hopefully)
RUN conda install -y -c simplect clojupyter
# Elixir
# Note: Includes temporary fix that can be removed after https://github.com/pprzetacznik/IElixir/pull/60 is merged
WORKDIR /opt
RUN git clone https://github.com/pprzetacznik/IElixir.git
WORKDIR /opt/IElixir
RUN git remote add awill1988 https://github.com/awill1988/IElixir.git \
    && git fetch awill1988 feature/elixir_1_12_otp_24_support \
    && git switch --track awill1988/feature/elixir_1_12_otp_24_support \
    && mix local.hex --force \
    && mix local.rebar --force \
    && mix deps.get \
    && mix deps.compile \
    && sed -i 's/python/python3/g' install_script.sh \
    && ./install_script.sh
# Haskell
ENV PATH "${PATH}:/root/.local/bin"
WORKDIR /opt
RUN git clone https://github.com/gibiansky/IHaskell
WORKDIR /opt/IHaskell
RUN stack setup \
    && stack build ihaskell --only-snapshot \
    && stack install ihaskell --local-bin-path ./bin/ \
    && ./bin/ihaskell install --stack

# Install Rust-powered system tools
RUN cargo install \
    broot \
    du-dust \
    grex \
    htmlq \
    tokei

WORKDIR /root/dev

ENTRYPOINT [ "/bin/zsh" ]