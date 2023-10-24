# Login to Azure
Connect-AzAccount

#secret expiration date filter (for example 30 days)
$LimitExpirationDays = 30

#Retrieving the list of secrets that expires in the above range of days
$SecretsToExpire = Get-MgApplication -All $true | ForEach-Object {
    $app = $_
    @(
        Get-MgPasswordCredential -ApplicationId $_.Id
        Get-MgKeyCredential -ApplicationId $_.Id
    ) | Where-Object {
        $_.EndDate -lt (Get-Date).AddDays($LimitExpirationDays)
    } | ForEach-Object {
        $id = "Not set"
        if($_.CustomKeyIdentifier) {
            $id = [System.Text.Encoding]::UTF8.GetString($_.CustomKeyIdentifier)
        }
        [PSCustomObject] @{
            App = $app.DisplayName
            ObjectID = $app.Id
            AppId = $app.AppId
            Type = $_.GetType().name
            KeyIdentifier = $id
            EndDate = $_.EndDate
        }
    }
}

#Printing the list of secrets that are near to expire
if($SecretsToExpire.Count -EQ 0) {
    Write-Output "No secrets found that will expire in this range"
}
else {
    Write-Output $SecretsToExpire
}