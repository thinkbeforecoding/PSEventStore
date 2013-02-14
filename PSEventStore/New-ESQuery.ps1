function New-ESQuery {
    <#
        .SYNOPSIS
        Creates an new EventStore transient query.

        .DESCRIPTION
        Creates an new EventStore transient query.
        Use Get-ESProjectionState to query current state, or Execute-ESQuery to define and run it.

        .PARAMETER Query
        The query javascript definition.

        .PARAMETER Disabled
        Start the query in disabled mode.

        .PARAMETER Store
        The base url of the event store to use.

        .NOTES
        When not specified, the default value for $Store is $global:Store.
        Define $global:Store default value in profile to access it by default.

        .LINK
        Get-ESProjectionState
        Execute-ESQuery
    #>

    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory)]
        [string]$Query,
        [switch]$Disabled,
        [string]$Store = $Global:Store
    )
    end {
        try {
            $r = Invoke-WebRequest "$Store/projections/transient?emit=no&checkpoints=no&enabled=$(if ($Disabled) { "no"} else { "yes" })" -Method POST -Body $Query -ErrorAction Stop

            $url = $r.Headers['Location']
            Get-ESProjection -StatusUrl $url
        } catch {
            throw $_
        }
    }
}

