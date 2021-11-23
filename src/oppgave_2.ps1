[CmdletBinding()]
param (
    [Parameter(HelpMessage = "Et navn", Mandatory = $true)]
    [string]$Navn
)
#TesterVScode
Write-Output "Hei $Navn!"