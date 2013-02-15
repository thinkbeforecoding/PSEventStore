PSEventStore
============

A powershell module for the EventStore.

Get the EventStore at http://geteventstore.com

__Installation__


Install PSCompletion and PSEventStore module in your Module folder.
Import module:

    PS> Import-Module PSEventStore

You can manage the module folders with the $env:PSModulePath variable.

__Quick installation with PSGet__

Install PSGet:

    PS> iwr http://psget.net/GetPsGet.ps1 | iex
    
Install PSEventStore:

    PS> Install-Module -ModuleUrl https://github.com/thinkbeforecoding/PSEventStore/archive/master.zip

PsCompletion will be installed automaticaly by PSEventStore installation.

You're done !

__Usage__

Set your default EventStore by setting the $global:store variable.
If not set, the default value is http://localhost:2113

    PS> $global:store = 'http://myserver:2113'

You can add this to your profile to make it set in your next sessions.

You can then get the list of streams:

    PS> Get-ESStream

Get a stream events :

    PS> Get-ESEvent stream

Get a stream events references:

    PS> Get-ESEvent stream -RefOnly
    
To create and send an event:

    PS> New-ESEvent SomethingHappened @{Value = 42} | Write-ESEvent stream

To create a new stream explicitly:

    PS> New-ESStream newstream -MetaData @{MaxAge = 100000}

To delete a stream:

    PS> Remove-ESStream stream


__Executing queries__

To invoke a transient query, just call

    PS> Invoke-ESQuery 'fromAll().when({$init: function() { return 0;}, $any: function(s,e) { return ++s; }})'

This query will return the total count of events in the store.

You can add the -ShowProgress flag to see the query running.

__Projections__

Get the existing projections with :

    PS> Get-ESProjection

    Name                                                         Status     Mode                 %Done    Position        Last CheckPoint
    ----                                                         ------     ----                 -----    --------        ---------------
    $streams                                                     Stopped    Continuous           -1,0 %   0/-1            0/-1           
    $stream_by_category                                          Stopped    Continuous           -1,0 %   0/-1            0/-1           
    $by_category                                                 Stopped    Continuous           -1,0 %   0/-1            0/-1          
    $by_event_type                                               Stopped    Continuous           -1,0 %   0/-1            0/-1           


You can use wilecard filters like :

    PS> Get-ESProjection *stream*

To get a projection current state :

    PS> Get-ESProjectionState name

It will return the current state object.

To start a projection :

    PS> Enable-ESProjection name

To stop a projection :

    PS> Disable-ESProjection

To get a projection query definition:

    PS> Get-ESProjectionQuery name

To change a projection query definition:

    PS> Set-ESProjectionQuery name @'
    fromAll()
    .when({ ... })
    '@

The definition is using here a multiline here string.

To create a one time projection :

    PS> $p = New-ESProjection name OneTime 'fromAll()...'

To create a new continuous projection :

    PS> $p = New-ESProjection name Continuous 'fromAll()...'

One you put a projection in a variable, you can pipe it to other commands
instead of passing a name:

    PS> $p | Get-ESProjectionState

To delete a projection:

    PS> Remove-ESProjection name

__Statistics__

You can query the EventStore statistics with:

    PS> Get-ESStatistics
    
There's a bunch of options to get more precise stats:

    PS> Get-ESStatistics Processor

Here's the whole list:
        All
        Processor
        ProcessorDiskIO
        ProcessorTcp
        ProcessorGc
        System
        SystemDrive
        EventStore
        EventStoreQueue
        EventStoreReadIndex

Have fun !
