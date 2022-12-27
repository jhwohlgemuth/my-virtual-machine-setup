#
# Import Powershell modules
#
function Test-Installed {
    Param(
        [Parameter(Mandatory = $True, Position = 0)]
        [String] $Name
    )
    Get-Module -ListAvailable -Name $Name
}
if (Test-Installed PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
}

$Modules = @(
    'PSScriptAnalyzer'
    'posh-git'
    'Terminal-Icons'
    'Prelude'
)
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
foreach ($Module in $Modules) {
    if (Test-Installed $Module) {
        Import-Module -Name $Module
    }
}
#
# Initialize oh-my-posh and set custom theme
#
oh-my-posh init pwsh --config ~/.theme.omp.json | Invoke-Expression
#
# Import Chocolatey profile
#
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path $ChocolateyProfile) {
    Import-Module -Name "$ChocolateyProfile"
}
#
# Set aliases
#
if (Test-Command -Name git) {
    function Invoke-GitCommand { git $Args }
    function Invoke-GitCommit { git commit -vam $Args }
    function Invoke-GitDiff { git diff $Args }
    function Invoke-GitPushMaster { git push origin master }
    function Invoke-GitStatus { git status -sb }
    function Invoke-GitRebase { git rebase -i $Args }
    function Invoke-GitCheckout {
        Param(
            [Parameter(Position = 0)]
            [String] $File = '.'
        )
        git checkout -- $File
    }
    function Invoke-GitLog { git log --oneline --decorate }
    Set-Alias -Scope Global -Option AllScope -Name g -Value Invoke-GitCommand
    Set-Alias -Scope Global -Option AllScope -Name gcam -Value Invoke-GitCommit
    Set-Alias -Scope Global -Option AllScope -Name gd -Value Invoke-GitDiff
    Set-Alias -Scope Global -Option AllScope -Name glo -Value Invoke-GitLog
    Set-Alias -Scope Global -Option AllScope -Name gpom -Value Invoke-GitPushMaster
    Set-Alias -Scope Global -Option AllScope -Name grbi -Value Invoke-GitRebase
    Set-Alias -Scope Global -Option AllScope -Name gsb -Value Invoke-GitStatus
    Set-Alias -Scope Global -Option AllScope -Name gco -Value Invoke-GitCheckout
}
if (Test-Command -Name docker) {
    $Format = "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"
    function Invoke-DockerProcess { docker ps --format $Format }
    function Invoke-DockerProcessAll { docker ps -a --format $Format }
    function Invoke-DockerInspectAddress { docker inspect --format '{{ .NetworkSettings.IPAddress }}' $Args[0] }
    function Invoke-DockerRemoveAll { docker stop $(docker ps -a -q); docker rm --force $(docker ps -a -q) }
    function Invoke-DockerRemoveAllImage { docker rmi --force $(docker images -a -q) }
    Set-Alias -Scope Global -Option AllScope -Name dps -Value Invoke-DockerProcess
    Set-Alias -Scope Global -Option AllScope -Name dpa -Value Invoke-DockerProcessAll
    Set-Alias -Scope Global -Option AllScope -Name dip -Value Invoke-DockerInspectAddress
    Set-Alias -Scope Global -Option AllScope -Name dra -Value Invoke-DockerRemoveAll
    Set-Alias -Scope Global -Option AllScope -Name dri -Value Invoke-DockerRemoveAllImage
}
#
# Zoxide setup
#
if (Test-Command -Name zoxide) {
    Invoke-Expression (& {
        $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
        (zoxide init --hook $hook powershell) -join "`n"
    })
}
#
# Create directory traversal shortcuts
#
for ($i = 1; $i -le 5; $i++) {
    $u =  ''.PadLeft($i, 'u')
    $d =  $u.Replace('u', '../')
    Invoke-Expression "function $u { push-location $d }"
}