# Connect-AzAccount

$subscriptionName = "Auror Dev/Test Subscription"
Get-AzSubscription -SubscriptionName $subscriptionName -WarningAction SilentlyContinue | Set-AZContext -WarningAction SilentlyContinue

$ReportObjects = @()
$totalLockCount = 0

# Get all resource groups in the subscription, excluding some managed groups
$resourceGroups = Get-AzResourceGroup | Where-Object { $_.ResourceGroupName -inotlike "MC_*" }

foreach ($resourceGroup in $resourceGroups) {
    Write-Host "Processing Resource Group: $($resourceGroup.ResourceGroupName)"
    $resources = Get-AzResource -ResourceGroupName $resourceGroup.ResourceGroupName
    $count = 1
    $lockCount = 0

    foreach ($resource in $resources) {
        Write-Host "Processing $count of $($resources.Count) - Resource: $($resource.Name)"
        $lock = Get-AzResourceLock -ResourceGroupName $resourceGroup.ResourceGroupName -ResourceName $resource.Name -ResourceType $resource.ResourceType -AtScope

        if ($lock) {
            $lockCount++
        }

        $ReportObjects += [pscustomobject]@{
            'ResourceGroupName' = $resourceGroup.ResourceGroupName;
            'ResourceName' = $resource.Name;
            'ResourceType' = $resource.ResourceType;
            'Locks' = if ($lock) { $true } else { $false };
        }

        $count++
    }

    Write-Host -ForegroundColor Magenta "Total Locks Found in $($resourceGroup.ResourceGroupName): $lockCount"
    $totalLockCount += $lockCount
}

$date = Get-Date
$ReportObjects | Export-Csv -NoClobber -NoTypeInformation "/tmp/report-$($date.Year)$($date.Month)$($date.Day)$($date.Millisecond).csv"
Invoke-Item "/tmp/report-$($date.Year)$($date.Month)$($date.Day)$($date.Millisecond).csv"

Write-Host -ForegroundColor Green "Finished Reporting"
Write-Host -ForegroundColor Magenta "Total Locks Found: $totalLockCount"