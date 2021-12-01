[CmdletBinding()]
param (
    [Parameter(HelpMessage = "URL til kortstokk", Mandatory = $false)]
    [string]
    $urlKortstokk = 'http://nav-deckofcards.herokuapp.com/shuffle'
)

# Feilhåndtering - stopp programmet hvis det dukker opp noen feil
# Se https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.actionpreference?view=powershellsdk-7.0.0
$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop

$webRequest = Invoke-WebRequest -Uri $urlKortstokk

$kortstokkJson = $webRequest.Content

$kortstokk = ConvertFrom-Json -InputObject $kortstokkJson

function kortstokkTilStreng {
    [OutputType([string])]
    param (
        [object[]]
        $kortstokk
    )
    $streng = ''
    foreach ($kort in $kortstokk) {
        $streng = $streng + "$($kort.suit[0])" + $kort.value + ","
    }
    return $streng
}

function sumPoengKortstokk {
    [OutputType([int])]
    param (
        [object[]]
        $kortstokk
    )

    $poengKortstokk = 0

    foreach ($kort in $kortstokk) {
        $poengKortstokk += switch ($kort.value) {
            { $_ -cin @('J', 'Q', 'K') } { 10 }
            'A' { 11 }
            default { $kort.value }
        }
    }
    return $poengKortstokk
}

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
    Write-Output "magnus | $(sumPoengKortstokk -kortstokk $kortStokkMagnus) | $(kortStokkTilStreng -kortstokk $kortStokkMagnus)"
    Write-Output "meg    | $(sumPoengKortstokk -kortstokk $kortStokkMeg) | $(kortStokkTilStreng -kortstokk $kortStokkMeg)"
}

Write-Output "Kortstokk: $(kortStokkTilStreng -kortstokk $kortstokk)"
Write-Output "Poengsum: $(sumPoengKortstokk -kortstokk $kortstokk)"
Write-Output ""

### Regler (1)
### Du tar de to første kortene, Magnus tar de to neste

$meg = $kortstokk[0..1]
$kortstokk = $kortstokk[2..$kortstokk.Count]

$magnus = $kortstokk[0..1]
$kortstokk = $kortstokk[2..$kortstokk.Count]

### Regn ut den samlede poengsummen til hver spiller
### Regn ut om en av spillerene har 21 poeng - Blackjack - med deres initielle kort, og dermed vinner runden

# bruker 'blackjack' som et begrep - er 21
$blackjack = 21

if (((sumPoengKortstokk -kortstokk $meg) -eq $blackjack) -and ((sumPoengKortstokk -kortstokk $magnus) -eq $blackjack)) {
    skrivUtResultat -vinner "Draw" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}
elseif ((sumPoengKortstokk -kortstokk $meg) -eq $blackjack) {
    skrivUtResultat -vinner "meg" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}
elseif ((sumPoengKortstokk -kortstokk $magnus) -eq $blackjack) {
    skrivUtResultat -vinner "magnus" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}

### Regler(2)

### Hvis ingen har 21 poeng, skal spillerne trekke kort fra toppen av kortstokken
### Du skal stoppe å trekke kort når poengsummen blir 17 eller høyere

while ((sumPoengKortstokk -kortstokk $meg) -lt 17) {
    $meg += $kortstokk[0]
    $kortstokk = $kortstokk[1..$kortstokk.Count]
}

### Du taper spillet hvis poengsummen er høyere enn 21

if ((sumPoengKortstokk -kortstokk $meg) -gt $blackjack) {
    skrivUtResultat -vinner "magnus" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}

### Når du har stoppet å trekke kort, begynner Magnus å trekke kort
### Magnus slutter å trekke kort når poengsummen hans er høyere enn din poengsum

while ((sumPoengKortstokk -kortstokk $magnus) -le (sumPoengKortstokk -kortstokk $meg)) {
    $magnus += $kortstokk[0]
    $kortstokk = $kortstokk[1..$kortstokk.Count]
}

### Magnus taper spillet dersom poengsummen er høyere enn 21
if ((sumPoengKortstokk -kortstokk $magnus) -gt $blackjack) {
    skrivUtResultat -vinner "meg" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}

skrivUtResultat -vinner "magnus" -kortStokkMagnus $magnus -kortStokkMeg $meg