param(
    [Parameter()]
    [string] $Type="chocolatey"
)

$POWERSHELL_MODULES = @(
    'pwsh-prelude'
    # https://github.com/dahlbyk/posh-git
    'posh-git'
    # https://github.com/JanDeDobbeleer/oh-my-posh
    'oh-my-posh'
    # https://github.com/mmims/PSConsoleTheme
    'PSConsoleTheme'
    # https://github.com/PowerShell/PSScriptAnalyzer
    'PSScriptAnalyzer'
    # https://github.com/joonro/Get-ChildItemColor
    'Get-ChildItemColor'
    # https://github.com/aaronpowell/ps-nvm
    'nvm'
)
$CHOCOLATEY_PACKAGES = @(
    '7zip'
    'bat'
    'cascadiafonts'
    'ccleaner'
    'delta'
    'dos2unix'
    'dropbox'
    'elixir'
    'fd'
    'firacode'
    'firefox'
    'fzf'
    'git'
    'googlechrome'
    'googledrive'
    'insomnia-rest-api-client'
    'itunes'
    'jetbrainsmono'
    'jq'
    'lockhunter'
    'malwarebytes'
    'make'
    'miktex'
    'nano'
    'neovim'
    'nordvpn'
    'nvm'
    'packer'
    'pandoc'
    'ripgrep'
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
    'fd'
    # 'firacode'
    # 'firefox'
    'fzf'
    'git'
    # 'googlechrome'
    # 'googledrive'
    # 'insomnia-rest-api-client'
    # 'itunes'
    # 'jetbrainsmono'
    'jq'
    # 'lockhunter'
    # 'malwarebytes'
    'make'
    # 'miktex'
    # 'nordvpn'
    'neovim'
    'nvm'
    'packer'
    'pandoc'
    'ripgrep'
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

function Install-ModuleMaybe
{
  [CmdletBinding()]
  param (
    [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [string] $Name
  )
  if (Get-Module -ListAvailable -Name $Name) {
      Write-Output "==> $Name already installed"
  } else {
      Write-Output "==> Installing $Name"
      Install-Module -Name $Name -Scope CurrentUser -AllowClobber
  }
}
Write-Output "==> Installing Powershell modules"
Install-PackageProvider Nuget -MinimumVersion 2.8.5.201 -Force
$POWERSHELL_MODULES | ForEach-Object { Install-ModuleMaybe $_ }

if ($Type.StartsWith("choco")) {
    Write-Output "==> Installing Chocolatey packages"
    choco feature enable -n allowGlobalConfirmation
    $CHOCOLATEY_PACKAGES | ForEach-Object { choco install $_ }
} else {
    Write-Output "==> Installing Scoop Applications"
    $SCOOP_APPLICATIONS | ForEach-Object { scoop install $_ }
}


