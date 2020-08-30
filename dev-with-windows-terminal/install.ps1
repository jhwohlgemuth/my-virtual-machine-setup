param(
    [Parameter()]
    [string] $Type="chocolatey"
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
    'elixir'
    'fd'
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
    'nano'
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
    'fd'
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
$POWERSHELL_MODULES | ForEach-Object { Install-ModuleMaybe $_ }

if ($Type.StartsWith("choco")) {
    Write-Output "==> Installing Chocolatey packages"
    choco feature enable -n allowGlobalConfirmation
    $CHOCOLATEY_PACKAGES | ForEach-Object { choco install $_ }
} else {
    Write-Output "==> Installing Scoop Applications"
    $SCOOP_APPLICATIONS | ForEach-Object { scoop install $_ }
}


