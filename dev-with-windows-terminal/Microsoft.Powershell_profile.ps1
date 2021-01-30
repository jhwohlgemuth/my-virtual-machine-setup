#
# Import Powershell modules
#
function Test-Installed {
    $Name = $Args[0]
    Get-Module -ListAvailable -Name $Name
}
if (Test-Installed PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
}
if (Test-Installed PSScriptAnalyzer) {
    Import-Module PSScriptAnalyzer
}
if (Test-Installed posh-git) {
    Import-Module posh-git
}
if (Test-Installed oh-my-posh) {
    Import-Module oh-my-posh
}
if (Test-Installed Get-ChildItemColor) {
    Import-Module Get-ChildItemColor
}
if (Test-Installed Prelude) {
    Import-Module Prelude
}
#
# Set Oh-my-posh theme
#
Set-Theme Agnoster
#
# Import Chocolatey profile
#
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path $ChocolateyProfile) {
    Import-Module "$ChocolateyProfile"
}
#
# Set aliases
#
if (Test-Installed Get-ChildItemColor) {
    Set-Alias -Scope Global -Option AllScope -Name la -Value Get-ChildItemColor
    Set-Alias -Scope Global -Option AllScope -Name ls -Value Get-ChildItemColorFormatWide
}
if (Get-Command -Name git) {
    function Invoke-GitCommand { git $Args }
    function Invoke-GitCommit { git commit -vam $Args }
    function Invoke-GitDiff { git diff $Args }
    function Invoke-GitPushMaster { git push origin master }
    function Invoke-GitStatus { git status -sb }
    function Invoke-GitRebase { git rebase -i $Args }
    function Invoke-GitLog { git log --oneline --decorate }
    Set-Alias -Scope Global -Option AllScope -Name g -Value Invoke-GitCommand
    Set-Alias -Scope Global -Option AllScope -Name gcam -Value Invoke-GitCommit
    Set-Alias -Scope Global -Option AllScope -Name gd -Value Invoke-GitDiff
    Set-Alias -Scope Global -Option AllScope -Name glo -Value Invoke-GitLog
    Set-Alias -Scope Global -Option AllScope -Name gpom -Value Invoke-GitPushMaster
    Set-Alias -Scope Global -Option AllScope -Name grbi -Value Invoke-GitRebase
    Set-Alias -Scope Global -Option AllScope -Name gsb -Value Invoke-GitStatus
}
if (Get-Command -Name docker) {
    function Invoke-DockerInspectAddress { docker inspect --format '{{ .NetworkSettings.IPAddress }}' $Args[0] }
    function Invoke-DockerRemoveAll { docker stop $(docker ps -a -q); docker rm --force $(docker ps -a -q) }
    function Invoke-DockerRemoveAllImage { docker rmi --force $(docker images -a -q) }
    Set-Alias -Scope Global -Option AllScope -Name dip -Value Invoke-DockerInspectAddress
    Set-Alias -Scope Global -Option AllScope -Name dra -Value Invoke-DockerRemoveAll
    Set-Alias -Scope Global -Option AllScope -Name drai -Value Invoke-DockerRemoveAllImage
}
#
# Create directory traversal shortcuts
#
for($i = 1; $i -le 5; $i++) {
    $u =  "".PadLeft($i,"u")
    $d =  $u.Replace("u","../")
    Invoke-Expression "function $u { push-location $d }"
}