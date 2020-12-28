Param(
  [Parameter(Position=0)]
  [String] $Type='chocolatey'
)
$POWERSHELL_MODULES = @(
  'pwsh-prelude'
  'posh-git'           # https://github.com/dahlbyk/posh-git
  'oh-my-posh'         # https://github.com/JanDeDobbeleer/oh-my-posh
  'PSConsoleTheme'     # https://github.com/mmims/PSConsoleTheme
  'PSScriptAnalyzer'   # https://github.com/PowerShell/PSScriptAnalyzer
  'Get-ChildItemColor' # https://github.com/joonro/Get-ChildItemColor
  'nvm'                # https://github.com/aaronpowell/ps-nvm
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
  'lazydocker'
  'lazygit'
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
  'lazydocker'
  'lazygit'
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
function Install-ModuleMaybe {
  [CmdletBinding()]
  Param (
    [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
    [String] $Name
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


