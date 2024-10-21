import * as pulumi from "@pulumi/pulumi";
import * as azure_native from "@pulumi/azure-native";

const config = new pulumi.Config();
const enableVault = config.getBoolean("enableVault") ?? true;

let vault;
if (enableVault) {
    // Create a Recovery Services Vault
    vault = new azure_native.recoveryservices.Vault("vault", {
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
}

/* // Create a Backup Policy
const backupPolicy = new azure_native.dataprotection.BackupPolicy("exampleBackupPolicy", {
    resourceGroupName: "DevChristopher",
    vaultName: vault.name,
    backupPolicyName: "exampleBackupPolicy",
    properties: {
        policyRules: [
            {
                name: "DailyBackup",
                objectType: "AzureBackupRule",
                backupParameters: {
                    backupType: "Full",
                    objectType: "AzureBackupParams",
                    retentionTagOverrides: [
                        {
                            tagName: "Default",
                            retentionDuration: {
                                count: 30,
                                durationType: "Days",
                            },
                        },
                    ],
                },
                trigger: {
                    schedule: {
                        recurrence: {
                            interval: "Day",
                            count: 1,
                        },
                        timeZone: "UTC",
                        scheduleRunTimes: ["2022-01-01T00:00:00Z"],
                    },
                    objectType: "ScheduleBasedTriggerContext",
                },
            },
        ],
        datasourceTypes: ["AzureVm"],
    },
});
 */