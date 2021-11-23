# Feilhåndtering - stopp programmet hvis det dukker opp noen feil
# Se https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-7.2#erroractionpreference
$ErrorActionPreference = 'Stop'

$Url = "http://nav-deckofcards.herokuapp.com/shuffle"

$response = Invoke-WebRequest -Uri $Url

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

