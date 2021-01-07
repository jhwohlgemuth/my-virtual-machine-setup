<#
.SYNOPSIS
Setup script for installing useful PowerShell modules and applications on Windows
.PARAMETER PackageManager
Name of package manager to use ("Chocolatey" or "Scoop")
> Note: Scoop does not provide all of the applications that are available via Chocolatey
.PARAMETER Exclude
Array of application names that should not be installed
.PARAMETER SkipModule
Do not install any PowerShell modules
.PARAMETER SkipApplication
Do not install any applications
.EXAMPLE
./Invoke-Setup
.EXAMPLE
./Invoke-Setup -PackageManager 'Scoop' -Exclude 'python'
#>
[CmdletBinding(SupportsShouldProcess=$True)]
Param(
  [Parameter(Position=0)]
  [ValidateSet('choco', 'Chocalatey', 'Scoop')]
  [String] $PackageManager='Chocolatey',
  [String[]] $Exclude = '',
  [Switch] $SkipModules,
  [Switch] $SkipApplications
)
if (-not $SkipModules) {
  $Modules = @(
    'Prelude'
    'posh-git'           # https://github.com/dahlbyk/posh-git
    'oh-my-posh'         # https://github.com/JanDeDobbeleer/oh-my-posh
    'PSConsoleTheme'     # https://github.com/mmims/PSConsoleTheme
    'PSScriptAnalyzer'   # https://github.com/PowerShell/PSScriptAnalyzer
    'Get-ChildItemColor' # https://github.com/joonro/Get-ChildItemColor
    'nvm'                # https://github.com/aaronpowell/ps-nvm
  )
  function Install-ModuleMaybe {
    [CmdletBinding()]
    Param (
      [Parameter(Mandatory=$True, Position=0, ValueFromPipeline=$True)]
      [String] $Name
    )
    if (Get-Module -ListAvailable -Name $Name) {
      "==> $Name already installed" | Write-Verbose
    } else {
      "==> Installing $Name" | Write-Verbose
      Install-Module -Name $Name -Scope CurrentUser -AllowClobber
    }
  }
  '==> Installing PowerShell modules' | Write-Verbose
  if ($PSCmdlet.ShouldProcess('Install Nuget package provider')) {
    '==> Installing Nuget package provider' | Write-Verbose
    Install-PackageProvider Nuget -MinimumVersion 2.8.5.201 -Force
  }
  foreach ($Name in $Modules) {
    if ($PSCmdlet.ShouldProcess("Install $Name PowerShell module")) {
      Install-ModuleMaybe -Name $Name
    }
  }
}
if (-not $SkipApplications) {
  switch ($PackageManager) {
    { $PackageManager.StartsWith('scoop', 'CurrentCultureIgnoreCase') } {
      $InstallerName = 'Scoop'
      $ApplicationsToInstall = @(
        '7zip'
        'bat'
        # 'cascadiafonts'
        # 'ccleaner'
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
        'less'
        # 'lockhunter'
        # 'malwarebytes'
        'make'
        # 'miktex'
        # 'nordvpn'
        'neovim'
        'nvm'
        'packer'
        'pandoc'
        'python'
        'ripgrep'
        # 'speccy'
        # 'steam'
        # 'sysinternals'
        # 'teracopy'
        'tokei'
        'vagrant'
        # 'vscode'
        # 'virtualbox'
        # 'windirstat'
        # 'zotero'
      )
      $InstallerCommand = 'scoop'
      if (-not (Get-Command -Name $InstallerCommand)) {
        "==> $InstallerName is not installed ($InstallerCommand is not an available command)" | Write-Warning
        exit
      }
      $Install = { scoop install $Args[0] }
      "==> Checking installed $PackageManager applications" | Write-Verbose
      $InstalledApplications = scoop export
    }
    Default {
      $InstallerName = 'Chocolatey'
      $ApplicationsToInstall = @(
        '7zip'
        'bat'
        'cascadiafonts'
        'ccleaner'
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
        'less'
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
        'python'
        'ripgrep'
        'speccy'
        'steam'
        'sysinternals'
        'teracopy'
        'tokei'
        'vagrant'
        'vscode'
        'virtualbox'
        'windirstat'
        'zotero'
      )
      $InstallerCommand = 'choco'
      if (-not (Get-Command -Name $InstallerCommand)) {
        "==> $InstallerName is not installed ($InstallerCommand is not an available command)" | Write-Warning
        exit
      }
      $Install = { choco install $Args[0] }
      "==> Checking installed $PackageManager applications" | Write-Verbose
      $InstalledApplications = choco list --local-only
      if ($PSCmdlet.ShouldProcess('Enable Chocolatey silent install')) {
        '==> Enabling choco silent install' | Write-Verbose
        choco feature enable -n allowGlobalConfirmation
      }
    }
  }
  function Test-Installed {
    Param(
      [Parameter(Mandatory=$True, Position=0)]
      [String] $Name
    )
    ($InstalledApplications | Where-Object { $_.StartsWith($Name, 'CurrentCultureIgnoreCase') }).Count -gt 0
  }
  "==> Installing applications with $InstallerName" | Write-Verbose
  $Count = 0
  $Total = $ApplicationsToInstall.Count
  foreach ($Application in $ApplicationsToInstall) {
    if (Test-Installed $Application) {
      "==> $Application is already installed" | Write-Verbose
    } else {
      if ($PSCmdlet.ShouldProcess("Install $Application with $InstallerName")) {
        Write-Progress -Activity "Installing applications with $InstallerName" -Status "Processing $Application ($($Count + 1) of $Total)" -PercentComplete ((($Count + 1) / $Total) * 100)
        "==> Installing $Application" | Write-Verbose
        & $Install $Application
        $Count++
      }
    }
  }
  Write-Progress -Activity "Installing applications with $InstallerName" -Completed
  "==> $Count applications were installed" | Write-Verbose
}