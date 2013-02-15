function Remove-ESProjection {
    <#
        .SYNOPSIS
        Removes the specified projection from the EventStore.

        .DESCRIPTION
        Removes the specified projection from the EventStore.

        .PARAMETER StatusUrl
        The base url of the projection. Usually obtained through the pipeline.

        .PARAMETER Name
        The projection name.

        .PARAMETER Store
        The base url of the event store to use, or the remote name configured with Set-ESRemote.

        .LINK
        New-ESProjection
        Get-ESProjection
        Get-ESProjectionState
        Get-ESProjectionQuery
        Set-ESProjectionQuery
        Enable-ESProjection
        Disable-ESProjection
    #>
    [CmdletBinding(DefaultParameterSetName="Name")]
    param(
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = "Url")]
        [string]$StatusUrl,
        [Parameter(Position=0, Mandatory, ParameterSetName = "Name")]
        [string]$Name,
        [Parameter(ParameterSetName = "Name")]
        [string]$Store
    )
    process {
        switch($PSCmdlet.ParameterSetName) {
            Url { Invoke-RestMethod $StatusUrl -Method Delete | Out-Null }
            Name { Get-ESProjection -Name $Name -Store $Store | Remove-ESProjection }
        }
    }
}