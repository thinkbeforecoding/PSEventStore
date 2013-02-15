function Set-ESProjectionQuery {
     <#
        .SYNOPSIS
        Set the js query for a projection.

        .DESCRIPTION
        Set the js query for a projection.

        .PARAMETER StatusUrl
        The base url of the projection. Usually obtained through the pipeline.

        .PARAMETER Name
        The projection name.

        .PARAMETER Query
        The js query definition. Use completion to cycle through query templates.

        .PARAMETER Store
        The base url of the event store to use, or the remote name configured with Set-ESRemote.

        .LINK
        New-ESProjection
        Get-ESProjection
        Get-ESProjectionState
        Get-ESProjectionQuery
        Enable-ESProjection
        Disable-ESProjection
        Remove-ESProjection
    #>

    [CmdletBinding(DefaultParameterSetName="Name")]
    param(
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = "Url", Position=0, Mandatory)]
        [string]$StatusUrl,
        [Parameter(Position=0, Mandatory, ParameterSetName = "Name")]
        [string]$Name,
        [Parameter(Position=1, Mandatory, ParameterSetName = "Url")]
        [Parameter(Position=1, Mandatory, ParameterSetName = "Name")]
        [string]$Query,
        [Parameter(ParameterSetName = "Name")]
        [string]$Store
    )
    process {
        switch($PSCmdlet.ParameterSetName) {
            Url { Invoke-RestMethod $StatusUrl/query -Method Put -Body $Query | Out-Null }
            Name { Get-ESProjection -Name $Name -Store $Store | Set-ESProjectionQuery -Query $Query }
        }
    }
}