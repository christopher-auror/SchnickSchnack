// General schema:
pulumi import <type> <name> <id>

// Example
pulumi import aws:s3/bucket:Bucket infra-logs company-infra-logs
pulumi import azure-native:sql:Server SERVERSQL1 /subscriptions/aaaaaa......

// Pulumi Stack in techauror
- FawkesProdAu
- FawkesProdNz
- FawkesProdUk
- FawkesProdUs
- FawkesQA
- FawkesSandbox

// Fawkes Prod AU

/// fx-prodau-site-client-app-insight
/// /subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesProdAu/providers/microsoft.insights/components/fx-prodau-site-client-app-insight

pulumi import azure-native:insights:Component fx-prodau-site-client-app-insight /subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesProdAu/providers/microsoft.insights/components/fx-prodau-site-client-app-insight -s FawkesProdAu

/// fx-prodau-web-app-insight
/// /subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesProdAu/providers/microsoft.insights/components/fx-prodau-web-app-insight

pulumi import azure-native:insights:Component fx-prodau-web-app-insight /subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesProdAu/providers/microsoft.insights/components/fx-prodau-web-app-insight -s FawkesProdAu

// Fawkes Prod NZ

/// fx-prodnz-site-client-app-insight
/// /subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesProdNz/providers/microsoft.insights/components/fx-prodnz-site-client-app-insight

pulumi import azure-native:insights:Component fx-prodnz-site-client-app-insight /subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesProdNz/providers/microsoft.insights/components/fx-prodnz-site-client-app-insight -s FawkesProdNz

/// fx-prodau-web-app-insight
/// /subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesProdAu/providers/microsoft.insights/components/fx-prodau-web-app-insight

pulumi import azure-native:insights:Component fx-prodau-web-app-insight /subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesProdAu/providers/microsoft.insights/components/fx-prodau-web-app-insight -s FawkesProdNz

// Fawkes Prod UK

/// fx-produk-site-client-app-insight
/// /subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesProdUk/providers/microsoft.insights/components/fx-produk-site-client-app-insight

pulumi import azure-native:insights:Component fx-produk-site-client-app-insight /subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesProdUk/providers/microsoft.insights/components/fx-produk-site-client-app-insight -s FawkesProdUk

///  fx-produk-web-app-insight
///  /subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesProdUk/providers/microsoft.insights/components/fx-produk-web-app-insight

pulumi import azure-native:insights:Component fx-produk-web-app-insight /subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesProdUk/providers/microsoft.insights/components/fx-produk-web-app-insight -s FawkesProdUk

//  Fawkes Prod US

/// fx-produs-site-client-app-insight
/// /subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesProdUs/providers/microsoft.insights/components/fx-produs-site-client-app-insight

pulumi import azure-native:insights:Component fx-produs-site-client-app-insight /subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesProdUs/providers/microsoft.insights/components/fx-produs-site-client-app-insight -s FawkesProdUs

/// fx-produs-web-app-insight
/// /subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesProdUs/providers/microsoft.insights/components/fx-produs-web-app-insight

pulumi import azure-native:insights:Component fx-produs-web-app-insight /subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesProdUs/providers/microsoft.insights/components/fx-produs-web-app-insight -s FawkesProdUs

// FAWKES QA

/// fx-qa-site-client-app-insight
/// /subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesQa/providers/microsoft.insights/components/fx-qa-site-client-app-insight

pulumi import azure-native:insights:Component fx-qa-site-client-app-insight /subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesQa/providers/microsoft.insights/components/fx-qa-site-client-app-insight -s FawkesQa

/// fx-qa-web-app-insight
/// /subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesQa/providers/microsoft.insights/components/fx-qa-web-app-insight

pulumi import azure-native:insights:Component fx-qa-web-app-insight /subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesQa/providers/microsoft.insights/components/fx-qa-web-app-insight -s FawkesQa

// FAWKES Sandbox

/// fx-sb-site-client-app-insight
/// /subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesSandbox/providers/microsoft.insights/components/fx-sb-site-client-app-insight

pulumi import azure-native:insights:Component fx-sb-site-client-app-insight /subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesSandbox/providers/microsoft.insights/components/fx-sb-site-client-app-insight -s FawkesSandbox

/// fx-sb-web-app-insight
/// /subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesSandbox/providers/microsoft.insights/components/fx-sb-web-app-insight

pulumi import azure-native:insights:Component fx-sb-web-app-insight /subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesSandbox/providers/microsoft.insights/components/fx-sb-web-app-insight -s FawkesSandbox





