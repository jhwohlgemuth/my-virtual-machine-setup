<#
.SYNOPSIS
Script for installing useful PowerShell modules and applications on Windows
#>
[CmdletBinding(SupportsShouldProcess = $True)]
Param(
    [Parameter(Position = 0)]
    [ValidateSet('Chocolatey', 'Scoop')]
    [String] $PackageManager = 'Chocolatey',
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
        Skip             Skip installing "modules" and/or "applications

    Examples:

        # Install modules and applications common to all package managers
        ./Invoke-Install.ps1

        # Only install modules
        ./Invoke-Install.ps1 -Skip applications

        # Same as above, but also install extra and applications
        ./Invoke-Install.ps1 -Include extra

        # Use Scoop to install applications, do not install python or vagrant
        ./Invoke-Install.ps1 -PackageManager Scoop -Exclude python,vagrant

    ' | Write-Output
    exit
}
function Test-Admin {
    Param()
    if ($IsLinux -is [Bool] -and $IsLinux) {
        (whoami) -eq 'root'
    } else {
        ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) | Write-Output
    }
}
function Test-Installed {
    Param(
        [Parameter(Mandatory = $True, Position = 0)]
        [String] $Name
    )
    Begin {
        function Test-CommandExists {
            Param(
                [Parameter(Mandatory = $True, Position = 0)]
                [String] $Command,
                [Switch] $Quiet
            )
            $Result = $False
            $OriginalPreference = $ErrorActionPreference
            $ErrorActionPreference = "stop"
            try {
                if (Get-Command $Command) {
                    $Result = $True
                }
            } Catch {
                if (-not $Quiet) {
                    "==> [NOT AVAILABLE] '$Command'" | Write-Warning
                }
            } Finally {
                $ErrorActionPreference = $OriginalPreference
            }
            $Result
        }
    }
    Process {
        if ($Script:InstalledApplications.Count -eq 0) {
            $Script:InstalledApplications = (Get-StartApps).Name | Sort-Object
            if (Test-CommandExists 'choco') {
                "==> [INFO] Checking installed Chocolatey applications" | Write-Verbose
                $Script:InstalledApplications += choco list --local-only
            }
            if (Test-CommandExists 'scoop') {
                "==> [INFO] Checking installed Scoop applications" | Write-Verbose
                $Script:InstalledApplications += scoop export
            }
        }
        $PrimaryName = $Name -replace '-(cli|NF|np)',''
        (Test-CommandExists -Command $Name -Quiet) -or (Test-CommandExists -Command $PrimaryName -Quiet) -or (($Script:InstalledApplications | Where-Object { $_.StartsWith($Name, 'CurrentCultureIgnoreCase') }).Count -gt 0) -or (($Script:InstalledApplications | Where-Object { $_.StartsWith($PrimaryName, 'CurrentCultureIgnoreCase') }).Count -gt 0)
    }
}
if ('modules' -notin $Skip) {
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
            'Terminal-Icons'     # https://github.com/devblackops/Terminal-Icons
            'nvm'                # https://github.com/aaronpowell/ps-nvm
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
        { $PackageManager.StartsWith('scoop', 'CurrentCultureIgnoreCase') } {
            $InstallerName = 'Scoop'
            $InstallerCommand = 'scoop'
            if (-not (Get-Command -Name $InstallerCommand)) {
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
            }
            $Install = { scoop install $Args[0] }
            $PostInstall = {
                conda init powershell
                if (('extra' -in $Include) -and ('tesseract-languages' -notin $Exclude)) { 
                    scoop reset tesseract-languages
                }
            }
        }
        Default {
            if (-not (Test-Admin)) {
                'Chocolatey requires ADMINISTRATOR privileges. Please run Invoke-Setup.ps1 as administrator.' | Write-Warning
                exit
            }
            $InstallerName = 'Chocolatey'
            $InstallerCommand = 'choco'
            if (-not (Get-Command -Name $InstallerCommand)) {
                "$InstallerName is not installed ($InstallerCommand is not an available command)" | Write-Warning
                exit
            }
            $PreInstall = { }
            $Install = { choco install $Args[0] }
            $PostInstall = { }
            if ($PSCmdlet.ShouldProcess('Enable Chocolatey silent install')) {
                '==> [INFO] Enabling choco silent install' | Write-Verbose
                choco feature enable -n allowGlobalConfirmation
            }
        }
    }
    #
    # Create list of applications to install
    #
    $Count = 0
    $ApplicationsToInstall = $AppData.Common
    $ApplicationsToInstall += switch ($InstallerName) {
        'Scoop' { $AppData.Alias.PSObject.Properties.Name }
        Default { $AppData.Alias.PSObject.Properties.Value }
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
    $Exclude += $AppData.Broken.$InstallerName
    foreach ($Application in ($ApplicationsToInstall | Sort-Object)) {
        if (Test-Installed $Application) {
            "==> [INSTALLED] $Application" | Write-Verbose
        } else {
            $ShouldInstall = $Application -notin $Exclude
            $Action = if ($ShouldInstall) { '[INSTALL]' } else { '[SKIP]' }
            if ($PSCmdlet.ShouldProcess("$Action $Application")) {
                Write-Progress -Activity "Installing applications with $InstallerName" -Status "Processing $Application ($($Count + 1) of $Total)" -PercentComplete ((($Count + 1) / $Total) * 100)
                if ($ShouldInstall) {
                    "==> [INFO] Installing $Application" | Write-Verbose
                    & $Install $Application
                } else {
                    "==> [INFO] Skipping installation of $Application" | Write-Verbose
                }
                $Count++
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
