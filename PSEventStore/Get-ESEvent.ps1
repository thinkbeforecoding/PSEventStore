function Get-ESEvent {
     <#
        .SYNOPSIS
        Gets events from an EventStore stream.

        .DESCRIPTION
        Gets events from an EventStore stream.

        .PARAMETER Stream
        The stream name.

        .PARAMETER All
        When specified, returns last events from all streams.

        .PARAMETER Start
        The first event in the stream, or -1 to start from last event.

        .PARAMETER Count
        The number of events to return.

        .PARAMETER RefOnly
        Returns only the reference to events and not events themselves.

        .PARAMETER Store
        The base url of the event store to use.

        .PARAMETER Event
        The envet reference for which to fetch data.

        .NOTES
        When not specified, the default value for $Store is $global:Store.
        Define $global:Store default value in profile to access it by default.

        .LINK
        Get-ESStream
    #>


    [CmdletBinding()]
    param(
        [Parameter(Position = 0, ParameterSetName="Stream")]
        [Alias('EventStreamId')]
        [Alias('Name')]
        [string]$Stream,
        [Parameter(Position=0,ParameterSetName="All")]
        [switch]$All,
        [Parameter(Position=1, ParameterSetName="Stream")]
        [int]$Start = -1,
        [Parameter(Position=2, ParameterSetName="Stream")]
        [Parameter(Position=2, ParameterSetName="All")]
        [int]$Count = 20,
        [Parameter(ParameterSetName="Stream")]
        [switch]$RefOnly,
        [Parameter(ParameterSetName="Stream")]
        [string]$Store = $global:store,
        [Parameter(ValueFromPipeline, ParameterSetName="Event")]
        $Event,
        [Parameter(ParameterSetName="Url")]
        $Url
    )

    process {
        switch($PSCmdlet.ParameterSetName) {
            Stream {
                $cnt = $Count
                $c = [Math]::Min(20,$cnt)
                $url = "$store/streams/$Stream/range/$start/$c"
                $r = Invoke-RestMethod ($url+"?format=json") 
        
                if ($RefOnly) {
                    $r.entries | Set-PSType EventStore.EventRef
                } else {
                    $r.entries | Get-ESEvent
                }

                $cnt = $cnt - 20
                while ($cnt -gt 0) {
                    $next = $r.links | ? relation -eq next | % uri
                    if (!$next) { return }
            
                    $r = Invoke-RestMethod ($next+"?format=json") 
                    if ($RefOnly) {
                        $r.entries | select -First $cnt | Set-PSType EventStore.EventRef
                    } else {
                        $r.entries | select -First $cnt | Get-ESEvent
                    }
                    $cnt = $cnt - 20
                }
            }
            All {
                $cnt = $Count
                $c = [Math]::Min(20,$cnt)
                $url = "$store/streams/`$all/$cnt" + "?embed=yes&format=json"
                $r = Invoke-RestMethod $url 
        
                if ($RefOnly) {
                    $r.entries | Set-PSType EventStore.EventRef
                } else {
                    $r.entries | Get-ESEvent
                }

                $cnt = $cnt - 20
                while ($cnt -gt 0) {
                    $next = $r.links | ? relation -eq next | % uri
                    if (!$next) { return }
            
                    $r = Invoke-RestMethod ($next+"?format=json") 
                    if ($RefOnly) {
                        $r.entries | select -First $cnt | Set-PSType EventStore.EventRef
                    } else {
                        $r.entries | select -First $cnt | Get-ESEvent
                    }
                    $cnt = $cnt - 20
                }

            }
            Event {
                $ProgressPreference = "SilentlyContinue";

                $link = $event.links | ? relation -EQ alternate | ? type -eq 'application/json' | % uri
                Invoke-RestMethod $link | Set-PSType EventStore.Event | % { 
                    $_ | Add-Member ScriptProperty -Name Stream -Value { $this.eventStreamId }
                    $_ | Add-Member ScriptProperty -Name Version -Value { $this.eventNumber }
                    $_
                $ProgressPreference = "Continue";

                }
            }
            Url {
                $ProgressPreference = "SilentlyContinue";

                Invoke-RestMethod $url | % entry | Set-PSType EventStore.EventRef
                $ProgressPreference = "Continue";
                
            }
        }
    }
}