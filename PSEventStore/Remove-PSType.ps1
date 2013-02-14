function Remove-PSType {
    param(
        [Parameter(ValueFromPipeline)]
        $InputObject,
        [Parameter(Position = 0)]
        [string[]]$Name
    )

    process {
        foreach ($n in $Name) {
            $InputObject.PsObject.TypeNames.Remove($n) | Out-Null
        }

        $InputObject
    }
}