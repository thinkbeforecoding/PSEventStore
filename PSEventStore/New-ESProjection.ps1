Add-Type -TypeDefinition "namespace EventStore { public enum ProjectionMode { OneTime, Continuous } }" -ErrorAction SilentlyContinue

function New-ESProjection {
     <#
        .SYNOPSIS
        Creates a new projection.

        .DESCRIPTION
        Creates a new projection.

        .PARAMETER Name
        The projection name.

        .PARAMETER Mode
        The projection mode. Can be OneTime or Continuous.

        .PARAMETER Query
        The js query definition. Use completion to cycle through query templates.

        .PARAMETER Store
        The base url of the event store to use, or the remote name configured with Set-ESRemote.

        .LINK
        Get-ESProjection
        Get-ESProjectionState
        Get-ESProjectionQuery
        Set-ESProjectionQuery
        Enable-ESProjection
        Disable-ESProjection
        Remove-ESProjection
    #>
    param(
        [Parameter(Position=0)]
        [string]$Name,
        [Parameter(Position=1)]
        [EventStore.ProjectionMode]$Mode,
        [Parameter(Position=2)]
        [string]$Query,
        [switch]$Enabled = $true,
        [switch]$Emit,
        [switch]$Checkpoints,
        [string]$Store
    )

    end {
        switch($Mode) {
           OneTime { $m = 'oneTime'}
           Continuous { $m = 'continuous' }
        }
        $en = if ($Enabled) { 'yes' } else { 'no' }
        $e = if ($Emit) { 'yes' } else { 'no' }
        $c = if ($Checkpoints) { 'yes' } else { 'no' }
        $base = Get-ESRemote $Store
        $r = Invoke-WebRequest ("$base/projections/$m" + "?name=$Name&type=JS&emit=$e&checkpoints=$c&enabled=$en") -Method Post -Body $Query
        $uri = $r.Headers['Location']
        
        Get-ESProjection -StatusUrl $uri
    }
}