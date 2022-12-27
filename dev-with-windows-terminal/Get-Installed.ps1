[CmdletBinding()]
Param(
    [Parameter(Mandatory = $False, Position = 0)]
    [ValidateSet('Start', 'Chocolatey', 'Scoop', 'Winget')]
    [String[]] $Include,
    [Switch] $All
)
$Script:OldWhatIf = $WhatIfPreference
$WhatIfPreference = $False
$InstalledApplications = [System.Collections.Generic.HashSet[String]]@()
if ($All -or ($Include -contains 'Start')) {
    (Get-StartApps).Name | Sort-Object | ForEach-Object { $InstalledApplications.Add($_.ToLower()) | Out-Null }
}
if ($All -or ($Include -contains 'Chocolatey')) {
    if (./Test-Command.ps1 'choco') {
        "==> [INFO] Getting installed Chocolatey packages" | Write-Verbose
        $Temp = 'INSTALLED_CHOCOLATEY_APPLICATIONS.xml'
        choco export -o $Temp | Out-Null
        [XML]$ChocoPackages = Get-Content $Temp
        $ChocoPackages.packages.package.id | ForEach-Object { $InstalledApplications.Add($_.ToLower()) | Out-Null }
        Remove-Item $Temp
    }
}
if ($All -or ($Include -contains 'Scoop')) {
    if (./Test-Command.ps1 'scoop') {
        "==> [INFO] Getting installed Scoop apps" | Write-Verbose
        $Temp = 'INSTALLED_SCOOP_APPLICATIONS.json'
        scoop export > $Temp
        $Apps = Get-Content $Temp | ConvertFrom-Json
        $Apps.Apps.Name | ForEach-Object { $InstalledApplications.Add($_.ToLower()) | Out-Null }
        Remove-Item $Temp
    }
}
if ($All -or ($Include -contains 'Winget')) {
    if (./Test-Command.ps1 'winget') {
        "==> [INFO] Getting installed Winget packages" | Write-Verbose
        $Temp = 'INSTALLED_WINGET_APPLICATIONS.json'
        winget export --output $Temp | Out-Null
        $Apps = Get-Content $Temp | ConvertFrom-Json
        $Apps.Sources[0].Packages.PackageIdentifier | ForEach-Object { $InstalledApplications.Add($_.ToLower()) | Out-Null }
        Remove-Item $Temp
    }
}
$WhatIfPreference = $Script:OldWhatIf
$InstalledApplications | Sort-Object