# Update a Storage account with AllowCrossTenantReplication

$account = Set-AzStorageAccount -ResourceGroupName "myresourcegroup" -Name "mystorageaccount" -AllowCrossTenantReplication $false -EnableHttpsTrafficOnly $true

$account.AllowCrossTenantReplication

False