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

Write-Output "kortstokk:$(kortStokkTilStreng -kortstokk $cards)"
