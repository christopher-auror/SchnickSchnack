# Prompt the user for the subscription ID
$subscriptionId = Read-Host "Enter the subscription ID"
Select-AzSubscription -SubscriptionId $subscriptionId

# Get all storage accounts in the specified subscription
$storageAccounts = Get-AzStorageAccount

# Loop through each storage account in the subscription
$result = foreach($storageAccount in $storageAccounts)
{
    [PSCustomObject]@{
        Name = $storageAccount.StorageAccountName
        Location = $storageAccount.Location
        Kind = $storageAccount.Kind
        Replication = $storageAccount.Sku.name
        RGName = $storageAccount.ResourceGroupName
        SubscriptionID = $subscriptionId
    }
}

# Export results in a CSV file
$result | Export-Csv -Path "$HOME/Downloads/storagedetails_Sub.csv" -Encoding UTF8 -NoTypeInformation