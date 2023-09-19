# Prompt the user for the subscription ID
$SubscriptionID = Read-Host "Enter the subscription ID"
Select-AzSubscription -SubscriptionID $SubscriptionID

# Prompt the user for the resource group name
$ResourceGroupName = Read-Host "Enter the resource group name"

# Get the resource group
$resourceGroup = Get-AzResourceGroup -Name $ResourceGroupName

# Add the tag to the resource group
$tags = @{
    'ContainsUserData'='true'
    'Owner'='shahid.iqbal@auror.co'
    'UserDataStored'='event data'
    'NonProd'='true'
}
Update-AzTag -ResourceId $resourceGroup.ResourceId -Tag $tags -Operation Merge

# Get all resources in the specified resource group
$resources = Get-AzResource -ResourceGroupName $ResourceGroupName

# Loop through each resource in the resource group and add the tags
foreach ($resource in $resources) {
    Update-AzTag -ResourceId $resource.id -Tag $tags -Operation Merge
}
