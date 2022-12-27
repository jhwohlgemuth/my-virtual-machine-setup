[CmdletBinding()]
Param(
    [Parameter(Mandatory = $True, Position = 0)]
    [String] $Command,
    [Switch] $Quiet
)
$Result = $False
$OriginalPreference = $ErrorActionPreference
$ErrorActionPreference = "stop"
try {
    if (Get-Command $Command) {
        $Result = $True
    }
} Catch {
    if (-not $Quiet) {
        "==> [NOT AVAILABLE] '$Command'" | Write-Warning
    }
} Finally {
    $ErrorActionPreference = $OriginalPreference
}
$Result