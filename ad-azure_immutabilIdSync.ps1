# Run the next line in a different powershell window, before executing this scritp
 Set-ExecutionPolicy Unrestricted
$outputFilePath = "C:\it\immutableid-change.txt"

# Connessione a Active Directory on-premise
$adServer = "NomeServerAD"  # Inserisci il nome del tuo server AD
$adSearchBase = "OU=Utenti,DC=dominio,DC=com"  # Inserisci il percorso dell'OU degli utenti
$adUsers = Get-ADUser -Filter * #-SearchBase $adSearchBase -Server $adServer

# Connessione ad Azure AD
Import-Module ActiveDirectory

#Connect-AzureAD
Connect-MsolService

foreach ($adUser in $adUsers) {
    # Ottieni l'ObjectGUID e convertilo in formato base64
    $objectGUID = $adUser.ObjectGUID
    $immutableID = [Convert]::ToBase64String($objectGUID.ToByteArray())

   # Trova l'utente corrispondente in Azure AD
    $azureADUser = Get-MsolUser -UserPrincipalName $adUser.UserPrincipalName


    if ($azureADUser -ne $null) {
        # Ottieni l'ImmutableID corrente di Azure AD
        $currentImmutableID = $azureADUser.ImmutableId

        # Verifica se l'ImmutableID in Azure AD è diverso da quello in AD on-premise
        if ($currentImmutableID -ne $immutableID) {
            # Modifica l'ImmutableID in Azure AD
            Set-MsolUser -UserPrincipalName $adUser.UserPrincipalName -ImmutableId $immutableID

            Write-Host "ImmutableID da Aggiornare per $($adUser.UserPrincipalName)"
            Add-Content -Path $outputFilePath -Value "ImmutableID da Aggiornare per $($adUser.UserPrincipalName)"
        } else {
            Write-Host "ImmutableID già aggiornato per $($adUser.UserPrincipalName)"
            Add-Content -Path $outputFilePath -Value "ImmutableID già aggiornato per $($adUser.UserPrincipalName)"
        }
    } else {
            Write-Host "Utente $($adUser.UserPrincipalName) non trovato in Azure AD"
.           Add-Content -Path $outputFilePath -Value "Utente $($adUser.UserPrincipalName) non trovato in Azure AD"
    }
}


# Disconnessione da Azure AD
#Disconnect-AzureAD
#Set-ExecutionPolicy Restricted
