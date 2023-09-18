# Prompt the user for the subscription ID
$SubscriptionID = Read-Host "Enter the subscription ID"
Select-AzSubscription -SubscriptionID $SubscriptionID

# Prompt the user for the resource group name
$ResourceGroupName = Read-Host "Enter the resource group name"

# Get all resources in the specified resource group
$resources = Get-AzResource -ResourceGroupName $ResourceGroupName

# Loop through each resource in the resource group and add the tags
foreach ($resource in $resources) {
    # Set the tag based on the resource type
    $tags = @{
        'VantaNonProd'='true'
        'VantaOwner'='shahid.iqbal@auror.co'
        'VantaContainsUserData'='false'
        'VantaUserDataStored'='event data'
        'VantaDescription'='Fawkes'
    }

    if ($resource.ResourceType -match "Microsoft\.(Storage|Sql|DocumentDB)/") {
        $tags['VantaContainsUserData'] = 'true'
    }

    # Update the tags for the current resource
    Update-AzTag -ResourceId $resource.id -Tag $tags -Operation Merge
}

# Set the tag for the resource group based on the resources it contains
$containsUserData = $resources.ResourceType -match "Microsoft\.(Storage|Sql|DocumentDB)/"
$tags = @{
    'VantaNonProd'='true'
    'VantaOwner'='shahid.iqbal@auror.co'
    'VantaContainsUserData'='false'
    'VantaUserDataStored'='event data'
    'VantaDescription'='Fawkes'
}

if ($containsUserData.Count -gt 0) {
    $tags['VantaContainsUserData'] = 'true'
}

# Update the tags for the resource group
$resourceGroup = Get-AzResourceGroup -Name $ResourceGroupName
Update-AzTag -ResourceId $resourceGroup.ResourceId -Tag $tags -Operation Merge