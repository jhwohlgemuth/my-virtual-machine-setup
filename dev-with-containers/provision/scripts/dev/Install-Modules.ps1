#!/usr/bin/env pwsh

@(
    'posh-git'
    'Prelude'
    'Terminal-Icons'
) | ForEach-Object { Install-Module -Name $_ -Scope CurrentUser -Force }