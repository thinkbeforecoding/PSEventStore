function Set-ESRemote {
     <#
        .SYNOPSIS
        Sets the aliases to use for the Store parameters in the module function.

        .DESCRIPTION
        Sets the aliases to use for the Store parameters in the module function.

        .PARAMETER Name
        The remote alias name.

        .PARAMETER Address
        The address of the event store to use with the remote alias.

        .LINK
        Get-ESRemote
        Remove-ESRemote
    #>

    param(
        [string]$Name,
        [string]$Address
    )

    end {
       $global:ESRemotes[$Name] = $Address

       ConvertTo-Json $global:ESRemotes | Out-File $global:ESRemoteFile -Encoding utf8
    }

}
