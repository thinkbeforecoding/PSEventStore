
$streamCompleter = {
    param($CommandName, $ParameterName, $WordToComplete, $ast, $fakeParameters)

    Get-Streams -Count 500 | ? { $_.Stream -like "$WordToComplete*" } `    | % { New-CompletionResult $_.Stream }
}


$projectionCompleter = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $store = $fakeBoundParameter['Store']
    if (!$store) {
        $store = $Global:store;
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

Register-ParameterCompleter Get-ESStream Name $streamCompleter

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