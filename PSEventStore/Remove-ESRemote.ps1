function Remove-ESRemote {
     <#
        .SYNOPSIS
        Remove an remote alias.

        .DESCRIPTION
        Remove an remote alias.

        .PARAMETER Name
        The remote alias name.


        .LINK
        Get-ESRemote
        Set-ESRemote
    #>

    param(
        [string]$Name
    )

    end {
       $global:ESRemotes.Remove($Name)

       ConvertTo-Json $global:ESRemotes | Out-File $global:ESRemoteFile -Encoding utf8
    }

}
