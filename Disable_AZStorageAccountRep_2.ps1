# Update a Storage account with AllowCrossTenantReplication

$account = Set-AzStorageAccount -ResourceGroupName "devChristopher" -Name "testchristopher" -AllowCrossTenantReplication $false -EnableHttpsTrafficOnly $true

$account.AllowCrossTenantReplication

False