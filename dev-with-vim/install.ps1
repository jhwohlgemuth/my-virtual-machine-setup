[CmdletBinding()]
Param()

'==> Setting up environment' | Write-Verbose
$Parent = @($Env:XDG_DATA_HOME, $Env:LOCALAPPDATA)[$null -eq $Env:XDG_DATA_HOME]
$User = [System.EnvironmentVariableTarget]::User
[System.Environment]::SetEnvironmentVariable('NEOVIM_ROOT', (Join-Path $Parent 'nvim'), $User)

'==> Creating install destination folder structure' | Write-Verbose
'general','plugged','plug-config','themes' | ForEach-Object {
  New-Item "$Env:NEOVIM_ROOT/$_" -ItemType Directory -Force | Out-Null
}

'==> Copying configuration files' | Write-Verbose
Copy-Item "$PSScriptRoot/init.vim" $Env:NEOVIM_ROOT | Out-Null
Copy-Item "$PSScriptRoot/coc-settings.json" $Env:NEOVIM_ROOT | Out-Null
Copy-Item "$PSScriptRoot/settings.vim" (Join-Path $Env:NEOVIM_ROOT 'general') | Out-Null
Copy-Item "$PSScriptRoot/plugins.vim" (Join-Path $Env:NEOVIM_ROOT 'general') | Out-Null
Copy-Item "$PSScriptRoot/coc.vim" (Join-Path $Env:NEOVIM_ROOT 'plug-config') | Out-Null
Copy-Item "$PSScriptRoot/fzf.vim" (Join-Path $Env:NEOVIM_ROOT 'plug-config') | Out-Null
Copy-Item "$PSScriptRoot/which-key.vim" (Join-Path $Env:NEOVIM_ROOT 'plug-config') | Out-Null
Copy-Item "$PSScriptRoot/onedark.vim" (Join-Path $Env:NEOVIM_ROOT 'themes') | Out-Null

'==> Installing Vim plugin manager, vim-plug' | Write-Verbose
$Uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
Invoke-WebRequest -UseBasicParsing $Uri |
  New-Item "${Env:NEOVIM_ROOT}/autoload/plug.vim" -Force |
  Out-Null