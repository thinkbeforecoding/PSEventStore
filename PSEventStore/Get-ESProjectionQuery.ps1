function Get-ESProjectionQuery {
     <#
        .SYNOPSIS
        Gets the projection js query definition.

        .DESCRIPTION
        Gets the projection js query definition.

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
        Get-ESProjection
        Get-ESProjectionState
        Set-ESProjectionQuery
        Enable-ESProjection
        Disable-ESProjection
        Remove-ESProjection
    #>
    [CmdletBinding(DefaultParameterSetName="Name")]
    param(
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = "Url")]
        [string]$StatusUrl,
        [Parameter(Position=0, Mandatory, ParameterSetName = "Name")]
        [string]$Name,
        [Parameter(ParameterSetName = "Name")]
        [string]$Store = $Global:Store
    )
    process {
        switch($PSCmdlet.ParameterSetName) {
            Url { Invoke-RestMethod $StatusUrl/query }
            Name { Get-ESProjection -Name $Name -Store $Store | Get-ESProjectionQuery }
        }
    }
}