
$streamCompleter = {
    param($CommandName, $ParameterName, $WordToComplete, $ast, $fakeParameters)

    Get-ESStream -Count 500 | ? { $_.Stream -like "$WordToComplete*" } `    | % { New-CompletionResult $_.Stream }
}


$projectionCompleter = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $store = $fakeBoundParameter['Store']
    if (!$store) {
        $store = Get-ESRemote;
    }
    Get-ESProjection -Name "$wordToComplete*" -Store $store `
    | % { New-CompletionResult $_.Name }
}

$queryCompleter = { 
New-CompletionResult (@'
@'
    options({
                useEventIndexes: false,
                // reorderEvents: false,
                // processingLag: 0,
    });
    fromAll()
    .when({ 
        $init: function () { return  0; }, 
        $any: function(s, e) { return ++s; } 
     });

'@ + "'@") -ListItemText 'fromAll().when({$any})'

New-CompletionResult (@'
@'
    options({
                useEventIndexes: true,
                // reorderEvents: false,
                // processingLag: 0,
    });
    fromAll()
    .when({ 
        $init: function () { return  0; }, 
        Event: function(s, e) { return ++s; } 
     });

'@ + "'@") -ListItemText 'fromAll().when({Event})'

New-CompletionResult (@'
@'
    options({
                useEventIndexes: true,
                // reorderEvents: false,
                // processingLag: 0,
    });
    fromStream('stream')
    .when({ 
        $init: function () { return  0; }, 
        Event: function(s, e) { return ++s; } 
     });

'@ + "'@") -ListItemText 'fromStream().when({Event})'

New-CompletionResult (@'
@'
    options({
                useEventIndexes: true,
                // reorderEvents: false,
                // processingLag: 0,
    });
    fromStreams(['stream1','stream2'])
    .when({ 
        $init: function () { return  0; }, 
        Event: function(s, e) { return ++s; } 
     });

'@ + "'@") -ListItemText 'fromStreams([]).when({Event})'

New-CompletionResult (@'
@'
    options({
                useEventIndexes: true,
                // reorderEvents: false,
                // processingLag: 0,
    });
    fromCatefory('cat')
    .when({ 
        $init: function () { return  0; }, 
        Event: function(s, e) { return ++s; } 
     });

'@ + "'@") -ListItemText 'fromCatefory([]).when({Event})'

}

$remoteCompleter = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    Get-ESRemote "$wordToComplete*" -ListAvailable `
    | % { New-CompletionResult $_.Name -ToolTip $_.Value }
}

Register-ParameterCompleter Get-ESEvent Stream $streamCompleter
Register-ParameterCompleter Write-ESEvent Stream $streamCompleter
Register-ParameterCompleter Remove-ESStream Name $streamCompleter

Register-ParameterCompleter Get-ESProjectionState Name $projectionCompleter
Register-ParameterCompleter Get-ESProjection Name $projectionCompleter
Register-ParameterCompleter Enable-ESProjection Name $projectionCompleter
Register-ParameterCompleter Disable-ESProjection Name $projectionCompleter
Register-ParameterCompleter Remove-ESProjection Name $projectionCompleter
Register-ParameterCompleter Get-ESProjectionQuery Name $projectionCompleter
Register-ParameterCompleter Set-ESProjectionQuery Name $projectionCompleter


Register-ParameterCompleter Set-ESProjectionQuery Query $queryCompleter
Register-ParameterCompleter New-ESProjection Query $queryCompleter
Register-ParameterCompleter New-ESQuery Query $queryCompleter
Register-ParameterCompleter Execute-ESQuery Query $queryCompleter

Register-ParameterCompleter Get-ESRemote Name $remoteCompleter
Register-ParameterCompleter Remove-ESRemote Name $remoteCompleter


Register-ParameterCompleter Get-ESEvent Store $remoteCompleter
Register-ParameterCompleter Write-ESEvent Store $remoteCompleter
Register-ParameterCompleter Get-ESStream Store $remoteCompleter
Register-ParameterCompleter New-ESStream Store $remoteCompleter
Register-ParameterCompleter Remove-ESStream Store $remoteCompleter
Register-ParameterCompleter Get-ESProjection Store $remoteCompleter
Register-ParameterCompleter New-ESProjection Store $remoteCompleter
Register-ParameterCompleter Remove-ESProjection Store $remoteCompleter
Register-ParameterCompleter Disable-ESProjection Store $remoteCompleter
Register-ParameterCompleter Enable-ESProjection Store $remoteCompleter
Register-ParameterCompleter Get-ESProjectionQuery Store $remoteCompleter
Register-ParameterCompleter Set-ESProjectionQuery Store $remoteCompleter
Register-ParameterCompleter Get-ESProjectionState Store $remoteCompleter
Register-ParameterCompleter New-ESQuery Store $remoteCompleter
Register-ParameterCompleter Invoke-ESQuery Store $remoteCompleter
Register-ParameterCompleter Get-ESStatistics Store $remoteCompleter
