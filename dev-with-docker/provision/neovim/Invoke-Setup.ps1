<#
.SYNOPSIS
Script to configure Neovim on Windows
.EXAMPLE
./Invoke-Setup
#>
[CmdletBinding(SupportsShouldProcess=$True)]
Param(
    [Switch] $Force
)

$Parent = @($Env:XDG_DATA_HOME, $Env:LOCALAPPDATA)[$Null -eq $Env:XDG_DATA_HOME]
$NEOVIM_ROOT = Join-Path $Parent 'nvim'
$WhatIf = $PSCmdlet.MyInvocation.BoundParameters['WhatIf'].IsPresent -eq $True
$Count = 1
$Total = 5

"NEOVIM_ROOT = $NEOVIM_ROOT" | Write-Verbose

if ($PSCmdlet.ShouldProcess("==> [INFO] Setting Neovim environment variable to ${NEOVIM_ROOT}")) {
    Write-Progress -Activity 'Configuring Neovim' -Status 'Creating environment variables' -PercentComplete (($Count / $Total) * 100)
    '==> [INFO] Setting up environment' | Write-Verbose
    $User = [System.EnvironmentVariableTarget]::User
    $Env:NEOVIM_ROOT = $NEOVIM_ROOT # need this when being run for first time
    [System.Environment]::SetEnvironmentVariable('NEOVIM_ROOT', (Join-Path $Parent 'nvim'), $User)
    $Count++
}

Write-Progress -Activity 'Configuring Neovim' -Status 'Creating folder sructure' -PercentComplete (($Count / $Total) * 100)
'==> [INFO] Creating install destination folder structure' | Write-Verbose
'general','plugged','plug-config','snippets','themes','undo' | ForEach-Object {
    New-Item "${NEOVIM_ROOT}/$_" -ItemType Directory -Force -WhatIf:$WhatIf | Out-Null
}
$Count++

Write-Progress -Activity 'Configuring Neovim' -Status 'Copying configuration files' -PercentComplete (($Count / $Total) * 100)
'==> [INFO] Copying configuration files' | Write-Verbose
Copy-Item -Force:$Force -WhatIf:$WhatIf "$PSScriptRoot/init.vim" $NEOVIM_ROOT | Out-Null
Copy-Item -Force:$Force -WhatIf:$WhatIf "$PSScriptRoot/coc-settings.json" $NEOVIM_ROOT | Out-Null
Copy-Item -Force:$Force -WhatIf:$WhatIf "$PSScriptRoot/general/settings.vim" (Join-Path $NEOVIM_ROOT 'general') | Out-Null
Copy-Item -Force:$Force -WhatIf:$WhatIf "$PSScriptRoot/general/plugins.vim" (Join-Path $NEOVIM_ROOT 'general') | Out-Null
Copy-Item -Force:$Force -WhatIf:$WhatIf "$PSScriptRoot/plug-config/coc.vim" (Join-Path $NEOVIM_ROOT 'plug-config') | Out-Null
Copy-Item -Force:$Force -WhatIf:$WhatIf "$PSScriptRoot/plug-config/fzf.vim" (Join-Path $NEOVIM_ROOT 'plug-config') | Out-Null
Copy-Item -Force:$Force -WhatIf:$WhatIf "$PSScriptRoot/plug-config/which-key.vim" (Join-Path $NEOVIM_ROOT 'plug-config') | Out-Null
$Count++

Write-Progress -Activity 'Configuring Neovim' -Status 'Copying One Dark theme' -PercentComplete (($Count / $Total) * 100)
'==> [INFO] Copying One Dark theme' | Write-Verbose
Copy-Item -Force:$Force -WhatIf:$WhatIf "$PSScriptRoot/themes/onedark.vim" (Join-Path $NEOVIM_ROOT 'themes') | Out-Null
$Count++