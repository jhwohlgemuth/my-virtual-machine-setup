#!/usr/bin/env pwsh

/home/linuxbrew/.linuxbrew/bin/brew install jandedobbeleer/oh-my-posh/oh-my-posh
New-Item -Path '/root/.config/powershell' -ItemType Directory -Force
Move-Item '/root/profile.ps1' $PROFILE -Force
@(
    'Prelude'
    'posh-git'
    'Terminal-Icons'
) | ForEach-Object {
    Install-Module -Name $_ -Scope CurrentUser -Force
}