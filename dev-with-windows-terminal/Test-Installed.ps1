[CmdletBinding()]
Param(
    [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True)]
    [Array] $Names,
    [Array] $Search = @()
)
Begin {
    function Test-MatchStart() {
        Param(
            [Parameter(Mandatory = $True, Position = 0)]
            [String] $A,
            [Parameter(Mandatory = $True, Position = 1)]
            [String] $B
        )
        $A.StartsWith($B, 'CurrentCultureIgnoreCase')
    }
    function Invoke-TestName() {
        Param(
            [Parameter(Mandatory = $True, Position = 0)]
            [String] $Value
        )
        $AugmentedValue = $Value -replace '-(cli|NF|np)',''
        $CommandExists = (./Test-Command.ps1 -Command $Value -Quiet) -or (./Test-Command.ps1 -Command $AugmentedValue -Quiet)
        $ApplicationNames = $Script:InstalledApplications.Where({ (Test-MatchStart $_ $Value) -or (Test-MatchStart $_ $AugmentedValue) })
        $CommandFound = $ApplicationNames.Count -gt 0
        $CommandExists -or $CommandFound
    }
    $Script:InstalledApplications = if ($Search.Count -gt 0) { $Search } else { ./Get-Installed.ps1 }
    if ($Names.Count -gt 0) {
        $Names | ForEach-Object { Invoke-TestName $_ }
    }
}
End {
    if ($Input.Count -gt 0) {
        $Input | ForEach-Object { Invoke-TestName $_ }
    }
}