function Get-ESProjection {
     <#
        .SYNOPSIS
        Gets the projection.

        .DESCRIPTION
        Gets the projection.

        .PARAMETER StatusUrl
        The base url of the projection. Usually obtained through the pipeline.

        .PARAMETER Name
        The projection name.

        .PARAMETER Store
        The base url of the event store to use.

        .NOTES
        When not specified, the default value for $Store is $global:Store.
        Define $global:Store default value in profile to access it by default.

        .LINK
        New-ESProjection
        Get-ESProjectionState
        Get-ESProjectionQuery
        Set-ESProjectionQuery
        Enable-ESProjection
        Disable-ESProjection
        Remove-ESProjection
    #>    
    [CmdletBinding(DefaultParameterSetName="Name")]
    param(
        [Parameter(Position = 0, ParameterSetName="Name")]
        [string]$Name = '*',
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName="Url")]
        [string]$StatusUrl,
        [Parameter(ParameterSetName="Name")]
        [string]$Store = $Global:store
    )

    end {
        switch($PSCmdlet.ParameterSetName) {
            Name { 
                irm $store/projections/all-non-transient | % projections | Set-PSType EventStore.Projection | ? name -Like $Name 
            }
            Url {
                irm $StatusUrl/statistics | % projections | Set-PSType EventStore.Projection 
            }
        }

        
    }
}
