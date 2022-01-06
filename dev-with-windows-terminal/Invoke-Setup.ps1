<#
.SYNOPSIS
Setup script for configuring Windows Terminal
#>
[CmdletBinding(SupportsShouldProcess = $True)]
Param(
    [Switch] $Initial,
    [Switch] $EnableRemoting,
    [Switch] $SkipInstall,
    [PSObject] $InstallOptions = @{ PackageManager = 'Scoop'; Include = 'extra'}
)
if (-not $SkipInstall) {
    if ($PSCmdlet.ShouldProcess('==> [RUN] Invoke-Install.ps1')) {
        '==> [RUN] Executing Invoke-Install.ps1' | Write-Verbose
        '==> [INFO] Install options:' | Write-Verbose
        $InstallOptions | Write-Verbose
        & .\Invoke-Install.ps1 @InstallOptions
    }
} else {
    '==> [INFO] Skipping execution of Invoke-Install.ps1' | Write-Verbose
}
# Copy windows terminal profile
if ($PSCmdlet.ShouldProcess('==> [INFO] Copy profile configuration')) {
    "==> [INFO] Copying profile configuration to ${PROFILE}" | Write-Verbose
    Set-Content -Path $PROFILE -Value (Get-Content -Path .\Microsoft.Powershell_profile.ps1)
}
# Copy windows terminal settings.json
if ($PSCmdlet.ShouldProcess('==> [INFO] Copy settings JSON file')) {
    $LocalSettingsPath = "$Env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    "==> [INFO] Copying settings.json to ${LocalSettingsPath}" | Write-Verbose
    Set-Content -Path $LocalSettingsPath -Value (Get-Content -Path .\settings.json)
}