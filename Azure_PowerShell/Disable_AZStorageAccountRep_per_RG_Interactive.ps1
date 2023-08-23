# Prompt the user for the resource group name
$rgName = Read-Host "Enter the resource group name"

# Get the storage accounts in the specified resource group
$storageAccounts = Get-AzStorageAccount -ResourceGroupName $rgName

# Loop through each storage account and set AllowCrossTenantReplication to "false"
foreach ($account in $storageAccounts) {
    Set-AzStorageAccount -ResourceGroupName $rgName `
        -Name $account.StorageAccountName `
        -AllowCrossTenantReplication $false
}
