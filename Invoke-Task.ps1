#!/usr/bin/env pwsh
#Requires -Modules Prelude

[CmdletBinding(SupportsShouldProcess = $True)]
Param(
    [ValidateSet(
        'base',
        'dotnet',
        'jvm',
        'lambda',
        'notebook',
        'python',
        'rust',
        'web'
    )]
    [Parameter(Mandatory = $False, Position = 0)]
    [String] $Type,
    [Parameter(Mandatory = $False)]
    [Switch] $Create,
    [Parameter(Mandatory = $False)]
    [ValidateSet('ssh', 'git')]
    [String[]] $Configure = @(),
    [Parameter(Mandatory = $False)]
    [String] $Name = 'notebook',
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
        ImageName = "ghcr.io/${Namespace}/${Type}"
    }
}
function New-Container {
    <#
    .SYNOPSIS
    Create a new container
    #>
    [CmdletBinding(SupportsShouldProcess = $True)]
    Param(
        [Parameter(Mandatory = $True, Position = 0)]
        [String] $Type,
        [String] $Namespace
    )
    $Context = Get-Context -Type $Type -Namespace $Namespace
    $BaseCommand = 'docker run -dit --security-opt seccomp=unconfined'
    $Volume = "$($Context.Homepath)/dev:/root/dev"
    $Options = @{
        Gpus = 'all'
        Name = $Name
        Hostname = $Context.Hostname
        Volume = $Volume
    } | ConvertTo-ParameterString
    $Ports = switch ($Type) {
        'web' {
            @(
                1337
                4873
                8000
                8080
                8111
                13337
            )
        }
        default {
            @(
                1337
                3000
                13337
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
    "==> [INFO] Created `"${Name}`" container from `"${Type}`" image" | Write-Color -Green
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
    Start-Container -Name $Name
    switch ($Configure) {
        'git' {
            $Command = "docker cp ${Env:USERPROFILE}/.gitconfig ${Name}:/root/.gitconfig"
            $Command | Write-Verbose
            if ($PSCmdlet.ShouldProcess("==> [INFO] Copy .gitconfig")) {
                Invoke-Expression $Command
                "==> [INFO] Copied .gitconfig file to ${Name}" | Write-Color -Green
            }
        }
        'ssh' {
            $SshKey = "${Env:USERPROFILE}\.ssh\id_ed25519"
            $SshConfig = "${Env:USERPROFILE}\.ssh\config"
            if (Test-Path $SshKey) {
                $Command = "docker exec -it ${Name} /bin/bash -c `"mkdir -p /root/.ssh`""
                $Command | Write-Verbose
                if ($PSCmdlet.ShouldProcess("==> [INFO] Create .ssh directory")) {
                    Invoke-Expression $Command
                    "==> [INFO] Created .ssh directory on ${Name}" | Write-Color -Green
                }
                $Command = "docker cp $SshKey ${Name}:/root/.ssh/"
                $Command | Write-Verbose
                if ($PSCmdlet.ShouldProcess("==> [INFO] Copy SSH key")) {
                    Invoke-Expression $Command
                    "==> [INFO] Copied SSH key to ${Name}" | Write-Color -Green
                }
                $Command = "docker exec -it ${Name} /bin/bash -c `"chmod 600 /root/.ssh/id_ed25519`""
                $Command | Write-Verbose
                if ($PSCmdlet.ShouldProcess("==> [INFO] Fix SSH key permissions")) {
                    Invoke-Expression $Command
                    "==> [INFO] Fixed SSH key permissions on ${Name}" | Write-Color -Green
                }
            }
            if (Test-Path $SshConfig) {
                $Command = "docker cp ${SshConfig} ${Name}:/root/.ssh/"
                $Command | Write-Verbose
                if ($PSCmdlet.ShouldProcess("==> [INFO] Copy SSH configuration")) {
                    Invoke-Expression $Command
                    "==> [INFO] Copied SSH configuration to ${Name}" | Write-Color -Green
                }
            }
        }
    }
}