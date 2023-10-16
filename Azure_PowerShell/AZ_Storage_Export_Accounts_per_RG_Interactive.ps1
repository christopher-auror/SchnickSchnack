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
        SubscriptionID = $subscriptionId
        RGName = $storageaccount.ResourceGroupName
        Name = $storageaccount.StorageAccountName
        Location = $storageaccount.Location
        Kind = $storageaccount.Kind
        Replication = $storageaccount.Sku.name
    }
}

# Add date and timestamp to the CSV file name
$dateTime = Get-Date -Format "yyyy_MM_dd_HHmm"
$csvFileName = "storagedetails_RG_$dateTime.csv"

# Export results in a CSV file
$result | Export-Csv -Path "$HOME/Downloads/$csvFileName" -Encoding UTF8 -NoTypeInformation