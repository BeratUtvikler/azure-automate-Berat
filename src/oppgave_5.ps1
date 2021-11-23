[CmdletBinding()]
param (
    [Parameter(HelpMessage = "Et url", Mandatory = $false)]
    [string]$Urlkortstokk = "http://nav-deckofcards.herokuapp.com/shuffle"
)

$ErrorActionPreference = 'Stop'

$response = Invoke-WebRequest -Uri $Urlkortstokk

$cards = $response.Content | ConvertFrom-Json

function kortstokkTilStreng {
    [OutputType([string])]
    param (
        [object[]]
        $kortstokk
    )
    $streng = ""
    foreach ($kort in $kortstokk) {
        $streng = $streng + "$($kort.suit[0])" + $kort.value + " "
    }
    return $streng
}
# https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-switch?view=powershell-7.1

function sumPoengKortstokk {
    [OutputType([int])]
    param (
        [object[]]
        $kortstokk
    )

    $poengKortstokk = 0

    foreach ($kort in $kortstokk) {
        # Undersøk hva en Switch er
        $poengKortstokk += switch ($kort.value) {
            { $_ -cin @('J', 'Q', 'K') } { 10 }
            'A' { 11 }
            default { $kort.value }
        }
    }
    return $poengKortstokk
}


Write-Output "kortstokk:$(kortStokkTilStreng -kortstokk $cards)"
Write-Output "Poengsum: $(sumPoengKortstokk -kortstokk $cards)"
