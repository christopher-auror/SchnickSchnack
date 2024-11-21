# Connect-AzAccount

$subscriptionName = "Auror Dev/Test Subscription"
$resourceGroupName = "devChristopher"
Get-AzSubscription -SubscriptionName $subscriptionName -WarningAction SilentlyContinue | Set-AZContext -WarningAction SilentlyContinue

try {
    # Get the specified resource group, excluding some managed groups
    $ResourceGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction Stop | where-object {$_.ResourceGroupName -inotlike "MC_*"}
} catch {
    Write-Warning "Failed to get the specified Resource Group"
    exit
}

$ReportObjects = @()
$count = 1
$lockCount = 0

Write-Host "Processing Resource Group: $($ResourceGroup.ResourceGroupName)"
$resources = Get-AzResource -ResourceGroupName $ResourceGroup.ResourceGroupName

foreach ($resource in $resources) {
    Write-Host "Processing $count of $($resources.Count) - Resource: $($resource.Name)"
    $lock = Get-AzResourceLock -ResourceGroupName $ResourceGroup.ResourceGroupName -ResourceName $resource.Name -ResourceType $resource.ResourceType -AtScope

    if ($lock) {
        $lockCount++
    }

    $ReportObjects += [pscustomobject]@{
        'ResourceGroupName' = $ResourceGroup.ResourceGroupName;
        'ResourceName' = $resource.Name;
        'ResourceType' = $resource.ResourceType;
        'Locks' = if ($lock) { $true } else { $false };
    }

    $count++
}

$date = Get-Date
$ReportObjects | Export-Csv -NoClobber -NoTypeInformation "/tmp/report-$($date.Year)$($date.Month)$($date.Day)$($date.Millisecond).csv"
Invoke-Item "/tmp/report-$($date.Year)$($date.Month)$($date.Day)$($date.Millisecond).csv"

Write-Host -ForegroundColor Green "Finished Reporting"
Write-Host -ForegroundColor Magenta "Total Locks Found: $lockCount"