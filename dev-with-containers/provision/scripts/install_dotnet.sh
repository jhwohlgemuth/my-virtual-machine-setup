#! /bin/bash
set -e

main() {
    requires curl
    #
    # Add Microsoft PPA
    #
    curl -O https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
    dpkg -i packages-microsoft-prod.deb
    rm -f packages-microsoft-prod.deb
    #
    # Install dotnet and PowerShell core
    #
    local VERSION="${1:-"7.0"}"
    apt-get update
    apt-get install --no-install-recommends -y \
        "dotnet-sdk-${VERSION}" \
        "dotnet-runtime-${VERSION}" \
        powershell
    #
    # Install bflat
    #
    mkdir -p /bflat && cd /bflat || exit
    curl -o bflat.tar.gz -LJ https://github.com/bflattened/bflat/releases/download/v8.0.0/bflat-8.0.0-linux-glibc-x64.tar.gz
    tar -xvf bflat.tar.gz
    chmod +x /bflat/bflat
    mv /bflat/bflat /usr/local/bin
    cd /root && rm -frd /bflat
}
main "$@"