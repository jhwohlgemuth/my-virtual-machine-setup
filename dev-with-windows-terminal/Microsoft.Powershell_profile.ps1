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

$Modules = @(
    'PSScriptAnalyzer'
    'posh-git'
    'oh-my-posh'
    'Get-ChildItemColor'
    'Prelude'
)
foreach ($Module in $Modules) {
    if (Test-Installed $Module) {
        Import-Module -Name $Module
    }
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
if (Test-Command git) {
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
if (Test-Command docker) {
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
for ($i = 1; $i -le 5; $i++) {
    $u =  "".PadLeft($i,"u")
    $d =  $u.Replace("u","../")
    Invoke-Expression "function $u { push-location $d }"
}
function Install-SshServer {
    <#
    .SYNOPSIS
    Install OpenSSH server
    .LINK
    https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse
    #>
    [CmdletBinding(SupportsShouldProcess = $True)]
    Param()
    if ($PSCmdlet.ShouldProcess('OpenSSH Server Configuration')) {
        Write-Verbose '==> Enabling OpenSSH server'
        Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
        Write-Verbose '==> Starting sshd service'
        Start-Service sshd
        Write-Verbose '==> Setting sshd service to start automatically'
        Set-Service -Name sshd -StartupType 'Automatic'
        Write-Verbose '==> Adding firewall rule for sshd'
        New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
    } else {
        '==> Would have added windows OpenSSH.Server capability, started "sshd" service, and added a firewall rule for "sshd"' | Write-Color -DarkGray
    }
}
function New-DailyShutdownJob {
    <#
    .SYNOPSIS
    Create job to shutdown computer at a certain time every day
    .EXAMPLE
    New-DailyShutdownJob -At '22:00'
    #>
    [CmdletBinding()]
    [OutputType([Bool])]
    Param(
        [Parameter(Mandatory = $True)]
        [String] $At,
        [Switch] $PassThru
    )
    $Result = $False
    if (Test-Admin) {
        $Trigger = New-JobTrigger -Daily -At $At
        Register-ScheduledJob -Name 'DailyShutdown' -ScriptBlock { Stop-Computer -Force } -Trigger $Trigger
        $Result = $True
    } else {
        Write-Error '==> New-DailyShutdownJob requires Administrator privileges'
    }
    if ($PassThru) {
        $Result
    }
}
function New-SshKey {
    <#
    .SYNOPSIS
    Create new SSH key with passphrase, "123456"
    #>
    [CmdletBinding()]
    Param(
        [String] $Name = 'id_rsa'
    )
    Write-Verbose '==> Generating SSH key pair (Passphrase = 123456)'
    $Path = (Resolve-Path "~/.ssh/$Name").Path
    ssh-keygen --% -q -b 4096 -t rsa -N '123456' -f TEMPORARY_FILE_NAME
    Move-Item -Path TEMPORARY_FILE_NAME -Destination $Path
    Move-Item -Path TEMPORARY_FILE_NAME.pub -Destination "$Path.pub"
    if (Test-Path "$Path.pub") {
        Write-Verbose "==> $Name SSH private key saved to $Path"
        Write-Verbose '==> Saving SSH public key to clipboard'
        Get-Content "$Path.pub" | Set-Clipboard
        Write-Output '==> Public key saved to clipboard'
    } else {
        Write-Error '==> Failed to create SSH key'
    }
}
function Remove-DailyShutdownJob {
    <#
    .SYNOPSIS
    Remove job created with New-DailyShutdownJob
    .EXAMPLE
    Remove-DailyShutdownJob
    #>
    [CmdletBinding()]
    [OutputType([Bool])]
    Param(
        [Switch] $PassThru
    )
    $Result = $False
    if (Test-Admin) {
        Unregister-ScheduledJob -Name 'DailyShutdown'
        $Result = $True
    } else {
        Write-Error '==> Remove-DailyShutdownJob requires Administrator privileges'
    }
    if ($PassThru) {
        $Result
    }
}