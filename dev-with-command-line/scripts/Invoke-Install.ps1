<#
.SYNOPSIS
Script for installing useful PowerShell modules and applications on Windows
#>
[CmdletBinding(SupportsShouldProcess = $True)]
Param(
    [Parameter(Position = 0)]
    [ValidateSet('Homebrew', 'Chocolatey', 'Scoop', 'Winget')]
    [String] $PackageManager = 'Scoop',
    [String] $Path = '.\Applications.json',
    [ValidateSet('extra')]
    [String[]] $Include,
    [String[]] $Exclude = '',
    [ValidateSet('modules', 'applications')]
    [String[]] $Skip,
    [Switch] $Help
)
if ($Help) {
    '
    Description:

        Setup script for installing useful PowerShell modules and applications on Windows

    Parameters:

        PackageManager   Name of package manager to use ("Chocolatey" or "Scoop")
        Path             Path to application manifest (list of which applications to install)
        Include          Install applications from certain groups: "extra"
                             - Extra = applications I use a lot but are not directly related to development (scoop and choco provide different applications)
        Exclude          String array of application names that should not be installed
        Skip             Skip installing "modules" and/or "applications"

    Examples:

        # Install modules and applications common to all package managers
        ./Invoke-Install.ps1

        # Only install modules
        ./Invoke-Install.ps1 -Skip applications

        # Same as above, but also install extra and applications
        ./Invoke-Install.ps1 -Include extra

        # Use Scoop to install applications, do not install tesseract-languages
        ./Invoke-Install.ps1 -PackageManager Chocolatey -Exclude tesseract-languages

    ' | Write-Output
    exit
}
if ('modules' -notin $Skip) {
    if (-not (& "${PSScriptRoot}/Test-Admin.ps1")) {
        'Installing PowerShell modules requires ADMINISTRATOR privileges. Please run Invoke-Setup.ps1 as administrator, or use the -SkipModules option.' | Write-Warning
        exit
    } else {
        $Modules = @(
            'Prelude'
            'posh-git'         # https://github.com/dahlbyk/posh-git
            'PSConsoleTheme'   # https://github.com/mmims/PSConsoleTheme
            'PSScriptAnalyzer' # https://github.com/PowerShell/PSScriptAnalyzer
            'Terminal-Icons'   # https://github.com/devblackops/Terminal-Icons
            'nvm'              # https://github.com/aaronpowell/ps-nvm
        )
        '==> [INFO] Installing PowerShell modules...' | Write-Verbose
        if ($PSCmdlet.ShouldProcess('[INSTALL] Nuget package provider')) {
            '==> [INFO] Installing Nuget package provider' | Write-Verbose
            Install-PackageProvider Nuget -MinimumVersion 2.8.5.201 -Force
        }
        foreach ($Name in $Modules) {
            if ($PSCmdlet.ShouldProcess("[INSTALL] $Name PowerShell module")) {
                if (Get-Module -ListAvailable -Name $Name) {
                    "==> [INSTALLED] $Name" | Write-Verbose
                } else {
                    "==> [INFO] Installing $Name..." | Write-Verbose
                    Install-Module -Name $Name -Scope CurrentUser -AllowClobber
                }
            }
        }
    }
} else {
    '==> [INFO] Skipping installation of modules' | Write-Verbose
}
if ('applications' -notin $Skip) {
    $AppData = Get-Content $Path | ConvertFrom-Json
    switch ($PackageManager) {
        { $PackageManager.StartsWith('homebrew', 'CurrentCultureIgnoreCase') } {
            $InstallerName = 'Homebrew'
            $InstallerCommand = 'brew'
            if (-not (& "${PSScriptRoot}/Test-Command.ps1" -Command $InstallerCommand -Quiet)) {
                "$InstallerName is not installed ($InstallerCommand is not an available command)" | Write-Warning
                exit
            }
            $PreInstall = { }
            $Install = { }
            $PostInstall = { }
        }
        { $PackageManager.StartsWith('choco', 'CurrentCultureIgnoreCase') } {
            if (-not (& "${PSScriptRoot}/Test-Admin.ps1")) {
                'Chocolatey requires ADMINISTRATOR privileges. Please run Invoke-Setup.ps1 as administrator.' | Write-Warning
                exit
            }
            $InstallerName = 'Chocolatey'
            $InstallerCommand = 'choco'
            if (-not (& "${PSScriptRoot}/Test-Command.ps1" -Command $InstallerCommand -Quiet)) {
                "$InstallerName is not installed ($InstallerCommand is not an available command)" | Write-Warning
                exit
            }
            $PreInstall = {
                '==> [INFO] Enabling choco silent install' | Write-Verbose
                choco feature enable -n allowGlobalConfirmation
            }
            $Install = { choco install $Args[0] }
            $PostInstall = { }
        }
        { $PackageManager.StartsWith('winget', 'CurrentCultureIgnoreCase') } {
            $InstallerName = 'Winget'
            $InstallerCommand = 'winget'
            if (-not (& "${PSScriptRoot}/Test-Command.ps1" -Command $InstallerCommand -Quiet)) {
                "$InstallerName is not installed ($InstallerCommand is not an available command)" | Write-Warning
                exit
            }
            $PreInstall = { winget install JanDeDobbeleer.OhMyPosh -s winget }
            $Install = { winget install $Args[0] }
            $PostInstall = { }
        }
        Default {
            $InstallerName = 'Scoop'
            $InstallerCommand = 'scoop'
            if (-not (& "${PSScriptRoot}/Test-Command.ps1" -Command $InstallerCommand -Quiet)) {
                "$InstallerName is not installed ($InstallerCommand is not an available command)" | Write-Warning
                exit
            }
            $PreInstall = {
                '==> [INFO] Adding scoop buckets' | Write-Verbose
                $Buckets = scoop bucket list
                'extras', 'nerd-fonts', 'nonportable', 'java' | ForEach-Object {
                    if ($_ -notin $Buckets) {
                        scoop bucket add $_
                    }
                }
                '==> [INFO] Installing oh-my-posh' | Write-Verbose
                scoop install 'https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh.json'
            }
            $Install = { scoop install $Args[0] }
            $PostInstall = {
                if ('miniconda3' -notin $Exclude) {
                    Invoke-Conda init powershell
                }
                if (('extra' -in $Include) -and ('tesseract-languages' -notin $Exclude)) {
                    scoop reset tesseract-languages
                }
            }
        }
    }
    #
    # Create list of applications to install
    #
    $Count = 0
    $ApplicationsToInstall = [System.Collections.Generic.HashSet[string]]@()
    foreach ($Application in $AppData.Common) {
        $ApplicationsToInstall.Add($Application) | Out-Null
    }
    if ($Include -contains 'extra') {
        $ApplicationsToInstall += $AppData.Extra.Common
    }
    $Include | ForEach-Object {
        $ApplicationsToInstall += $AppData.$_.$InstallerName
    }
    $Total = $ApplicationsToInstall.Count
    #
    # Perform PRE installation actions
    #
    if ($PSCmdlet.ShouldProcess("Perform PRE installation actions")) {
        & $PreInstall
    }
    #
    # Install applications
    #
    "==> [INFO] Installing applications with $InstallerName" | Write-Verbose
    $Exclude += $AppData.Broken.$PackageManager
    $InstalledApplications = & "${PSScriptRoot}/Get-Installed.ps1" -All
    foreach ($Application in ($ApplicationsToInstall | Sort-Object)) {
        $Installed = & "${PSScriptRoot}/Test-Installed.ps1" $Application -Search $InstalledApplications
        $Alias = $AppData.Alias.$PackageManager.$Application
        $App =  if ($Alias) { $Alias } else { $Application }
        if ($Installed) {
            "==> [INSTALLED] $Application" | Write-Verbose
        } else {
            $ShouldInstall = $Application -notin $Exclude
            $Action = if ($ShouldInstall) { '[INSTALL]' } else { '[SKIP]' }
            if ($PSCmdlet.ShouldProcess("$Action $App")) {
                Write-Progress -Activity "Installing applications with $InstallerName" -Status "Processing $App ($($Count + 1) of $Total)" -PercentComplete ((($Count + 1) / $Total) * 100)
                if ($ShouldInstall) {
                    "==> [INFO] Installing $App" | Write-Verbose
                    & $Install $App
                } else {
                    "==> [INFO] Skipping installation of $App" | Write-Verbose
                }
                $Count++
            }
            if ($Alias) {
                "==> [INFO] ${Alias} will be used instead of ${Application}" | Write-Verbose
            }
        }
    }
    #
    # Perform POST installation actions
    #
    if ($PSCmdlet.ShouldProcess("Perform POST installation actions")) {
        & $PostInstall
    }
    Write-Progress -Activity "Installing applications with $InstallerName" -Completed
    "==> [INFO] $Count applications were installed" | Write-Verbose
} else {
    '==> [INFO] Skipping installation of applications' | Write-Verbose
}
