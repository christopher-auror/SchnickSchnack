# Authenticate to Azure
Connect-AzAccount

# Get all Azure subscriptions
$subscriptions = Get-AzSubscription

# Loop through each subscription
foreach ($subscription in $subscriptions) {
  # Select subscription
  Select-AzSubscription -Subscription $subscription.Id
  
  # Get all storage accounts in subscription
  $storageAccounts = Get-AzStorageAccount
  
  # Loop through each storage account
  foreach ($storageAccount in $storageAccounts) {
	# Get replication properties
	$replicationProps = Get-AzStorageAccountReplication -ResourceGroupName $storageAccount.ResourceGroupName -Name $storageAccount.StorageAccountName
  
	# Disable replication
	Set-AzStorageAccountReplication -ResourceGroupName $storageAccount.ResourceGroupName -Name $storageAccount.StorageAccountName -Status Disabled -Location $replicationProps.Location
  }
}
