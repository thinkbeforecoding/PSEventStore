﻿function Get-ESProjectionState {
     <#
        .SYNOPSIS
        Gets the last state of specified projection.

        .DESCRIPTION
        Gets the last state of specified projection.

        .PARAMETER StatusUrl
        The base url of the projection. Usually obtained through the pipeline.

        .PARAMETER Name
        The projection name.

        .PARAMETER Store
        The base url of the event store to use, or the remote name configured with Set-ESRemote.

        .LINK
        New-ESProjection
        Get-ESProjection
        Get-ESProjectionQuery
        Set-ESProjectionQuery
        Enable-ESProjection
        Disable-ESProjection
        Remove-ESProjection
    #>
    [CmdletBinding(DefaultParameterSetName="Name")]
    param(
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = "Url")]
        [string]$StateUrl,
        [Parameter(Position=0, Mandatory, ParameterSetName = "Name")]
        [string]$Name,
        [Parameter(ParameterSetName = "Name")]
        [string]$Store
    )

    process {
        switch($PSCmdlet.ParameterSetName) {
            Url { Invoke-RestMethod $StateUrl }
            Name { Get-ESProjection -Name $Name -Store $Store | Get-ESProjectionState }
        }
    }

}
