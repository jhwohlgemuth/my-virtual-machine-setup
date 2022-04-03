<#
.SYNOPSIS
Setup script for configuring Windows Terminal and development environment.
.PARAMETER SkipApplications
Whether or not to install PowerShell modules and Scoop applications.
.PARAMETER Neovim
Whether or not to configure Neovim.
.PARAMETER Theme
The name of the oh-my-posh theme to use.
.PARAMETER Standalone
Use if running script outside of env repo (downloads jhwohlgemuth/env repo)
.EXAMPLE
# Change the terminal theme (without installing anything)
./Invoke-Setup.ps1 -Theme princess
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
    [ValidateSet(
        'agnoster',
        'aliens',
        'blueish',
        'iterm2',
        'lambda',
        'microverse',
        'night-owl',
        'paradox',
        'powerlevel',
        'princess',
        'tonybaloney',
        'robbyrussel',
        'slim',
        'space',
        'star',
        'wopian'
    )]
    [String] $Theme = 'powerlevel',
    [Switch] $Standalone,
    [Switch] $Force
)
function Test-Admin {
    Param()
    if ($IsLinux -is [Bool] -and $IsLinux) {
        (whoami) -eq 'root'
    } else {
        ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) | Write-Output
    }
}
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
    if ($PSCmdlet.ShouldProcess('==> [INFO] Install Git')) {
        scoop install git
    }
}
#
# Create ~/dev directory
#
New-Item -ItemType Directory -Name dev -Path $DevDirectory -Force @CmdletParameters
if ($Standalone) {
    if ($PSCmdlet.ShouldProcess('==> [INFO] Clone jhwohlgemuth/env repo')) {
        Set-Location -Path $DevDirectory
        git clone https://github.com/jhwohlgemuth/env.git
    }
}
#
# Install PowerShell modules
#
if (Test-Admin) {
    Set-Location -Path $TerminalRoot
    & .\Invoke-Install.ps1 -Skip 'applications' @CmdletParameters
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
    & .\Invoke-Install.ps1 @InstallOptions @CmdletParameters
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
# Copy windows terminal settings.json
#
"==> [INFO] Copying settings.json to ${LocalSettingsPath}" | Write-Verbose
Set-Content -Path $LocalSettingsPath -Value (Get-Content -Path (Join-Path $TerminalRoot 'settings.json')) @CmdletParameters
#
# Update oh-my-posh theme
#
$ThemeName = @{
    'agnoster'    = 'agnoster'
    'aliens'      = 'aliens'
    'blueish'     = 'blueish'
    'iterm2'      = 'iterm2'
    'lambda'      = 'lambda'
    'microverse'  = 'microverse-power'
    'night-owl'   = 'night-owl'
    'paradox'     = 'paradox'
    'powerlevel'  = 'powerlevel10k_rainbow'
    'princess'    = 'M365Princess'
    'tonybaloney' = 'tonybaloney'
    'robbyrussel' = 'robbyrussel'
    'slim'        = 'slim'
    'space'       = 'space'
    'star'        = 'star'
    'wopian'      = 'wopian'
}[$Theme]
if ($PSCmdlet.ShouldProcess("==> [INFO] Update oh-my-posh theme to ${ThemeName}")) {
    "==> [INFO] Updating oh-my-posh theme to ${ThemeName}" | Write-Verbose
    Set-PoshPrompt -Theme $ThemeName
    ((Get-Content -path $PROFILE -Raw) -replace 'Set-PoshPrompt -Theme .*\r\n', "Set-PoshPrompt -Theme ${ThemeName}`n") | Set-Content -Path $PROFILE
}
#
# Install and configure Neovim
#
if ($Neovim) {
    Set-Location -Path (Join-Path $Root 'dev-with-neovim')
    & .\Invoke-Setup.ps1 -Force:$Force @CmdletParameters
    Set-Location -Path $Root
}
Set-Location -Path $DevDirectory