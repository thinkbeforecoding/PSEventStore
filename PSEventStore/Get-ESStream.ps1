function Get-ESStream {
     <#
        .SYNOPSIS
        Gets EventStore stream definitions.

        .DESCRIPTION
        Gets EventStore stream definitions.

        .PARAMETER Start
        Indicates the stream at which to start, or -1 for the last one.

        .PARAMETER Count
        Indicates

        .PARAMETER PollInterval
        The polling interval to get next state and show it if ShowProgress is specified.

        .PARAMETER Store
        The base url of the event store to use.

        .NOTES
        When not specified, the default value for $Store is $global:Store.
        Define $global:Store default value in profile to access it by default.

        .LINK
        Get-ESEvent
        Get-ESProjection
    #>
    param(
        [int]$Start = -1,
        [int]$Count = 20,
        [Switch]$IncludeSystemStreams,
        [string]$Store = $global:store
    )
    
    end {
        Get-ESEvent '$streams' -Start $Start -Count $Count -Store $Store -RefOnly `
        | % { 
            $data = Get-EventData $_
            $_ | Add-Member NoteProperty -Name Stream -Value $data.eventStreamid
            $_ | Add-Member ScriptProperty -Name LastChange  -Value { [datetime]$this.updated } 
            $_ } `        | ? { $_.Stream -notlike '$*' -or $IncludeSystemStreams } `
        | Set-PSType EventStore.Stream | Remove-PSType EventStore.EventRef

    }
}
