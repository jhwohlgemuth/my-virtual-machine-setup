#
# Install Powershell modules, if not already installed
#
function Test-Installed
{
  $Name = $args[0]
  Get-Module -ListAvailable -Name $Name
}
if (Test-Installed PSReadLine) {
  Import-Module PSReadLine
  Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
  Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
  Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
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
if (Test-Installed pwsh-handy-helpers) {
  Import-Module pwsh-handy-helpers
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
# Directory traversal shortcuts
#
for($i = 1; $i -le 5; $i++) {
  $u =  "".PadLeft($i,"u")
  $d =  $u.Replace("u","../")
  Invoke-Expression "function $u { push-location $d }"
}