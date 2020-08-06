$CHOCOLATEY_PACKAGES = @(
    '7zip'
    'bat'
    'cascadiafonts'
    'ccleaner'
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
$POWERSHELL_MODULES = @(
    'posh-git'
    'oh-my-posh'
    'PSConsoleTheme'
    'Get-ChildItemColor'
)

function Test-Installed
{
  $Name = $args[0]
  Get-Module -ListAvailable -Name $Name
}
function Install-ModuleMaybe
{
    $Name = $args[0]
    if (Test-Installed $Name) {
        Write-Output "==> $Name already installed"
    } else {
        Write-Output "==> Installing $Name"
        Install-Module -Name $Name -Scope CurrentUser -AllowClobber
    }
}

# Install Chocolatey packages
choco feature enable -n allowGlobalConfirmation
$CHOCOLATEY_PACKAGES | ForEach-Object { choco install $_ }

# Install Powershell modules
$POWERSHELL_MODULES | Install-ModuleMaybe
