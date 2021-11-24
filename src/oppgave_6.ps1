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
    

Write-Output "kortstokk:$(kortStokkTilStreng -kortstokk $cards)"
Write-Output "Poengsum: $(sumPoengKortstokk -kortstokk $cards)"

$meg = $kortstokk[0..1]
    
    $kortstokk = $kortstokk[2..$kortstokk.Count]

    $magnus = $kortstokk[<0..1]

    $kortstokk = $kortstokk[2..$kortstokk.Count]

    Write-Output"meg: $(kortstokkTilStreng -kortstokk $meg)"
    Write-Output"Magnus: $(kortstokkTilStreng -kortstokk $Magnus)"
    Write-Output"kortstokk: $(kortstokkTilStreng -kortstokk $kortstokk)"



# ...

function skrivUtResultat {
    param (
        [string]
        $vinner,        
        [object[]]
        $kortStokkMagnus,
        [object[]]
        $kortStokkMeg        
    )
    Write-Output "Vinner: $vinner"
    Write-Output "magnus | $(sumPoengKortstokk -kortstokk <#?#>) | $(<#?#> -kortstokk $kortStokkMagnus)"    
    Write-Output "meg    | $(sumPoengKortstokk -kortstokk <#?#>) | $(<#?#> -kortstokk $kortStokkMeg)"
}

# bruker 'blackjack' som et begrep - er 21
$blackjack = 21

if ((sumPoengKortstokk -kortstokk $meg) -eq $blackjack) {
    skrivUtResultat -vinner <#?#> -kortStokkMagnus <#?#> -kortStokkMeg <#?#>
    exit
}
elseif ((sumPoengKortstokk -kortstokk <#?#>) -eq $blackjack) {
    skrivUtResultat -vinner "magnus" -kortStokkMagnus <#?#> -kortStokkMeg <#?#>
    exit
}

# Hva er om begge har blackjack? Kanskje det kalles draw?
# frivillig - kan du endre koden til å ta hensyn til draw?