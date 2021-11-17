# Feilhåndtering - stopp programmet hvis det dukker opp noen feil
# Se https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-7.2#erroractionpreference
$ErrorActionPreference = 'Stop'

$Url = "http://nav-deckofcards.herokuapp.com/shuffle"

$response = Invoke-WebRequest -Uri $Url

$response.content | ConvertFrom-Json

$cards = $response.Content | ConvertFrom-Json

foreach ($card in $cards) { 
    $kortstokk = $kortstokk + ($card.suit[0] + $card.value)
}

Write-Output "kortstokk: $kortstokk"

