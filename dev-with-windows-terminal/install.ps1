choco feature enable -n allowGlobalConfirmation

# Windows Software
choco install 7zip
choco install bat
choco install cascadiafonts
choco install ccleaner
choco install dropbox
choco install firacode
choco install firefox
choco install git
choco install googlechrome
choco install googledrive
choco install insomnia-rest-api-client
choco install itunes
choco install jq
choco install lockhunter
choco install malwarebytes
choco install make
choco install miktex
choco install nordvpn
choco install nvm
choco install packer
choco install pandoc
choco install speccy
choco install steam
choco install sysinternals
choco install teracopy
choco install vscode
choco install vagrant
choco install virtualbox
choco install windirstat
choco install zotero

# Powershell modules
Install-Module posh-git -Scope CurrentUser
Install-Module oh-my-posh -Scope CurrentUser
Install-Module -Name PSConsoleTheme
Install-Module -Name Get-ChildItemColor -AllowClobber -Scope CurrentUser
Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck
