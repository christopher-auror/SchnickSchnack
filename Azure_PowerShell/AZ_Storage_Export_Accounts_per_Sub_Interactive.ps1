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

# Add date and timestamp to the CSV file name
$dateTime = Get-Date -Format "yyyy_MM_dd_HHmm"
$csvFileName = "storagedetails_Sub_$dateTime.csv"

# Export results in a CSV file with the updated file name
$result | Export-Csv -Path "$HOME/Downloads/$csvFileName" -Encoding UTF8 -NoTypeInformation