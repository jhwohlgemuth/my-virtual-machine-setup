<#
.SYNOPSIS
Setup script for configuring Windows Terminal
.PARAMETER Initial
Use if first time using this script. Creates ~/dev directory and installs Git using Scoop.
.PARAMETER SkipInstall
Whether or not to install PowerShell modules and Scoop applications.
.PARAMETER SkipNeovim
Whether or not to configure Neovim.
.PARAMETER Theme
The name of the oh-my-posh theme to use.
.EXAMPLE
# Change the terminal theme (without installing anything)
./Invoke-Setup.ps1 -Theme princess
.EXAMPLE
# Run the script to see what it would do without changing anything
./Invoke-Setup.ps1 -Verbose -WhatIf
#>
[CmdletBinding(SupportsShouldProcess = $True)]
Param(
    [Switch] $Initial,
    [Switch] $SkipInstall,
    [Switch] $SkipNeovim,
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
    [Switch] $Force
)

$Root = $PSScriptRoot
$TerminalRoot = Join-Path $Root 'dev-with-windows-terminal'
$NeovimRoot = Join-Path $Root 'dev-with-neovim'
$LocalSettingsPath = "$Env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$Verbose = $PSCmdlet.MyInvocation.BoundParameters['Verbose'].IsPresent -eq $True
$WhatIf = $PSCmdlet.MyInvocation.BoundParameters['WhatIf'].IsPresent -eq $True

function Test-Admin {
    Param()
    if ($IsLinux -is [Bool] -and $IsLinux) {
        (whoami) -eq 'root'
    } else {
        ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) | Write-Output
    }
}
# Install Git if running for the first time
if ($Initial) {
    if ($PSCmdlet.ShouldProcess('==> [INFO] Create dev folder and install git')) {
        New-Item -ItemType Directory -Name dev -Path (Join-Path $Env:USERPROFILE 'dev') -Force
        scoop install git
    }
}
# Install PowerShell modules (if admin) and install Scoop applications
if (-not $SkipInstall) {
    Set-Location $TerminalRoot
    if (Test-Admin) {
        & .\Invoke-Install.ps1 -PackageManager 'Scoop' -Skip 'applications' -Verbose:$Verbose -WhatIf:$WhatIf
    }
    '==> [INFO] Install options:' | Write-Verbose
    $InstallOptions | ConvertTo-Json | Write-Verbose
    & .\Invoke-Install.ps1 @InstallOptions -Verbose:$Verbose -WhatIf:$WhatIf
    Set-Location $Root
} else {
    '==> [INFO] Skipping execution of Invoke-Install.ps1' | Write-Verbose
}
# Copy Makefile to user root folder
if ($PSCmdlet.ShouldProcess('==> [INFO] Copy Makefile to user root')) {
    Copy-Item -Path 'Makefile' -Destination $Env:USERPROFILE -Force
}
# Copy windows terminal profile
if ($PSCmdlet.ShouldProcess('==> [INFO] Copy profile configuration')) {
    "==> [INFO] Copying profile configuration to ${PROFILE}" | Write-Verbose
    Set-Content -Path $PROFILE -Value (Get-Content -Path (Join-Path $TerminalRoot 'Microsoft.Powershell_profile.ps1'))
}
# Copy windows terminal settings.json
if ($PSCmdlet.ShouldProcess('==> [INFO] Copy settings JSON file')) {
    "==> [INFO] Copying settings.json to ${LocalSettingsPath}" | Write-Verbose
    Set-Content -Path $LocalSettingsPath -Value (Get-Content -Path (Join-Path $TerminalRoot 'settings.json'))
}
# Update oh-my-posh theme
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
if (-not $SkipNeovim) {
    Set-Location $NeovimRoot
    & .\Invoke-Setup.ps1 -Force:$Force -Verbose:$Verbose -WhatIf:$WhatIf
    Set-Location $Root
}