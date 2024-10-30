import * as pulumi from "@pulumi/pulumi";
import * as azure_native from "@pulumi/azure-native"
import * as recoveryservices from "@pulumi/azure-native/recoveryservices/v20240430preview";

// Create or read an Azure Resource Group
const resourceGroup = 'devChristopher';

const config = new pulumi.Config();
const enableVault = config.getBoolean("enableVault") ?? true;

let vault;
// Create a Recovery Services Vault
if (enableVault) {
    vault = new recoveryservices.Vault("vault", {
        identity: {
            type: recoveryservices.ResourceIdentityType.SystemAssigned,
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
        resourceGroupName: resourceGroup,
        sku: {
            name: recoveryservices.SkuName.Standard,
        },
        vaultName: "CHIPWellVault",
    });
}

// Create a Backup Policy
if (vault) {
    const backupPolicy = new recoveryservices.ProtectionPolicy("DailyPolicy", {
        resourceGroupName: resourceGroup,
        vaultName: vault.name,
        properties: {
                backupManagementType: "AzureIaasVM",
                instantRPDetails: {},
                schedulePolicy: {
                    schedulePolicyType: "SimpleSchedulePolicy",
                    scheduleRunFrequency: "Daily",
                    scheduleRunTimes: ["2021-09-01T00:00:00Z"],
                    scheduleWeeklyFrequency: 0,
                },
                tieringPolicy: {
                    ArchivedRP: {
                        tieringMode: "DoNotTier",
                        duration: 0,
                        durationType: "Invalid"
                    },
                },
                instantRpRetentionRangeInDays:3,
                timeZone: "UTC",
                    protectedItemsCount: 0,
                },
            });
        }