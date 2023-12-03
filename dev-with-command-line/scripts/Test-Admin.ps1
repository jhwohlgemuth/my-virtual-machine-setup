Param()
if ($IsLinux -is [Bool] -and $IsLinux) {
    (whoami) -eq 'root'
} else {
    ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) | Write-Output
}