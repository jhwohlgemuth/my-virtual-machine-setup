#!/usr/bin/env pwsh

/home/linuxbrew/.linuxbrew/bin/brew install jandedobbeleer/oh-my-posh/oh-my-posh
New-Item -Path '/root/.config/powershell' -ItemType Directory -Force
Install-Module -Name Prelude -Scope CurrentUser -Force
Install-Module -Name posh-git -Scope CurrentUser -Force
Install-Module -Name Terminal-Icons -Scope CurrentUser -Force
Move-Item profile.ps1 $PROFILE -Force