# Prompt the user for the subscription ID
$subscriptionId = Read-Host "Enter the subscription ID"
Select-AzSubscription -SubscriptionId $subscriptionId

# Prompt the user for the resource group name
$resourceGroupName = Read-Host "Enter the resource group name"

# Get all storage accounts in the specified resource group
$storageaccounts = Get-AzStorageAccount -ResourceGroupName $resourceGroupName

# Loop through each storage account in the resource group
$result = foreach($storageaccount in $storageaccounts)
{
    [PSCustomObject]@{
        Name = $storageaccount.StorageAccountName
        Location = $storageaccount.Location
        Kind = $storageaccount.Kind
        Replication = $storageaccount.Sku.name
        RGName = $storageaccount.ResourceGroupName
        SubscriptionID = $subscriptionId
    }
}

# Export results in a CSV file
$result | Export-Csv -Path "$HOME/Downloads/storagedetails_RG.csv" -Encoding UTF8 -NoTypeInformation