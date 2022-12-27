<#
.SYNOPSIS
Setup script for configuring Windows Terminal and development environment.
.PARAMETER SkipApplications
Whether or not to install PowerShell modules and Scoop applications.
.PARAMETER Neovim
Whether or not to configure Neovim.
.PARAMETER Standalone
Use if running script outside of env repo (downloads jhwohlgemuth/env repo)
.EXAMPLE
# Run the script to see what it would do without changing anything
./Invoke-Setup.ps1 -Verbose -WhatIf
.EXAMPLE
# Also install and configure Neovim
./Invoke-Setup.ps1 -Neovim
#>
[CmdletBinding(SupportsShouldProcess = $True)]
Param(
    [Switch] $SkipApplications,
    [Switch] $Neovim,
    [PSObject] $InstallOptions = @{ PackageManager = 'Scoop'; Include = 'extra'; Skip = 'modules' },
    [Switch] $Standalone,
    [Switch] $Force
)
#
# Set script variables
#
$DevDirectory = Join-Path $Env:USERPROFILE 'dev'
$EnvDirectory = Join-Path $DevDirectory 'env'
$Root = if ($Standalone) { $PSScriptRoot } else { $EnvDirectory }
$TerminalRoot = Join-Path $Root 'dev-with-windows-terminal'
$LocalSettingsPath = "$Env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$CmdletParameters = @{
    Verbose = $PSCmdlet.MyInvocation.BoundParameters['Verbose'].IsPresent -eq $True
    WhatIf = $PSCmdlet.MyInvocation.BoundParameters['WhatIf'].IsPresent -eq $True
}
#
# Install Git (if required)
#
if (-not (Get-Command -Name git -ErrorAction Ignore)) {
    if ($PSCmdlet.ShouldProcess('Install Git')) {
        scoop install git
    }
}
#
# Create ~/dev directory
#
New-Item -ItemType Directory -Name dev -Path $DevDirectory -Force @CmdletParameters
if ($Standalone) {
    if ($PSCmdlet.ShouldProcess('Clone jhwohlgemuth/env repo')) {
        Set-Location -Path $DevDirectory
        git clone https://github.com/jhwohlgemuth/env.git
    }
}
#
# Install PowerShell modules
#
if (./dev-with-windows-terminal/scripts/Test-Admin.ps1) {
    Set-Location -Path $TerminalRoot
    & .\scripts\Invoke-Install.ps1 -Skip 'applications' @CmdletParameters
    Set-Location -Path $Root
} else {
    '==> [INFO] Skipping installation of PowerShell modules' | Write-Verbose
}
#
# Install applications
#
if (-not $SkipApplications) {
    Set-Location -Path $TerminalRoot
    '==> [INFO] Install options:' | Write-Verbose
    $InstallOptions | ConvertTo-Json | Write-Verbose
    & .\scripts\Invoke-Install.ps1 @InstallOptions @CmdletParameters
    Set-Location -Path $Root
} else {
    "==> [INFO] Skipping installation of $($InstallOptions.PackageManager) applications" | Write-Verbose
}
# Copy Makefile to user root folder
#
"==> [INFO] Copying Makefile to $($Env:USERPROFILE)" | Write-Verbose
Copy-Item -Path 'Makefile' -Destination $Env:USERPROFILE -Force @CmdletParameters
#
# Copy windows terminal profile
#
"==> [INFO] Copying profile configuration to ${PROFILE}" | Write-Verbose
Set-Content -Path $PROFILE -Value (Get-Content -Path (Join-Path $TerminalRoot 'Microsoft.Powershell_profile.ps1')) @CmdletParameters
#
# Copy custom oh-my-posh theme
#
"==> [INFO] Copying custom oh-my-posh theme to ${HOME}" | Write-Verbose
Set-Content -Path "${HOME}/.theme.omp.json" -Value (Get-Content -Path (Join-Path $Root 'dev-with-docker/config/.theme.omp.json')) @CmdletParameters
#
# Copy windows terminal settings.json
#
"==> [INFO] Copying settings.json to ${LocalSettingsPath}" | Write-Verbose
Set-Content -Path $LocalSettingsPath -Value (Get-Content -Path (Join-Path $TerminalRoot 'settings.json')) @CmdletParameters
#
# Install and configure Neovim
#
if ($Neovim) {
    Set-Location -Path (Join-Path $Root 'dev-with-docker/provision/neovim')
    & .\Invoke-Setup.ps1 -Force:$Force @CmdletParameters
    Set-Location -Path $Root
}
Set-Location -Path $Root