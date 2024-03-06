// General schema:
pulumi import <type> <name> <id>

// Example
pulumi import aws:s3/bucket:Bucket infra-logs company-infra-logs

// Pulumi Stack in techauror
- FawkesProdAu
- FawkesProdNz
- FawkesProdUk
- FawkesProdUs
- FawkesQA
- FawkesSandbox

// Fawkes Prod AU

fx-prodau-site-client-app-insight
/subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesProdAu/providers/microsoft.insights/components/fx-prodau-site-client-app-insight

fx-prodau-web-app-insight
/subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesProdAu/providers/microsoft.insights/components/fx-prodau-web-app-insight

// Fawkes Prod NZ

fx-prodnz-site-client-app-insight
/subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesProdNz/providers/microsoft.insights/components/fx-prodnz-site-client-app-insight

fx-prodau-web-app-insight
/subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesProdAu/providers/microsoft.insights/components/fx-prodau-web-app-insight

// Fawkes Prod UK

fx-produk-site-client-app-insight
/subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesProdUk/providers/microsoft.insights/components/fx-produk-site-client-app-insight

fx-produk-web-app-insight
/subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesProdUk/providers/microsoft.insights/components/fx-produk-web-app-insight

// Fawkes Prod US

fx-produs-site-client-app-insight
/subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesProdUs/providers/microsoft.insights/components/fx-produs-site-client-app-insight

fx-produs-web-app-insight
/subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesProdUs/providers/microsoft.insights/components/fx-produs-web-app-insight

// FAWKES QA
pulumi import azure-native:insights:Component fx-qa-site-client-app-insight /subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesQa/providers/microsoft.insights/components/fx-qa-site-client-app-insight -s FawkesQA

fx-qa-site-client-app-insight
/subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesQa/providers/microsoft.insights/components/fx-qa-site-client-app-insight

fx-qa-web-app-insight
/subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesQa/providers/microsoft.insights/components/fx-qa-web-app-insight

// FAWKES Sandbox

fx-sb-site-client-app-insight
/subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesSandbox/providers/microsoft.insights/components/fx-sb-site-client-app-insight

fx-sb-web-app-insight
/subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesSandbox/providers/microsoft.insights/components/fx-sb-web-app-insight





