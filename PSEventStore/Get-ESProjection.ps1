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
        The base url of the event store to use, or the remote name configured with Set-ESRemote.

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
        [string]$Store
    )

    end {
        switch($PSCmdlet.ParameterSetName) {
            Name { 
                $base = Get-ESRemote $Store
                Invoke-RestMethod $base/projections/all-non-transient | % projections | Set-PSType EventStore.Projection | ? name -Like $Name 
            }
            Url {
                Invoke-RestMethod $StatusUrl/statistics | % projections | Set-PSType EventStore.Projection 
            }
        }

        
    }
}
