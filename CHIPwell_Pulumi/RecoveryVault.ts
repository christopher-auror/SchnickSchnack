import * as pulumi from "@pulumi/pulumi";
import * as azure_native from "@pulumi/azure-native";

const vault = new azure_native.recoveryservices.Vault("vault", {
    identity: {
        type: azure_native.recoveryservices.ResourceIdentityType.SystemAssigned,
    },
    location: "Australia East",
    properties: {
        monitoringSettings: {
            azureMonitorAlertSettings: {
                alertsForAllJobFailures: azure_native.recoveryservices.AlertsState.Enabled,
            },
            classicAlertSettings: {
                alertsForCriticalOperations: azure_native.recoveryservices.AlertsState.Disabled,
            },
        },
        publicNetworkAccess: azure_native.recoveryservices.PublicNetworkAccess.Enabled,
    },
    resourceGroupName: "DevChristopher",
    sku: {
        name: azure_native.recoveryservices.SkuName.Standard,
    },
    vaultName: "CHIPWellVault",
});