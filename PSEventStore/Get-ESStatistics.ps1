Add-Type -TypeDefinition @'
namespace EventStore {
    public enum Statistics {
        All,
        Processor,
        ProcessorDiskIO,
        ProcessorTcp,
        ProcessorGc,
        System,
        SystemDrive,
        EventStore,
        EventStoreQueue,
        EventStoreReadIndex
    }
}
'@


function Get-ESStatistics {
    <#
        .SYNOPSIS
        Gets EventStore statistics.

        .DESCRIPTION
        Gets EventStore statistics.

        .PARAMETER Statistic
        Indicates which statistics to fetch.

        .PARAMETER Arg
        The optional argument for SystemDrive and EventStoreQueue

        .PARAMETER Store
        The base url of the event store to use.

        .NOTES
        When not specified, the default value for $Store is $global:Store.
        Define $global:Store default value in profile to access it by default.
    #>
     
    [CmdletBinding()]
    param(
        [Parameter(Position=0)]
        [EventStore.Statistics] $Statistic = [EventStore.Statistics]::All,
        [Parameter(Position=1)]
        [string]$Arg,
        [string]$Store = $Global:Store
    )

    end {
         switch($Statistic) {
        All { $p = '' } 
        Processor { $p = 'proc' }
        ProcessorDiskIO { $p ='proc/diskio' }
        ProcessorTcp { $p = 'proc/tcp' }
        ProcessorGc { $p ='proc/gc' }
        System { $p = 'sys' }
        SystemDrive { if ($Arg) { $p = "sys/drive/$Arg" } else { $p = "sys/drive" } }
        EventStore { 'es' }
        EventStoreQueue {if ($Arg) { $p = "es/queue/$Arg" } else { $p = "es/queue" } }
        EventStoreReadIndex { $p = 'es/readindex' }
        }

        Invoke-RestMethod $Store/stats/$p
    }

}