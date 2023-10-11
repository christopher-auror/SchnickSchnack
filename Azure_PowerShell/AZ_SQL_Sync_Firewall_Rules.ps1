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
    if (-not ($destFirewallRules | Where-Object {$_.StartIpAddress -eq $sourceRule.StartIpAddress -and $_.EndIpAddress -eq $sourceRule.EndIpAddress})) {
        # Create the same firewall rule on the destination SQL server
        New-AzSqlServerFirewallRule -ServerName $DestServerName -ResourceGroupName $DestResourceGroupName -FirewallRuleName $sourceRule.FirewallRuleName -StartIPAddress $sourceRule.StartIpAddress -EndIPAddress $sourceRule.EndIpAddress
        $newRulesCount++
    }
}

# Output message if no new firewall rules were added
if ($newRulesCount -eq 0) {
    Write-Output "No new firewall rules were found"
} else {
    # Output the number of new firewall rules added to the destination SQL server and resource group
    Write-Output "$newRulesCount new firewall rules added to $DestServerName in resource group $DestResourceGroupName."
}