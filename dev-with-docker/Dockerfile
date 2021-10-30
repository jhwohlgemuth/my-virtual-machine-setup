FROM jhwohlgemuth/base

LABEL author="Jason Wohlgemuth"

EXPOSE 1337 3449 4669 8000 8080 8111 46692

# Install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
ENV PATH "/root/bin:${PATH}"
ENV NVM_DIR "/root/.nvm"
RUN echo ". ${NVM_DIR}/nvm.sh" >> ~/.zshrc

# Install conda
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
RUN curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh

# Install Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH "/root/.cargo/bin:${PATH}"
RUN rustup toolchain install nightly \
    && rustup target add wasm32-unknown-unknown --toolchain nightly
# Install Rust-powered system tools
RUN cargo install cargo-audit \
    && cargo install broot \
    && cargo install cargo-edit \
    && cargo install du-dust \
    && cargo install evcxr_repl \
    && cargo install evcxr_jupyter \
    && cargo install grex \
    && cargo install htmlq \
    && cargo install tokei \
    && cargo install wasm-bindgen-cli \
    && cargo install wasm-pack

# Install .NET runtime and SDK
ARG DEBIAN_FRONTEND=noninteractive
RUN curl -O https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm -f packages-microsoft-prod.deb
RUN apt-get update && apt-get install --no-install-recommends -y \
    dotnet-sdk-5.0 \
    dotnet-runtime-5.0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install JVM, Maven, Kotlin and Clojure
RUN curl -s "https://get.sdkman.io" | bash
RUN bash -c "source $HOME/.sdkman/bin/sdkman-init.sh \
    && yes | sdk install java \
    && yes | sdk install maven \
    && yes | sdk install kotlin \
    && yes | sdk install leiningen \
    && rm -rf $HOME/.sdkman/archives/* \
    && rm -rf $HOME/.sdkman/tmp/*"
RUN curl -O https://download.clojure.org/install/linux-install-1.10.1.561.sh \
    && chmod +x linux-install-1.10.1.561.sh \
    && ./linux-install-1.10.1.561.sh \
    && mkdir ~/.lein
COPY ./dev-with-docker/config/profiles.clj /root/.lein/

# Install Erlang and Elixir
RUN curl --output erlang.deb https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb \
    && dpkg -i erlang.deb \
    && rm erlang.deb
RUN apt-get update && apt-get install --no-install-recommends -y \
    esl-erlang \
    elixir \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
COPY ./dev-with-docker/config/.iex.exs /root/

# Install Go
RUN curl -o- https://dl.google.com/go/go1.16.5.linux-amd64.tar.gz | tar -xz -C /usr/local
ENV PATH "${PATH}:/usr/local/go/bin"

# Install OCaml
RUN apt-get update && apt-get install --no-install-recommends -y \
    ocaml \
    opam \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install R
RUN apt-get update && apt-get install --no-install-recommends -y \
    r-base \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    
# Haskell
RUN curl -sSL https://get.haskellstack.org/ | sh

# Install PowerShell
RUN apt-get update && apt-get install --no-install-recommends -y \
    powershell \
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
# Install Jupyter Python dependencies
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
    yapf
RUN pip install Pygments --upgrade --no-cache-dir \
    && R -e "install.packages(c('formatR', 'jsonlite'), repos='http://cran.rstudio.com')" \
    && jupyter contrib nbextension install --user \
    && jupyter nbextension install --py jupyter_tabnine --user \
    && jupyter nbextension enable code_prettify/code_prettify --user \
    && jupyter nbextension enable --py jupyter_tabnine --user \
    && jupyter serverextension enable --py jupyter_tabnine --user
# Install language kernels
# .NET (C#, F#, and PowerShell)
RUN dotnet tool install --global Microsoft.dotnet-interactive
ENV PATH "/root/.dotnet/tools:${PATH}"
RUN dotnet interactive jupyter install
# Julia
RUN jill install --confirm
RUN julia -e 'using Pkg;Pkg.add("IJulia")'
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
RUN git clone https://github.com/pprzetacznik/IElixir.git \
    && cd IElixir \
    && git remote add awill1988 https://github.com/awill1988/IElixir.git \
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
RUN git clone https://github.com/gibiansky/IHaskell
WORKDIR /opt/IHaskell
RUN pip install -r requirements.txt --no-cache-dir
RUN stack setup
RUN stack build ihaskell --only-snapshot
RUN stack install ihaskell --local-bin-path ./bin/ 
RUN ./bin/ihaskell install --stack

WORKDIR /root/dev

ENTRYPOINT [ "/bin/zsh" ]