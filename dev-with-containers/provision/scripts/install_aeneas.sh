#! /bin/sh
#
# Install opam dependencies
#
if type opam >/dev/null 2>&1; then
    opam install --yes \
        core_unix \
        easy_logging \
        ocamlgraph \
        odoc \
        ppx_deriving \
        unionFind \
        visitors \
        yojson \
        zarith
    eval "$(opam env)"
else
    echo "==> [WARN] opam is NOT installed"
    exit 1
fi
#
# Install Charon and Aeneas
#
mkdir -p /aeneas-toolchain && cd /aeneas-toolchain || exit
git clone https://github.com/AeneasVerif/charon
git clone https://github.com/AeneasVerif/aeneas
cd /aeneas-toolchain/aeneas/compiler && ln -s /aeneas-toolchain/charon/charon-ml charon
if [ -e charon ]; then
    cd /aeneas-toolchain/aeneas && make
    chmod +x ./bin/aeneas
    mv ./bin/aeneas /usr/local/bin
else
    echo "==> [ERROR] Invalid charon link"
fi
cd /root || exit
#
# Install coq-of-rust
if type cargo >/dev/null 2>&1; then
    cd /
    git clone https://github.com/formal-land/coq-of-rust
    cd /coq-of-rust && cargo install --path lib/
    cd / && rm -frd /coq-of-rust
else
    echo "==> [WARN] cargo is NOT installed"
fi