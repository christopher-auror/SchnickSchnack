# Set the resource group name and minimum TLS version
$rgName = "devChristopher"
$minimumTlsVersion = "TLS1_2"

# Get a list of all storage accounts in the resource group
$storageAccounts = Get-AzStorageAccount -ResourceGroupName $rgName

# Loop through each storage account and set the minimum TLS version
foreach ($account in $storageAccounts) {
	Set-AzStorageAccount -ResourceGroupName $rgName `
	-Name $account.StorageAccountName `
	-MinimumTlsVersion $minimumTlsVersion
}