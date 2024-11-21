# Connect-AzAccount
 
$subscriptionName = "Auror Dev/Test Subscription"
Get-AzSubscription -SubscriptionName $subscriptionName -WarningAction SilentlyContinue | Set-AZContext -WarningAction SilentlyContinue
     
try {
    # Get all resource groups, excluding some managed groups
    $ResourceGroups = Get-AzResourceGroup -ErrorAction stop | where-object {$_.ResourceGroupName -inotlike "MC_*"}
} catch {
    Write-Warning "Failed on get Resource Groups"
    continue
}
 
$ReportObjects = @()
$count = 1
$ResourceGroups | foreach-object {
    Write-Host "Processing $count of $($ResourceGroups.Count)"
    $lock = Get-AzResourceLock -ResourceGroupName $_.ResourceGroupName -AtScope
     
    $ReportObjects += [pscustomobject]@{
        'Name' = $_.ResourceGroupName;
        'Owner' = $_.Tags.Owner;
        Criticality = $_.Tags.Criticality;
        Func = $_.Tags.Function;
        Locks = if($lock) {$true} else {$false};
    }
 
    $count++
}
     
$date = Get-Date
$ReportObjects | export-csv -NoClobber -NoTypeInformation "/tmp/report-$($date.Year)$($date.Month)$($date.Day)$($date.Millisecond).csv"
Invoke-Item "/tmp/report-$($date.Year)$($date.Month)$($date.Day)$($date.Millisecond).csv"

 
Write-Host -ForegroundColor Green "Finished Reporting"