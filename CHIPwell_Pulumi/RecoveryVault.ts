import * as pulumi from "@pulumi/pulumi";
import * as recoveryservices from "@pulumi/azure-native/recoveryservices/v20240430preview";
import * as azure_native from "@pulumi/azure-native";

// Create or read an Azure Resource Group & Recovery Services Vault
const resourceGroup = 'devChristopher';
const vaultName = 'CHIPwellVault';

const config = new pulumi.Config();
const enableVault = config.getBoolean("enableVault") ?? true;

let vault;
// Create a Recovery Services Vault
if (enableVault) {
    vault = new recoveryservices.Vault(vaultName, {
        identity: {
            type: recoveryservices.ResourceIdentityType.SystemAssigned,
        },
        location: "Australia East",
        properties: {
            publicNetworkAccess: azure_native.recoveryservices.PublicNetworkAccess.Enabled,
        },
        resourceGroupName: resourceGroup,
        sku: {
            name: recoveryservices.SkuName.Standard,
        },
        vaultName: vaultName,
    });
}

// Create a Backup Policy for CHIPwell-VM
if (vault) {
    const protectedItem = new azure_native.recoveryservices.ProtectedItem("CHIPwell-VM", {
        containerName: `IaasVMContainer;iaasvmcontainerv2;${resourceGroup};CHIPwell-VM`,
        fabricName: "Azure",
        properties: {
            policyId: `/subscriptions/d0feba55-594c-4772-8ba8-536ea4f60743/resourceGroups/${resourceGroup}/providers/Microsoft.RecoveryServices/vaults/${vaultName}/backupPolicies/DefaultPolicy`,
            protectedItemType: "Microsoft.Compute/virtualMachines",
            sourceResourceId: `/subscriptions/d0feba55-594c-4772-8ba8-536ea4f60743/resourceGroups/${resourceGroup}/providers/Microsoft.Compute/virtualMachines/CHIPwell-VM`,
        },
        protectedItemName: `VM;iaasvmcontainerv2;${resourceGroup};CHIPwell-VM`,
        resourceGroupName: resourceGroup,
        vaultName: vaultName,
    },
    {
        dependsOn: [vault],
    },
);
}