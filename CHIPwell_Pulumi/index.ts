import * as pulumi from "@pulumi/pulumi";
import * as resources from "@pulumi/azure-native/resources";
import * as storage from "@pulumi/azure-native/storage";
import "./RecoveryVault"; // Import the Recovery Vault module
import "./vm"; // Import the Virtual Machine module
import "./storage"; // Import the Storage Account module

// Create or read an Azure Resource Group
const resourceGroup = 'devChristopher';

