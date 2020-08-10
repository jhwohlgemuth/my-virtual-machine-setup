param(
    [Parameter()]
    [string] $InstallationType="chocolatey"
)

$POWERSHELL_MODULES = @(
    'posh-git'
    'oh-my-posh'
    'PSConsoleTheme'
    'Get-ChildItemColor'
)
$CHOCOLATEY_PACKAGES = @(
    '7zip'
    'bat'
    'cascadiafonts'
    'ccleaner'
    'delta'
    'dos2unix'
    'dropbox'
    'firacode'
    'firefox'
    'git'
    'googlechrome'
    'googledrive'
    'insomnia-rest-api-client'
    'itunes'
    'jq'
    'lockhunter'
    'malwarebytes'
    'make'
    'miktex'
    'nordvpn'
    'nvm'
    'packer'
    'pandoc'
    'speccy'
    'steam'
    'sysinternals'
    'teracopy'
    'vscode'
    'vagrant'
    'virtualbox'
    'windirstat'
    'zotero'
)
$SCOOP_APPLICATIONS = @(
    '7zip'
    'bat'
    # 'cascadiafonts'
    # 'ccleaner'
    'delta'
    'dos2unix'
    # 'dropbox'
    # 'firacode'
    # 'firefox'
    'git'
    # 'googlechrome'
    # 'googledrive'
    # 'insomnia-rest-api-client'
    # 'itunes'
    'jq'
    # 'lockhunter'
    # 'malwarebytes'
    'make'
    # 'miktex'
    # 'nordvpn'
    'nvm'
    'packer'
    'pandoc'
    # 'speccy'
    # 'steam'
    # 'sysinternals'
    # 'teracopy'
    # 'vscode'
    'vagrant'
    # 'virtualbox'
    # 'windirstat'
    # 'zotero'
)

# Install Powershell modules
$POWERSHELL_MODULES | ForEach-Object { Install-ModuleMaybe $_ }

if ($InstallationType.StartsWith("choco")) {
    Write-Output "==> Installing Chocolatey packages"
    choco feature enable -n allowGlobalConfirmation
    $CHOCOLATEY_PACKAGES | ForEach-Object { choco install $_ }
} else {
    Write-Output "==> Installing Scoop Applications"
    $SCOOP_APPLICATIONS | ForEach-Object { scoop install $_ }
}


