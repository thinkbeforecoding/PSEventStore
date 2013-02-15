function Remove-ESStream {
     <#
        .SYNOPSIS
        Remove a stream from the event store.

        .DESCRIPTION
        Remove a stream from the event store.

        .PARAMETER Stream
        The stream name.

        .PARAMETER ExpectedVersion
        The version of the last expected event in the stream.
        -2 for any, this is the default.

        .PARAMETER Store
        The base url of the event store to use.

        .NOTES
        When not specified, the default value for $Store is $global:Store.
        Define $global:Store default value in profile to access it by default.

        .LINK
        Get-ESEvent
        New-ESEvent
        Write-ESEvent
    #>

    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Name,
        [int]$ExpectedVersion = -2,
        [string]$Store = $Global:Store
    )

    process {
        $payload = @{
            ExpectedVersion = $ExpectedVersion
        }

        $body = (ConvertTo-Json $payload -Depth ([int]::MaxValue))
        Invoke-WebRequest $Store/streams/$Name -Method Delete -ContentType "application/json" -Body $body | Out-Null
    }


}