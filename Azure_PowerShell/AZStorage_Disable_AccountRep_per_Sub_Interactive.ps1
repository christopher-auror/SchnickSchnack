# Prompt the user for the subscription ID
$SubscriptionID = Read-Host "Enter the subscription ID"
Select-AzSubscription -SubscriptionID $SubscriptionID

# Get all subscriptions
$resourcegroups = Get-AzResourceGroup
foreach ($rg in $resourcegroups) {

    # Get the storage accounts in the specified resource group
    $storageAccounts = Get-AzStorageAccount -ResourceGroupName $rg.ResourceGroupName
    
    # Loop through each storage account and set AllowCrossTenantReplication to "false"
    foreach ($account in $storageAccounts) {
        Set-AzStorageAccount -ResourceGroupName $rg.ResourceGroupName `
            -Name $account.StorageAccountName `
            -AllowCrossTenantReplication $false
    }
}