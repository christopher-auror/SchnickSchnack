# Prompt the user for the subscription ID
$SubscriptionID = Read-Host "Enter the subscription ID"
Select-AzSubscription -SubscriptionID $SubscriptionID

# Add Azure tags to the selected subscription
$tags = @{
    'ContainsUserData'='true'
    'NonProd'='true'
    'Owner'='shahid.iqbal@auror.co'
    'UserDataStored'='event data'
}
Update-AzTag -ResourceId "/subscriptions/$SubscriptionID" -Tag $tags -Operation Merge

# Get all resources in the subscription
$resources = Get-AzResource

# Loop through each resource and add Azure tags
foreach ($resource in $resources) {
    Update-AzTag -ResourceId $resource.id -Tag $tags -Operation Merge
}
