# Define the subscription ID and resource group name
$subscriptionId = Read-Host -Prompt "Enter the subscription ID"
$resourceGroupName = Read-Host -Prompt "Enter the resource group name (e.g. FawkesAppProdNz)"

# Define the region
$region = Read-Host -Prompt "Enter the region (AustraliaEast, UKSouth, EastUS2)"
$validRegions = Get-AzLocation | Select-Object -ExpandProperty Location
if ($region -notin $validRegions) {
    Write-Error "Invalid region, please enter a valid Azure region"
    exit
}

# Define the tags to apply to the resource group
$resourceGroupNames = @($resourceGroupName)
$tags = @{
    "CostCategory" = "Product"
    "Description" = "Fawkes"
    "NonProd" = "true"
    "Owner" = "christopher.hipwell@auror.co"
    "UserDataStored" = "event data"
    "ContainsUserdata" = "false"
}

# Set the subscription context
Set-AzContext -SubscriptionId $subscriptionId

# Create resource groups with tags
$resourceGroupNames | ForEach-Object {
    New-AzResourceGroup -Name $_ -Location $region -Tag $tags
    Write-Output "Resource Group '$_' created in region '$region' with tags"
}