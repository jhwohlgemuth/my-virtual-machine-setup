#!/usr/bin/env pwsh
#Requires -Modules Prelude

[CmdletBinding()]
Param(
    [Parameter(Mandatory = $False, Position = 0)]
    [ValidateSet(
        'base',
        'cml',
        'gis',
        'qml',
        'viz',
        'xai'
    )]
    [String[]] $Categories = 'base',
    [Parameter(Mandatory = $False, Position = 1, ValueFromPipeline = $True)]
    [String] $Name = 'default',
    [Parameter(Mandatory = $False, Position = 2)]
    [String] $Output = 'environment.yml',
    [Switch] $NoInstall,
    [Switch] $Persist,
    [Switch] $Force
)
Begin {
    if (-not (Test-Command conda-merge)) {
        "==> [ERROR] Command 'conda-merge' not found" | Write-Color -Red
        exit
    }
    if (-not (Test-Command mamba)) {
        "==> [ERROR] Command 'mamba' not found" | Write-Color -Red
        exit
    }
    $Files = $Categories | ForEach-Object {
        Join-Path $PSScriptRoot "../conda/environment.${_}.yml"
    }
    foreach ($File in $Files) {
        if (Test-Path -Path $File) {
            "==> [INFO] Environment file found: $($File | Resolve-Path)" | Write-Verbose
        } else {
            "==> [ERROR] Environment file not found: ${File}" | Write-Color -Red
            if (-not $Force) {
                exit
            }
        }
    }
}
End {
    $Arguments = ($Files | ForEach-Object { "`"$($_ | Resolve-Path)`"" }) -join ' '
    $Command = "conda-merge ${Arguments}"
    "==> [INFO] Executing: '${Command}'" | Write-Verbose
    $Content = if ($PSCmdlet.ShouldProcess("[EXECUTE] '${Command}'")) {
        (Invoke-Expression $Command) -replace 'name:.*$', "name: ${Name}"
    } else {
        ''
    }
    $Content | Set-Content -Path $Output
    if (-not $NoInstall) {
        $Command = "mamba env create --file ${Output}"
        "==> [INFO] Executing: '${Command}'" | Write-Verbose
        if ($PSCmdlet.ShouldProcess("[EXECUTE] '${Command}'")) {
            Invoke-Expression $Command
        }
    }
    if (-not $Persist) {
        if ($PSCmdlet.ShouldProcess("[REMOVE] ${Output}")) {
            Remove-Item $Output
        }
    }
    $Content
}