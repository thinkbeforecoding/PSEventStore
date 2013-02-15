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
        The base url of the event store to use, or the remote name configured with Set-ESRemote.

        .LINK
        Get-ESEvent
        New-ESEvent
        Write-ESEvent
    #>

    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Name,
        [int]$ExpectedVersion = -2,
        [string]$Store
    )

    process {
        $payload = @{
            ExpectedVersion = $ExpectedVersion
        }

        $body = (ConvertTo-Json $payload -Depth ([int]::MaxValue))
        $base = Get-ESRemote $Store
        Invoke-WebRequest $base/streams/$Name -Method Delete -ContentType "application/json" -Body $body | Out-Null
    }


}