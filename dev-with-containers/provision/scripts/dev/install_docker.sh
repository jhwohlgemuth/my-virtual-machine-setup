#! /bin/bash
set -e

requires curl
main() {
    # https://docs.docker.com/engine/install/debian/
    #
    # Add Docker GPG key
    #
    # shellcheck source=/dev/null
    . /etc/os-release
    local ID="${ID:-"debian"}"
    local CODENAME="${VERSION_CODENAME:-"bullseye"}"
    local KEY_ROOT="/etc/apt/keyrings"
    local KEY="${KEY_ROOT}/docker.gpg"
    apt-get update
    apt-get install -y \
        ca-certificates \
        gnupg
    install -m 0755 -d "${KEY_ROOT}"
    curl -fsSL "https://download.docker.com/linux/${ID}/gpg" | gpg --dearmor -o "${KEY}"
    chmod a+r "${KEY}"
    echo "deb [arch=$(dpkg --print-architecture) signed-by=${KEY}] https://download.docker.com/linux/${ID} ${CODENAME} stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update
    #
    # Install Docker
    #
    apt-get install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin
    systemctl enable docker.service
    systemctl enable containerd.service
    service docker start
}
main "$@"