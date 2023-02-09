#! /bin/sh

curl -O https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm -f packages-microsoft-prod.deb
apt-get update
apt-get install --no-install-recommends -y \
    dotnet-sdk-6.0 \
    dotnet-runtime-6.0 \
    powershell
apt-get clean
rm -rf /var/lib/apt/lists/*