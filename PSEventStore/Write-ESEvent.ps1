function Write-ESEvent {
     <#
        .SYNOPSIS
        Save one or more events to an EventStore stream.

        .DESCRIPTION
        Save one or more events to an EventStore stream.

        .PARAMETER Stream
        The stream name.

        .PARAMETER Event
        The event to save.

        .PARAMETER CommitId
        The commit identifier.

        .PARAMETER ExpectedVersion
        The expected version of the last event of the stream.
        -1 for a new stream.
        -2 for any version, this is the default value.

        .PARAMETER PassThru
        If set, the created EventRef is returned.

        .PARAMETER Store
        The base url of the event store to use.

        .NOTES
        When not specified, the default value for $Store is $global:Store.
        Define $global:Store default value in profile to access it by default.

        .LINK
        Get-ESEvent
        New-ESEvent
    #>

    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Stream,
        [Parameter(ValueFromPipeline, Position = 1)]
        $Event,
        [Guid]$CommitId = [Guid]::NewGuid(),
        [int]$ExpectedVersion = -2,
        [switch]$PassThru,
        [string]$Store = $Global:Store
    )

    begin {
        $events = @()
    }

    process {
        $events += $Event
    }

    end {
        $payload = @{
            CorrelationId = $CommitId
            Events = $events
            ExpectedVersion = $ExpectedVersion    
        }
        $body = (ConvertTo-Json $payload -Depth ([int]::MaxValue))
        $r = Invoke-WebRequest $Store/streams/$Stream -Method Post -ContentType "application/json" -Body $body #| Out-Null
    
        if ($PassThru) {
            $url = $r.Headers['Location']
            Get-ESEvent -Url $url
        }
    }


}