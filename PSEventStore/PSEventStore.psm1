if (!$global:store) {
    $global:store = "http://127.0.0.1:2113"
}

. $PSScriptRoot\Set-PSType.ps1
. $PSScriptRoot\Remove-PSType.ps1

. $PSScriptRoot\Get-ESEvent.ps1
. $PSScriptRoot\New-ESEvent.ps1
. $PSScriptRoot\Write-ESEvent.ps1
. $PSScriptRoot\Get-ESStream.ps1

. $PSScriptRoot\Get-ESProjection.ps1
. $PSScriptRoot\New-ESProjection.ps1
. $PSScriptRoot\Remove-ESProjection.ps1

. $PSScriptRoot\Disable-ESProjection.ps1
. $PSScriptRoot\Enable-ESProjection.ps1

. $PSScriptRoot\Get-ESProjectionQuery.ps1
. $PSScriptRoot\Set-ESProjectionQuery.ps1

. $PSScriptRoot\Get-ESProjectionState.ps1

. $PSScriptRoot\New-ESQuery.ps1
. $PSScriptRoot\Invoke-ESQuery.ps1

. $PSScriptRoot\Get-ESStatistics.ps1

Import-Module PSCompletion -Global -ErrorAction SilentlyContinue

if (Get-Module PSCompletion -ErrorAction SilentlyContinue) {
. $PSScriptRoot\PSCompletion.ps1
}
