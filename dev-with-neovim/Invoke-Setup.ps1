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
$WhatIf = $PSBoundParameters.ContainsKey('WhatIf')
$Count = 1
$Total = 5
if ($PSCmdlet.ShouldProcess('Create environment variables')) {
  Write-Progress -Activity 'Configuring Neovim' -Status 'Creating environment variables' -PercentComplete (($Count / $Total) * 100)
  '==> Setting up environment' | Write-Verbose
  $Parent = @($Env:XDG_DATA_HOME, $Env:LOCALAPPDATA)[$Null -eq $Env:XDG_DATA_HOME]
  $User = [System.EnvironmentVariableTarget]::User
  [System.Environment]::SetEnvironmentVariable('NEOVIM_ROOT', (Join-Path $Parent 'nvim'), $User)
  $Count++
}

Write-Progress -Activity 'Configuring Neovim' -Status 'Creating folder sructure' -PercentComplete (($Count / $Total) * 100)
'==> Creating install destination folder structure' | Write-Verbose
'general','plugged','plug-config','snippets','themes','undo' | ForEach-Object {
  New-Item "$Env:NEOVIM_ROOT/$_" -ItemType Directory -Force -WhatIf:$WhatIf | Out-Null
}
$Count++

Write-Progress -Activity 'Configuring Neovim' -Status 'Copying configuration files' -PercentComplete (($Count / $Total) * 100)
'==> Copying configuration files' | Write-Verbose
Copy-Item -Force:$Force -WhatIf:$WhatIf "$PSScriptRoot/init.vim" $Env:NEOVIM_ROOT | Out-Null
Copy-Item -Force:$Force -WhatIf:$WhatIf "$PSScriptRoot/coc-settings.json" $Env:NEOVIM_ROOT | Out-Null
Copy-Item -Force:$Force -WhatIf:$WhatIf "$PSScriptRoot/general/settings.vim" (Join-Path $Env:NEOVIM_ROOT 'general') | Out-Null
Copy-Item -Force:$Force -WhatIf:$WhatIf "$PSScriptRoot/general/plugins.vim" (Join-Path $Env:NEOVIM_ROOT 'general') | Out-Null
Copy-Item -Force:$Force -WhatIf:$WhatIf "$PSScriptRoot/plug-config/coc.vim" (Join-Path $Env:NEOVIM_ROOT 'plug-config') | Out-Null
Copy-Item -Force:$Force -WhatIf:$WhatIf "$PSScriptRoot/plug-config/fzf.vim" (Join-Path $Env:NEOVIM_ROOT 'plug-config') | Out-Null
Copy-Item -Force:$Force -WhatIf:$WhatIf "$PSScriptRoot/plug-config/which-key.vim" (Join-Path $Env:NEOVIM_ROOT 'plug-config') | Out-Null
$Count++

Write-Progress -Activity 'Configuring Neovim' -Status 'Copying One Dark theme' -PercentComplete (($Count / $Total) * 100)
'==> Copying One Dark theme' | Write-Verbose
Copy-Item -Force:$Force -WhatIf:$WhatIf "$PSScriptRoot/themes/onedark.vim" (Join-Path $Env:NEOVIM_ROOT 'themes') | Out-Null
$Count++

if ($PSCmdlet.ShouldProcess('Download and install Vim plugin manager')) {
  Write-Progress -Activity 'Configuring Neovim' -Status 'Installing Vim plugin manager' -PercentComplete (($Count / $Total) * 100)
  '==> Installing Vim plugin manager, vim-plug' | Write-Verbose
  $Uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  Invoke-WebRequest -UseBasicParsing $Uri |
    New-Item -Force "${Env:NEOVIM_ROOT}/autoload/plug.vim" |
    Out-Null
  $Count++
}