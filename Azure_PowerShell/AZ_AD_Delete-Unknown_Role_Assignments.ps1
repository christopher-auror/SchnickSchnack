param (
    [bool]$DeleteRoleAssignments = $false
)

if (-not (Get-Module -ListAvailable -Name Az)) {
    Write-Output "Installing Az module..."
    Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
}

Connect-AzAccount

$subIds = Get-AzSubscription | Select-Object -ExpandProperty SubscriptionId
foreach ($subId in $subIds) {
    Set-AzContext -SubscriptionId $subId

    $resourceGroups = Get-AzResourceGroup
    foreach ($resourceGroup in $resourceGroups) {
        try {
            $assignments = Get-AzRoleAssignment -ResourceGroupName $resourceGroup.ResourceGroupName -ErrorAction SilentlyContinue

            foreach ($assignment in $assignments) {
                if ($assignment.Properties.ObjectType -eq "Unknown") {
                    Write-Output "Found role assignment $($assignment.RoleDefinitionName) for $($assignment.DisplayName) in $($resourceGroup.ResourceGroupName) in $($subId)"
                    if ($DeleteRoleAssignments) {
                        Write-Output "Removing role assignment $($assignment.RoleDefinitionName) for $($assignment.DisplayName) in $($resourceGroup.ResourceGroupName) in $($subId)"
                        Remove-AzRoleAssignment -ObjectId $assignment.ObjectId -Scope $assignment.Scope -RoleDefinitionName $assignment.RoleDefinitionName -Force
                    }
                }
            }
        }
        catch {
            Write-Error "Error processing resource group $($resourceGroup.ResourceGroupName): $_"
        }
    }

    try {
        $subscriptionsAssignments = Get-AzRoleAssignment -Scope "/subscriptions/$subId" -ErrorAction SilentlyContinue

        foreach ($assignment in $subscriptionsAssignments) {
            if ($assignment.Properties.ObjectType -eq "Unknown") {
                Write-Output "Found role assignment $($assignment.RoleDefinitionName) for $($assignment.DisplayName) in subscription $($subId)"
                if ($DeleteRoleAssignments) {
                    Write-Output "Removing role assignment $($assignment.RoleDefinitionName) for $($assignment.DisplayName) in subscription $($subId)"
                    Remove-AzRoleAssignment -ObjectId $assignment.ObjectId -Scope $assignment.Scope -RoleDefinitionName $assignment.RoleDefinitionName -Force
                }
            }
        }
    }
    catch {
        Write-Error "Error processing subscription-level assignments for subscription $($subId): $_"
    }
}