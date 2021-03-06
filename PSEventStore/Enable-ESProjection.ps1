﻿function Enable-ESProjection {
     <#
        .SYNOPSIS
        Enables the projection.

        .DESCRIPTION
        Enable the projection.

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
        Disable-ESProjection
        Remove-ESProjection
    #>    
    [CmdletBinding(DefaultParameterSetName="Name")]
    param(
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName='Url')]
        [string]$StatusUrl,
        [Parameter(Position=0, Mandatory, ParameterSetName='Name')]
        [string]$Name,
        [Parameter( ParameterSetName='Name')]
        [string]$Store
    )

    process {
        
         switch($PSCmdlet.ParameterSetName) {
            Url { Invoke-RestMethod $statusUrl/command/enable -Method Post | Out-Null }
            Name { Get-ESProjection -Name $Name -Store $Store | Enable-ESProjection }
        }
   }
}