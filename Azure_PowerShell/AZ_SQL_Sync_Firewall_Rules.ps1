param(
    [Parameter(Mandatory=$True)]
    [string]
    $SubscriptionId,

    [Parameter(Mandatory=$True)]
    [string]
    $SourceServerName,

    [Parameter(Mandatory=$True)]
    [string]
    $SourceResourceGroupName,

    [Parameter(Mandatory=$True)]
    [string]
    $DestServerName,

    [Parameter(Mandatory=$True)]
    [string]
    $DestResourceGroupName
)

# Connect to Azure with managed identity
Connect-AzAccount -Identity

# Set the active subscription
Set-AzContext -SubscriptionId $SubscriptionId

# Get all firewall rules from the source SQL server
$sourceFirewallRules = Get-AzSqlServerFirewallRule -ServerName $SourceServerName -ResourceGroupName $SourceResourceGroupName 

# Get all firewall rules from the destination SQL server
$destFirewallRules = Get-AzSqlServerFirewallRule -ServerName $DestServerName -ResourceGroupName $DestResourceGroupName 

# Initialize a counter for new firewall rules
$newRulesCount = 0

# Loop through each firewall rule from the source SQL server
foreach ($sourceRule in $sourceFirewallRules) {
    # Check if the firewall rule already exists on the destination SQL server
    $destRule = $destFirewallRules | Where-Object {$_.FirewallRuleName -eq $sourceRule.FirewallRuleName -and $_.StartIpAddress -eq $sourceRule.StartIpAddress -and $_.EndIpAddress -eq $sourceRule.EndIpAddress}
    if (!$destRule) {
        # Create the same firewall rule on the destination SQL server
        New-AzSqlServerFirewallRule -ServerName $DestServerName -ResourceGroupName $DestResourceGroupName -FirewallRuleName $sourceRule.FirewallRuleName -StartIPAddress $sourceRule.StartIpAddress -EndIPAddress $sourceRule.EndIpAddress
        $newRulesCount++
    }
}

# Output the number of new firewall rules added
Write-Output "$newRulesCount new firewall rules added to $DestServerName."