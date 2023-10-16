# Select Subscription
az account set --subscription "078fbcee-c3c5-464f-a52c-3a971648cdbc"

# Show all extensions
az vm extension list --resource-group REMOTEACCESS --vm-name prod-aueast-gateway-vm -o table

# List name of extensions
az vm extension image list-names --publisher Microsoft.Azure.ChangeTrackingAndInventory -l australiaeast

# Remove an extension
az vm extension delete -g REMOTEACCESS --vm-name prod-aueast-gateway-vm -n ChangeTracking-Linux

# Add an extensions
az vm extension set -n extName --publisher publisher --vm-name prod-aueast-gateway-vm -g REMOTEACCESS --enable-auto-upgrade true

# Extensions that aren't working
publisher: Microsoft.Azure.ActiveDirectory -> name: AADSSHLoginForLinux
publisher: Microsoft.Azure.Monitor -> name: AzureMonitorLinuxAgent
publisher: Microsoft.GuestConfiguration -> name: ConfigurationForLinux
publisher: Microsoft.Azure.Security.Monitoring -> name: AzureSecurityLinuxAgent
publisher: Microsoft.Azure.ChangeTrackingAndInventory -> name: ChangeTracking-Linux
publisher: Qualys -> name: QualysAgentLinux
publisher: Microsoft.Azure.AzureDefenderForServers -> name: MDE.Linux

# Azure regions
eastus
eastus2
westus
centralus
northcentralus
southcentralus
northeurope
westeurope
eastasia
southeastasia
japaneast
japanwest
australiaeast
australiasoutheast
australiacentral
brazilsouth
southindia
centralindia
westindia
canadacentral
canadaeast
westus2
westcentralus
uksouth
ukwest
koreacentral
koreasouth
francecentral
southafricanorth
uaenorth
switzerlandnorth
germanywestcentral
norwayeast
jioindiawest
westus3
swedencentral
qatarcentral
polandcentral
italynorth
israelcentral