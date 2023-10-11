param(
    [Parameter(Mandatory)]
    [string]
    $SubscriptionId,

    [Parameter(Mandatory)]
    [string]
    $SourceServerName,

    [Parameter(Mandatory)]
    [string]
    $SourceResourceGroupName,

    [Parameter(Mandatory)]
    [string]
    $DestServerName,

    [Parameter(Mandatory)]
    [string]
    $DestResourceGroupName
)

try {
    # Connect to Azure with managed identity
    Connect-AzAccount -Identity -ErrorAction Stop

    # Set the active subscription
    Set-AzContext -SubscriptionId $SubscriptionId -ErrorAction Stop

    # Get all firewall rules from the source SQL server
    $sourceFirewallRules = Get-AzSqlServerFirewallRule -ServerName $SourceServerName -ResourceGroupName $SourceResourceGroupName -ErrorAction Stop

    # Get all firewall rules from the destination SQL server
    $destFirewallRules = Get-AzSqlServerFirewallRule -ServerName $DestServerName -ResourceGroupName $DestResourceGroupName -ErrorAction Stop

    # Initialize a counter for new firewall rules
    $newRulesCount = 0

    # Initialize an array to hold the jobs for creating new firewall rules
    $newRuleJobs = @()

    # Loop through each firewall rule from the source SQL server
    foreach ($sourceRule in $sourceFirewallRules) {
        # Check if the firewall rule already exists on the destination SQL server
        if (-not ($destFirewallRules | Where-Object {$_.StartIpAddress -eq $sourceRule.StartIpAddress -and $_.EndIpAddress -eq $sourceRule.EndIpAddress})) {
            # Create the same firewall rule on the destination SQL server as a job
            $newRuleJobs += New-AzSqlServerFirewallRule -ServerName $DestServerName -ResourceGroupName $DestResourceGroupName -FirewallRuleName $sourceRule.FirewallRuleName -StartIPAddress $sourceRule.StartIpAddress -EndIPAddress $sourceRule.EndIpAddress -AsJob -ErrorAction Stop
            $newRulesCount++
        }
    }

    # Wait for all new firewall rule jobs to complete
    $newRuleJobs | Wait-Job | Out-Null

    # Output message if no new firewall rules were added
    if ($newRulesCount -eq 0) {
        Write-Output "No new firewall rules were found"
    } else {
        # Output the number of new firewall rules added to the destination SQL server and resource group
        Write-Output "$newRulesCount new firewall rules added to $DestServerName in resource group $DestResourceGroupName."
    }
} catch {
    Write-Error $_.Exception.Message
}