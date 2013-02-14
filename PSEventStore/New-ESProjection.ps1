Add-Type -TypeDefinition "namespace EventStore { public enum ProjectionMode { OneTime, Continuous } }"

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
        The base url of the event store to use.

        .NOTES
        When not specified, the default value for $Store is $global:Store.
        Define $global:Store default value in profile to access it by default.

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
        [string]$Store = $Global:Store
    )

    end {
        switch($Mode) {
           OneTime { $m = 'oneTime'}
           Continuous { $m = 'continuous' }
        }
        $r = Invoke-WebRequest ("$Store/projections/$m" + "?name=$Name&type=JS") -Method Post -Body $Query
        $uri = $r.Headers['Location']
        
        Get-ESProjection -Uri $uri
    }
}