import * as pulumi from "@pulumi/pulumi";
import * as storage from "@pulumi/azure-native/storage";

// Create or read an Azure Resource Group
const resourceGroup = 'devChristopher';

const config = new pulumi.Config();
const enableSA = config.getBoolean("enableSA") ?? true;

let sa;
let storageAccountKeys;
if (enableSA) {
    // Create an Azure Storage Account
    const storageAccount = new storage.StorageAccount("sa", {
        resourceGroupName: resourceGroup,
        sku: {
            name: storage.SkuName.Standard_LRS,
        },
        kind: storage.Kind.StorageV2,
    });

    // Export the primary key of the Storage Account
    storageAccountKeys = storage.listStorageAccountKeysOutput({
        resourceGroupName: resourceGroup,
        accountName: storageAccount.name
    });
}

export const primaryStorageKey = enableSA && storageAccountKeys ? storageAccountKeys.keys[0].value : undefined;
