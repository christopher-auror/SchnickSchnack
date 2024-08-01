# Prompt the user for the source resource group name
$resourceRG = Read-Host "Enter the source resource group name"

# Prompt the user for the target resource group name
$resourceRG = Read-Host "Enter the source resource group name"

# Get all the role assignments from the source resource group
$roleAssignments = Get-AzRoleAssignment -ResourceGroupName $sourceRG

# Loop through each role assignment and assign the same role to the target resource group
foreach ($assignment in $roleAssignments) {
    New-AzRoleAssignment -ObjectId $assignment.ObjectId -RoleDefinitionName $assignment.RoleDefinitionName -ResourceGroupName $targetRG
}
