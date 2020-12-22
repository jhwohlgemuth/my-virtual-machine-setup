# Create environment variables for current user
$Parent = @($Env:XDG_DATA_HOME, $Env:LOCALAPPDATA)[$null -eq $Env:XDG_DATA_HOME]
$User = [System.EnvironmentVariableTarget]::User
[System.Environment]::SetEnvironmentVariable('NEOVIM_ROOT', (Join-Path $Parent 'nvim'), $User)

# Create Vim configuration file
# New-Item "$Env:NEOVIM_ROOT/init.vim" -ItemType File -Force

# Create Vim plugin folder
New-Item "$Env:NEOVIM_ROOT/plugged" -ItemType Directory -Force

#Install VIM Plugin Manager, vim-plug
$Uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
Invoke-WebRequest -UseBasicParsing $Uri | New-Item "${Env:NEOVIM_ROOT}/autoload/plug.vim" -Force