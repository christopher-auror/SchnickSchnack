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
$firewallRules = Get-AzSqlServerFirewallRule -ServerName $SourceServerName -ResourceGroupName $SourceResourceGroupName 

# Loop through each firewall rule
foreach ($rule in $firewallRules) {
    # Create the same firewall rule on the destination SQL server
    New-AzSqlServerFirewallRule -ServerName $DestServerName -ResourceGroupName $DestResourceGroupName -FirewallRuleName $rule.FirewallRuleName -StartIPAddress $rule.StartIpAddress -EndIPAddress $rule.EndIpAddress
}
