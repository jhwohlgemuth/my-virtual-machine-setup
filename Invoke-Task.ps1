#Requires -Modules Prelude

[CmdletBinding(SupportsShouldProcess = $True)]
Param(
    [ValidateSet('env', 'notebook')]
    [Parameter(Mandatory = $True, Position = 0)]
    [String] $Type,
    [Parameter(Mandatory = $False)]
    [Switch] $Create,
    [Parameter(Mandatory = $False)]
    [ValidateSet('ssh', 'git')]
    [String[]] $Configure = @(),
    [String] $Namespace = 'jhwohlgemuth'
)
function Get-Context {
    <#
    .SYNOPSIS
    Get task variables
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True)]
        [String] $Type,
        [String] $Namespace
    )
    @{
        Homepath = $Env:USERPROFILE
        Hostname = (hostname)
        ImageName = "${Namespace}/${Type}"
    }
}
function New-Container {
    <#
    .SYNOPSIS
    Create a new container
    .PARAM Type
    dev or notebook
    #>
    [CmdletBinding(SupportsShouldProcess = $True)]
    Param(
        [Parameter(Mandatory = $True, Position = 0)]
        [String] $Type,
        [String] $Namespace
    )
    $Context = Get-Context -Type $Type -Namespace $Namespace
    $BaseCommand = 'docker run -dit --init --security-opt seccomp=unconfined'
    $Volume = switch ($Type) {
        'env' {
            "$($Context.Homepath)/dev:/root/dev"
        }
        'notebook' {
            "$($Context.Homepath)/dev/notebooks:/root/dev/notebooks"
        }
    }
    $Options = @{
        Gpus = 'all'
        Name = $Type
        Hostname = $Context.Hostname
        Volume = $Volume
    } | ConvertTo-ParameterString
    $Ports = switch ($Type) {
        'env' {
            @(
                1337
                3449
                4669
                8000
                8080
                8111
                46692
            )
        }
        'notebook' {
            @(
                4669
            )
        }
    }
    $PortsString = $Ports | ForEach-Object { "-p ${_}:${_}" }
    $Command = "${BaseCommand} ${Options} ${PortsString} $($Context.ImageName)"
    "==> [INFO] Creating ${Type} container" | Write-Color -Yellow
    $Command | Write-Verbose
    if ($PSCmdlet.ShouldProcess("==> [INFO] Create ${Type} container")) {
        Invoke-Expression $Command
    }
    "==> [INFO] Created ${Type} container" | Write-Color -Green
}
function Start-Container {
    <#
    .SYNOPSIS
    Start a docker container
    #>
    [CmdletBinding(SupportsShouldProcess = $True)]
    Param(
        [Parameter(Mandatory = $True, Position = 0)]
        [String] $Name
    )
    $Command = "docker start ${Name}"
    if ($PSCmdlet.ShouldProcess("==> [INFO] Start container")) {
        Invoke-Expression $Command | Out-Null
        "==> [INFO] Started ${Name} container" | Write-Color -Green
    }
}
if ($Create) {
    Get-Context -Type $Type | ConvertTo-Json | Write-Verbose
    New-Container -Type $Type -Namespace $Namespace
}
if ($Configure) {
    Start-Container -Name $Type
    switch ($Configure) {
        'git' {
            $Command = "docker cp ${Env:USERPROFILE}/.gitconfig ${Type}:/root/.gitconfig"
            $Command | Write-Verbose
            if ($PSCmdlet.ShouldProcess("==> [INFO] Copy .gitconfig")) {
                Invoke-Expression $Command
                "==> [INFO] Copied .gitconfig file to ${Type}" | Write-Color -Green
            }
        }
        'ssh' {
            $SshKey = "${Env:USERPROFILE}\.ssh\id_ed25519"
            $SshConfig = "${Env:USERPROFILE}\.ssh\config"
            if (Test-Path $SshKey) {
                $Command = "docker exec -it ${Type} /bin/bash -c `"mkdir -p /root/.ssh`""
                $Command | Write-Verbose
                if ($PSCmdlet.ShouldProcess("==> [INFO] Create .ssh directory")) {
                    Invoke-Expression $Command
                    "==> [INFO] Created .ssh directory on ${Type}" | Write-Color -Green
                }
                $Command = "docker cp $SshKey ${Type}:/root/.ssh/"
                $Command | Write-Verbose
                if ($PSCmdlet.ShouldProcess("==> [INFO] Copy SSH key")) {
                    Invoke-Expression $Command
                    "==> [INFO] Copied SSH key to ${Type}" | Write-Color -Green
                }
                $Command = "docker exec -it ${Type} /bin/bash -c `"chmod 600 /root/.ssh/id_ed25519`""
                $Command | Write-Verbose
                if ($PSCmdlet.ShouldProcess("==> [INFO] Fix SSH key permissions")) {
                    Invoke-Expression $Command
                    "==> [INFO] Fixed SSH key permissions on ${Type}" | Write-Color -Green
                }
            }
            if (Test-Path $SshConfig) {
                $Command = "docker cp ${SshConfig} ${Type}:/root/.ssh/"
                $Command | Write-Verbose
                if ($PSCmdlet.ShouldProcess("==> [INFO] Copy SSH configuration")) {
                    Invoke-Expression $Command
                    "==> [INFO] Copied SSH configuration to ${Type}" | Write-Color -Green
                }
            }
        }
    }
}