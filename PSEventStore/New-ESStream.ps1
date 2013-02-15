function New-ESStream {
     <#
        .SYNOPSIS
        Creates explicitly a new stream with provided metadata.

        .DESCRIPTION
        Creates explicitly a new stream with provided metadata.

        .PARAMETER Stream
        The stream name.

        .PARAMETER Metadata
        A key/value map containing metadata.

        .PARAMETER PassThru
        If set, the created EventRef is returned.

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
        [Parameter(Position = 1)]
        $MetaData = @{},
        [switch]$PassThru,
        [string]$Store
    )

    process {
        $payload = @{
            EventStreamId = $Name
            Metadata = (ConvertTo-Json $MetaData -Depth ([int]::MaxValue) -Compress)
        }

        $body = (ConvertTo-Json $payload -Depth ([int]::MaxValue))
        $base = Get-ESRemote $Store
        $r = Invoke-WebRequest $base/streams -Method Post -ContentType "application/json" -Body $body
    
        if ($PassThru) {
            $url = $r.Headers['Location']
            Get-ESEvent -Url $url/0
        }
    }


}