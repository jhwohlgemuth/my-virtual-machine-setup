#!/usr/bin/env pwsh
#Requires -Modules Prelude

[CmdletBinding(SupportsShouldProcess = $True)]
Param(
    [Parameter(Mandatory = $False, Position = 0)]
    [ValidateSet(
        'base',
        'cml',
        'gis',
        'nlp',
        'qml',
        'viz',
        'xai'
    )]
    [String[]] $Categories = 'base',
    [Parameter(Mandatory = $False, Position = 1, ValueFromPipeline = $True)]
    [String] $Name = 'default',
    [Parameter(Mandatory = $False, Position = 2)]
    [String] $Output = 'environment.yml',
    [String[]] $Exclude = @(),
    [String] $Container,
    [String] $ManifestParent = '.',
    [Switch] $Update,
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
        Join-Path $PSScriptRoot "${ManifestParent}/environment.${_}.yml"
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
    $Content = if ($PSCmdlet.ShouldProcess("[EXECUTE] Update Conda environment ${Name}")) {
        "==> [INFO] Executing: '${Command}'" | Write-Verbose
        (Invoke-Expression $Command) -replace 'name:.*$', "name: ${Name}"
    } else {
        ''
    }
    foreach ($PackageRegex in $Exclude) {
        $Content = $Content | Where-Object { $_ -notmatch  $PackageRegex }
    }
    $Content | Set-Content -Path $Output
    if (-not $NoInstall) {
        $InstallToContainer = ![String]::IsNullOrEmpty($Container)
        $SubCommand = if ($Update) { 'env update' } else { 'env create' }
        $Command = if ($InstallToContainer) {
            $Mamba = '/opt/conda/bin/mamba' # '/root/miniconda3/bin/mamba'
            "docker exec -it ${Container} /bin/zsh -c `"${Mamba} ${SubCommand} --file /root/${Output}`""
        } else {
            "mamba ${SubCommand} --prefix $Env:_CONDA_ROOT\envs\${Name} --file ${Output}"
        }
        if ($PSCmdlet.ShouldProcess("[EXECUTE] Install Conda environment")) {
            if ($InstallToContainer) {
                "==> [INFO] Copying ${Output} to ${Container} container" | Write-Verbose
                Invoke-Expression "docker cp ${Output} ${Container}:/root"
            }
            "==> [INFO] Executing: '${Command}'" | Write-Verbose
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