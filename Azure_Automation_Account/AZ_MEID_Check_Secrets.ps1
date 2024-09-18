# Connect to managed identity in our Azure tenant
try {
    Connect-AzAccount -Identity -ErrorAction Stop
    Write-Output "Successfully connected to Azure account."
} catch {
    Write-Error "Failed to connect to Azure account: $_"
    exit 1
}

# Secret expiration date filter
$LimitExpirationDays = 180

# Retrieving the list of secrets that expires in the above days
$SecretsToExpire = Get-AzADApplication | ForEach-Object {
    $app = $_
    @(
        Get-EntraApplicationPasswordCredential -ObjectId $_.ObjectId
        Get-EntraApplicationKeyCredential -ObjectId $_.ObjectId
    ) | Where-Object {
        $_.EndDate -lt (Get-Date).AddDays($LimitExpirationDays)
    } | ForEach-Object {
        $id = "Not set"
        if($_.CustomKeyIdentifier) {
            $id = [System.Text.Encoding]::UTF8.GetString($_.CustomKeyIdentifier)
        }
        [PSCustomObject] @{
            App = $app.DisplayName
            ObjectID = $app.ObjectId
            AppId = $app.AppId
            Type = $_.GetType().name
            KeyIdentifier = $id
            EndDate = $_.EndDate
        }
    }
}
 
# Gridview list
# $SecretsToExpire | Out-GridView

# Printing the list of secrets that are near to expire
if($SecretsToExpire.Count -EQ 0) {
    Write-Output "No secrets found that will expire in this range"
}
else {
    Write-Output "Secrets that will expire in this range:"
    Write-Output $SecretsToExpire.Count
    Write-Output $SecretsToExpire
}