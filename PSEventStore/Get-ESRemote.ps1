if (!$global:ESRemoteFile) {
    $global:ESRemoteFile = Join-Path (Split-Path $profile) 'ESRemotes.json'
}

if (!$global:ESRemotes) {

    $global:ESRemotes = @{}

    $remotes = Get-Content $global:ESRemoteFile | Out-String |  ConvertFrom-Json 
    $remotes | Get-Member -MemberType NoteProperty `
    | % { 
        $n = $_.Name
        $global:ESRemotes[$n] = $remotes.$n
    }
    
}

function Get-ESRemote {
     <#
        .SYNOPSIS
        Gets the aliases to use for the Store parameters in the module function.

        .DESCRIPTION
        Gets the aliases to use for the Store parameters in the module function.

        .PARAMETER Name
        The remote alias name.

        .PARAMETER ListAvailable
        Indicates that all remotes matching Name wildcard pattern will be returned.
        If Name is empty, all remotes will be returned.

        .LINK
        Set-ESRemote
        Remove-ESRemote
    #>
    
    param(
        [string]$Name,
        [switch]$ListAvailable
    )

    end {
        if ($ListAvailable) {
            if (!$Name) { $Name = '*' }
            $global:ESRemotes.Keys | ? { $_ -like $Name} | % { [pscustomobject]@{Name= $_; Value = $global:ESRemotes[$_]} }
        } else {
            if ($Name) {
                $key = $Name
            } else {
                $key = 'Default'
            }
            $value = $ESRemotes[$key]
            if ($value) {
                return $value;
            }

            $Name
        }
    }
}

