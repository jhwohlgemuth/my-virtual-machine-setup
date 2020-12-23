[CmdletBinding()]
Param()

'==> Creating NEOVIM_ROOT environment variable' | Write-Verbose
$Parent = @($Env:XDG_DATA_HOME, $Env:LOCALAPPDATA)[$null -eq $Env:XDG_DATA_HOME]
$User = [System.EnvironmentVariableTarget]::User
[System.Environment]::SetEnvironmentVariable('NEOVIM_ROOT', (Join-Path $Parent 'nvim'), $User)

'==> Creating Neovim plugin folder' | Write-Verbose
New-Item "$Env:NEOVIM_ROOT/plugged" -ItemType Directory -Force | Out-Null

'==> Creating init.vim configuration file' | Write-Verbose
Copy-Item "$PSScriptRoot/init.vim" $Env:NEOVIM_ROOT | Out-Null

'==> Creating coc.vim plugin settings file' | Write-Verbose
Copy-Item "$PSScriptRoot/coc-settings.json" $Env:NEOVIM_ROOT | Out-Null

'==> Installing Vim plugin manager, vim-plug' | Write-Verbose
$Uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
Invoke-WebRequest -UseBasicParsing $Uri | New-Item "${Env:NEOVIM_ROOT}/autoload/plug.vim" -Force | Out-Null