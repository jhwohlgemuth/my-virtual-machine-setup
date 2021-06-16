<#
.SYNOPSIS
Setup script for installing useful PowerShell modules and applications on Windows
.PARAMETER PackageManager
Name of package manager to use ("Chocolatey" or "Scoop")
> Note: Scoop does not provide all of the applications that are available via Chocolatey
.PARAMETER Exclude
Array of application names that should not be installed
.PARAMETER Exclusive
Install applications exclusive to selected package manager
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
    [Parameter(Position = 0)]
    [ValidateSet('choco', 'Chocalatey', 'Scoop')]
    [String] $PackageManager = 'Chocolatey',
    [String[]] $Exclude = '',
    [Switch] $Exclusive,
    [Switch] $SkipModules,
    [Switch] $SkipApplications
)
function Test-Admin {
    Param()
    if ($IsLinux -is [Bool] -and $IsLinux) {
        (whoami) -eq 'root'
    } else {
        ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) | Write-Output
    }
}
function Test-CommandExists {
    Param (
        [Parameter(Mandatory = $True, Position = 0)]
        [String] $Command
    )
    $Result = $False
    $OriginalPreference = $ErrorActionPreference
    $ErrorActionPreference = "stop"
    try {
        if (Get-Command $Command) {
            $Result = $True
        }
    } Catch {
        "==> '$Command' is not available command" | Write-Verbose
    } Finally {
        $ErrorActionPreference = $OriginalPreference
    }
    $Result
}
function Install-ModuleMaybe {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True)]
        [String] $Name
    )
    if (Get-Module -ListAvailable -Name $Name) {
        "==> $Name already installed" | Write-Verbose
    } else {
        "==> Installing $Name" | Write-Verbose
        Install-Module -Name $Name -Scope CurrentUser -AllowClobber
    }
}
if (-not $SkipModules) {
    if (-not (Test-Admin)) {
        'Installing PowerShell modules requires ADMINISTRATOR privileges. Please run Invoke-Setup.ps1 as administrator, or use the -SkipModules option.' | Write-Warning
        exit
    } else {
        $Modules = @(
            'Prelude'
            'posh-git'           # https://github.com/dahlbyk/posh-git
            'oh-my-posh'         # https://github.com/JanDeDobbeleer/oh-my-posh
            'PSConsoleTheme'     # https://github.com/mmims/PSConsoleTheme
            'PSScriptAnalyzer'   # https://github.com/PowerShell/PSScriptAnalyzer
            'Get-ChildItemColor' # https://github.com/joonro/Get-ChildItemColor
            'nvm'                # https://github.com/aaronpowell/ps-nvm
        )
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
}
if (-not $SkipApplications) {
    $Common = @(
        '7zip'
        'bat'
        'dos2unix'
        'fd'
        'fzf'
        'git'
        'jq'
        'lazydocker'
        'lazygit'
        'less'
        'make'
        'neovim'
        'nvm'
        'packer'
        'pandoc'
        'python'
        'pwsh'
        'ripgrep'
        'tokei'
        'vagrant'
    )
    $ExclusiveScoop = @(
        'fciv'
        'ngrok'
    )
    $ExclusiveChocolatey = @(
        'beaker'
        'cascadiafonts'
        'ccleaner'
        'dropbox'
        'firacode'
        'firefox'
        'googlechrome'
        'googledrive'
        'insomnia-rest-api-client'
        'itunes'
        'jetbrainsmono'
        'lockhunter'
        'malwarebytes'
        'miktex'
        'nordvpn'
        'speccy'
        'steam'
        'sysinternals'
        'teracopy'
        'vscode'
        'virtualbox'
        'windirstat'
        'zotero'
    )
    switch ($PackageManager) {
        { $PackageManager.StartsWith('scoop', 'CurrentCultureIgnoreCase') } {
            $InstallerName = 'Scoop'
            $ApplicationsToInstall = $ExclusiveScoop
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
            if (-not (Test-Admin)) {
                'Chocolatey requires ADMINISTRATOR privileges. Please run Invoke-Setup.ps1 as administrator.' | Write-Warning
                exit
            }
            $InstallerName = 'Chocolatey'
            $ApplicationsToInstall = $ExclusiveChocolatey
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
        (Test-CommandExists $Name) -or (($InstalledApplications | Where-Object { $_.StartsWith($Name, 'CurrentCultureIgnoreCase') }).Count -gt 0)
    }
    "==> Installing applications with $InstallerName" | Write-Verbose
    $Count = 0
    if (-not $Exclusive) {
        $ApplicationsToInstall += $Common
    }
    $Total = $ApplicationsToInstall.Count
    foreach ($Application in ($ApplicationsToInstall | Sort-Object)) {
        if (Test-Installed $Application) {
            "==> $Application is already installed" | Write-Verbose
        } else {
            $Action = if ($Application -notin $Exclude) { 'Install' } else { 'Skip installation of' }
            if ($PSCmdlet.ShouldProcess("$Action $Application with $InstallerName")) {
                Write-Progress -Activity "Installing applications with $InstallerName" -Status "Processing $Application ($($Count + 1) of $Total)" -PercentComplete ((($Count + 1) / $Total) * 100)
                if ($Application -notin $Exclude) {
                    "==> Installing $Application" | Write-Verbose
                    & $Install $Application
                } else {
                    "==> Skipping installation of $Application" | Write-Color -Red
                }
                $Count++
            }
        }
    }
    Write-Progress -Activity "Installing applications with $InstallerName" -Completed
    "==> $Count applications were installed" | Write-Verbose
}
