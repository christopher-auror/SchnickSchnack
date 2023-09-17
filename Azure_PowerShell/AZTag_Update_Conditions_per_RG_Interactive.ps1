# Prompt the user for the subscription ID
$SubscriptionID = Read-Host "Enter the subscription ID"
Select-AzSubscription -SubscriptionID $SubscriptionID

# Prompt the user for the resource group name
$ResourceGroupName = Read-Host "Enter the resource group name"

# Get the resource group
$resourceGroup = Get-AzResourceGroup -Name $ResourceGroupName

# Get all resources in the specified resource group
$resources = Get-AzResource -ResourceGroupName $ResourceGroupName

# Loop through each resource in the resource group and add the tags
foreach ($resource in $resources) {
    # Get the resource type
    $resourceType = $resource.ResourceType

    # Set the tag based on the resource type
    if ($resourceType -eq "Microsoft.Storage/storageAccounts" -or `
        $resourceType -eq "Microsoft.Sql/servers" -or `
        $resourceType -eq "Microsoft.Sql/servers/databases" -or `
        $resourceType -eq "Microsoft.DocumentDB/databaseAccounts") {
        $tags = @{
            'VantaContainsUserData'='true'
            'VantaOwner'='shahid.iqbal@auror.co'
            'VantaUserDataStored'='event data'
            'VantaNonProd'='true'
        }
    }
    else {
        $tags = @{
            'VantaContainsUserData'='false'
            'VantaOwner'='shahid.iqbal@auror.co'
            'VantaUserDataStored'='event data'
            'VantaNonProd'='true'
        }
    }

    # Update the tags for the current resource
    Update-AzTag -ResourceId $resource.id -Tag $tags -Operation Merge
}

# Update the tags for the resource group
Update-AzTag -ResourceId $resourceGroup.ResourceId -Tag $tags -Operation Merge
