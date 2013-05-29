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
        The base url of the event store to use, or the remote name configured with Set-ESRemote.

        .PARAMETER Event
        The event reference for which to fetch data.

        .LINK
        Get-ESStream
    #>


    [CmdletBinding(DefaultParameterSetName="Stream")]
    param(
        [Parameter(Position = 0, ParameterSetName="Stream")]
        [Alias('EventStreamId')]
        [Alias('Name')]
        [string]$Stream,
        [Parameter(Position=0,ParameterSetName="All")]
        [switch]$All,
        [Parameter(Position=0,ParameterSetName="Category")]
        [string]$Category,
        [Parameter(Position=1, ParameterSetName="Stream")]
        [int]$Start = -1,
        [Parameter(Position=2, ParameterSetName="Stream")]
        [Parameter(Position=2, ParameterSetName="All")]
        [Parameter(Position=2, ParameterSetName="Category")]
        [int]$Count = 20,
        [Parameter(ParameterSetName="Stream")]
        [switch]$Forward,
        [Parameter(ParameterSetName="Stream")]
        [switch]$RefOnly,
        [Parameter(ParameterSetName="Stream")]
        [Parameter(ParameterSetName="All")]
        [Parameter(ParameterSetName="Category")]
        [string]$Store,
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

                $base = Get-ESRemote $Store
                $url = "$base/streams/$Stream/range/$start/$c"
                $r = Invoke-RestMethod ($url+"?format=json") 

                if ($Forward) {
                    $next = $next = $r.links | ? relation -eq last | % uri
                    while ($cnt -gt 0) {
                        $r = Invoke-RestMethod ($next+"?format=json") 
                        if ($RefOnly) {
                            $r.entries[-1..(0 - $r.entries.Length)] | select -First $cnt | Set-PSType EventStore.EventRef
                        } else {
                            $r.entries[-1..(0 - $r.entries.Length)] | select -First $cnt | Get-ESEvent
                        }

                        $next = $r.links | ? relation -eq previous | % uri
                        if (!$next) { return }
            
                        $cnt = $cnt - 20
                    }

                } else {        
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
            }
            All {
                $cnt = $Count
                $c = [Math]::Min(20,$cnt)
                $base = Get-ESRemote $Store
                $url = "$base/streams/`$all/$cnt" + "?embed=yes&format=json"
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
            Category {
                $categoryId = "`$category-$category"
                $streams = Get-ESEvent $categoryId -Count $Count | ? EventType -EQ StreamCreated | % Data
                $remainingCount = $Count
                $streams | % { 
                    if ($remainingCount -eq 0) {
                        return
                    } else {
                        Get-ESEvent $_ -Count $remainingCount 
                    }
                    } | % { 
                    if ($remainingCount -eq 0) {
                        return
                    } else {
                        $remainingCount = $remainingCount - 1
                        $_
                    }

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