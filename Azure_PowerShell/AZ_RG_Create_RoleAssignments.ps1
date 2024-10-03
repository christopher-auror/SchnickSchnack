# Define the scope of the custom role for Auror Pulumi Previewer (untested)
$previewerRole1 = @{
    Name = "Auror Pulumi Previewer"
    IsCustom = $true
    Description = "Auror Pulumi Previewer"
    AssignableScopes = @(
        "/subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesAppQa",
        "/subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesAppSandbox",
        "/subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesAppProdNz",
        "/subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesAppProdAu",
        "/subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesAppProdUs",
        "/subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesAppProdUk"
    )
}

# Define the scope of the custom role for Auror Pulumi Provisioner (untested)
$provisionerRole2 = @{
    Name = "Auror Pulumi Provisioner"
    IsCustom = $true
    Description = "Auror Pulumi Provisioner"
    AssignableScopes = @(
        "/subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesAppQa",
        "/subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesAppProdNz",
        "/subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesAppProdAu",
        "/subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesAppProdUs",
        "/subscriptions/078fbcee-c3c5-464f-a52c-3a971648cdbc/resourceGroups/FawkesAppProdUk"
    )
}

# Create the custom roles (untested)
New-AzRoleDefinition -InputObject $previewerRole1
New-AzRoleDefinition -InputObject $provisionerRole2


# Engineerin Group - Assign 'Contrubutor' Roles to Resource Groups
$assignments0 = @(
    @{ ResourceGroupName = "FawkesAppQA"; GroupId = "3b607e68-45d6-4140-b022-034fcd2298c0"; GroupName = "engineering" },
    @{ ResourceGroupName = "FawkesAppSandbox"; GroupId = "3b607e68-45d6-4140-b022-034fcd2298c0"; GroupName = "engineering" },
    @{ ResourceGroupName = "FawkesAppProdNz"; GroupId = "3b607e68-45d6-4140-b022-034fcd2298c0"; GroupName = "engineering" },
    @{ ResourceGroupName = "FawkesAppProdAu"; GroupId = "3b607e68-45d6-4140-b022-034fcd2298c0"; GroupName = "engineering" },
    @{ ResourceGroupName = "FawkesAppProdUk"; GroupId = "3b607e68-45d6-4140-b022-034fcd2298c0"; GroupName = "engineering" },
    @{ ResourceGroupName = "FawkesAppProdUs"; GroupId = "3b607e68-45d6-4140-b022-034fcd2298c0"; GroupName = "engineering" }
)

foreach ($assignment0 in $assignments0) {
    New-AzRoleAssignment -ObjectId $assignment0.GroupId -RoleDefinitionName 'Contributor' -ResourceGroupName $assignment0.ResourceGroupName
}

# Fawkes Environment Contributor Groups - Assign 'Contributor' Roles to Resource Groups
$assignments1 = @(
    @{ ResourceGroupName = "FawkesAppQA"; GroupId = "6f75977b-3518-49e0-b405-217e32753152"; GroupName = "fx-qa-sb-contributor" },
    @{ ResourceGroupName = "FawkesAppSandbox"; GroupId = "214fc5d6-aedc-4f39-95b7-26cbaf117785"; GroupName = "fx-sb-contributor" },
    @{ ResourceGroupName = "FawkesAppProdNz"; GroupId = "f0e0c49f-adc4-4e81-b8e2-b927e4fe023d"; GroupName = "fx-prodnz-contributor" },
    @{ ResourceGroupName = "FawkesAppProdAu"; GroupId = "6da10443-78ec-4a39-9a78-9c443ce3f505"; GroupName = "fx-prodau-contributor" },
    @{ ResourceGroupName = "FawkesAppProdUk"; GroupId = "7df49e34-7e44-4812-99a6-db2f503e06e2"; GroupName = "fx-produk-contributor" },
    @{ ResourceGroupName = "FawkesAppProdUs"; GroupId = "014fd7a9-cb07-4b9f-89e6-e38b4fe75282"; GroupName = "fx-produs-contributor" }
)

foreach ($assignment1 in $assignments1) {
    New-AzRoleAssignment -ObjectId $assignment1.GroupId -RoleDefinitionName 'Contributor' -ResourceGroupName $assignment1.ResourceGroupName

# Octopus Deploy Service Principals - Assign Contributor Roles to Resource Groups
$assignments2 = @(
    @{ ResourceGroupName = "FawkesAppQA"; GroupId = "6f75977b-3518-49e0-b405-217e32753152"; GroupName = "Fawkes QA Octopus Deploy" },
    @{ ResourceGroupName = "FawkesAppSandbox"; GroupId = "42887078-ef2d-42ac-81f3-f7862429c58d"; GroupName = "Fawkes Sandbox Octopus Deploy" },
    @{ ResourceGroupName = "FawkesAppProdNz"; GroupId = "02dcc893-28dd-4ca1-9dee-ee12628e8ae4"; GroupName = "Fawkes Prod NZ Octopus Deploy" },
    @{ ResourceGroupName = "FawkesAppProdAu"; GroupId = "270a45e7-c261-44d9-a8cc-ff06eb90f86b"; GroupName = "Fawkes Prod AU Octopus Deploy" },
    @{ ResourceGroupName = "FawkesAppProdUk"; GroupId = "de3fe380-3e99-452b-a237-44eae6ecc4c6"; GroupName = "Fawkes Prod UK Octopus Deploy" },
    @{ ResourceGroupName = "FawkesAppProdUs"; GroupId = "b243a49f-487b-4a9d-bb76-617c093376c9"; GroupName = "Fawkes Prod US Octopus Deploy" }
)

foreach ($assignment2 in $assignments2) {
    New-AzRoleAssignment -ObjectId $assignment2.GroupId -RoleDefinitionName 'Contributor' -ResourceGroupName $assignment2.ResourceGroupName
}

# Pulumi Preview Service Principals - Assign 'Reader' Roles to Resource Groups

$assignments3 = @(
    @{ ResourceGroupName = "FawkesAppQA"; GroupId = "259f1cba-0619-4a34-a81f-8acaff57dca0"; GroupName = "Pulumi-Previewer-FawkesQa" },
    @{ ResourceGroupName = "FawkesAppSandbox"; GroupId = "e81d86ab-2b6a-490a-8b71-355f5d4f51bb"; GroupName = "Pulumi-Previewer-FawkesSandbox" },
    @{ ResourceGroupName = "FawkesAppProdNz"; GroupId = "d4297d50-8b2f-4fce-9296-b787099d1b49"; GroupName = "Pulumi-Previewer-FawkesProdNZ" },
    @{ ResourceGroupName = "FawkesAppProdAu"; GroupId = "2a3e2cef-276b-44e3-8fb8-8dcd4122dd3e"; GroupName = "Pulumi-Previewer-FawkesProdAU" },
    @{ ResourceGroupName = "FawkesAppProdUk"; GroupId = "4d15f691-51a3-4891-a426-2106478b45d4"; GroupName = "Pulumi-Previewer-FawkesProdUK" },
    @{ ResourceGroupName = "FawkesAppProdUs"; GroupId = "d81a5ac6-e284-4804-997b-eb2ebb8d255c"; GroupName = "Pulumi-Previewer-FawkesProdUS" }
)

foreach ($assignment3 in $assignments3) {
    try {
        New-AzRoleAssignment -ObjectId $assignment3.GroupId -RoleDefinitionName 'Reader' -ResourceGroupName $assignment3.ResourceGroupName
    } catch {
        Write-Host "Failed to assign role to $($assignment3.GroupName) in $($assignment3.ResourceGroupName): $_"
    }
}

# Assign Fawkes Environment Cosmos Readers - 'Cosmos DB Account Reader Role' to Resource Groups

$assignments4 = @(
    @{ ResourceGroupName = "FawkesAppQA"; GroupId = "7428ec46-38b6-4e84-abaf-75316963750f"; GroupName = "fx-qa-cosmos-readers" },
    @{ ResourceGroupName = "FawkesAppSandbox"; GroupId = "97a916e5-d6d0-4881-b780-2f8c3f798430"; GroupName = "fx-sb-cosmos-readers" },
    @{ ResourceGroupName = "FawkesAppProdNz"; GroupId = "594b379d-467f-4769-99a0-a57058325f7c"; GroupName = "fx-prodnz-cosmos-readers" },
    @{ ResourceGroupName = "FawkesAppProdAu"; GroupId = "e45bcd87-6939-4d46-a1d0-de7a2191179b"; GroupName = "fx-prodau-cosmos-readers" },
    @{ ResourceGroupName = "FawkesAppProdUk"; GroupId = "a9c78083-a1a1-4509-8f46-e0f0cae0ba0f"; GroupName = "fx-produk-cosmos-readers" },
    @{ ResourceGroupName = "FawkesAppProdUs"; GroupId = "9d22dc8c-3b43-4e98-bfdb-affde1cb6104"; GroupName = "fx-produs-cosmos-readers" }
)

foreach ($assignment4 in $assignments4) {
    New-AzRoleAssignment -ObjectId $assignment4.GroupId -RoleDefinitionName 'Cosmos DB Account Reader Role' -ResourceGroupName $assignment4.ResourceGroupName
}

# Assign Pulumi Previewer Service Principal - 'Auror Pulumi Previewer' Role to Resource Groups

$assignments5 = @(
    @{ ResourceGroupName = "FawkesAppQA"; GroupId = "7c3d76f7-4e08-433c-b6c6-0b3af3b84de7"; GroupName = "Pulumi-Previewer-FawkesQA" },
    @{ ResourceGroupName = "FawkesAppSandbox"; GroupId = "e81d86ab-2b6a-490a-8b71-355f5d4f51bb"; GroupName = "Pulumi-Previewer-FawkesSandbox" },
    @{ ResourceGroupName = "FawkesAppProdNz"; GroupId = "d4297d50-8b2f-4fce-9296-b787099d1b49"; GroupName = "Pulumi-Previewer-FawkesProdNZ" },
    @{ ResourceGroupName = "FawkesAppProdAu"; GroupId = "2a3e2cef-276b-44e3-8fb8-8dcd4122dd3e"; GroupName = "Pulumi-Previewer-FawkesProdAU" },
    @{ ResourceGroupName = "FawkesAppProdUk"; GroupId = "4d15f691-51a3-4891-a426-2106478b45d4"; GroupName = "Pulumi-Previewer-FawkesProdUK" },
    @{ ResourceGroupName = "FawkesAppProdUs"; GroupId = "d81a5ac6-e284-4804-997b-eb2ebb8d255c"; GroupName = "Pulumi-Previewer-FawkesProdUS" }
    @{ ResourceGroupName = "FawkesAppQA"; GroupId = "fe038a6a-ec40-4cdd-81aa-a9d299a8595d"; GroupName = "PulumiPreviewerPreProd" },
    @{ ResourceGroupName = "FawkesAppSandbox"; GroupId = "62972a88-e0e9-42f5-8d14-2f364bf24d41"; GroupName = "PulumiPreviewerProd" },
    @{ ResourceGroupName = "FawkesAppProdNz"; GroupId = "62972a88-e0e9-42f5-8d14-2f364bf24d41"; GroupName = "PulumiPreviewerProd" },
    @{ ResourceGroupName = "FawkesAppProdAu"; GroupId = "62972a88-e0e9-42f5-8d14-2f364bf24d41"; GroupName = "PulumiPreviewerProd" },
    @{ ResourceGroupName = "FawkesAppProdUk"; GroupId = "62972a88-e0e9-42f5-8d14-2f364bf24d41"; GroupName = "PulumiPreviewerProd" },
    @{ ResourceGroupName = "FawkesAppProdUs"; GroupId = "62972a88-e0e9-42f5-8d14-2f364bf24d41"; GroupName = "PulumiPreviewerProd" }
)

foreach ($assignment5 in $assignments5) {
    New-AzRoleAssignment -ObjectId $assignment5.GroupId -RoleDefinitionName 'Auror Pulumi Previewer' -ResourceGroupName $assignment5.ResourceGroupName
}

# Assign Pulumi Provisioner Service Principal - 'Auror Pulumi Provisioner' Role to Resource Groups

$assignments6 = @(
    @{ ResourceGroupName = "FawkesAppQA"; GroupId = "428031b7-8675-4495-bb98-d8a9f56c1721"; GroupName = "Pulumi-Provisioner-FawkesQA" },
    @{ ResourceGroupName = "FawkesAppSandbox"; GroupId = "e63bbd6c-8cf4-4133-a7b8-08354b118143"; GroupName = "Pulumi-Provisioner-FawkesSandbox" },
    @{ ResourceGroupName = "FawkesAppProdNz"; GroupId = "e91782b4-238c-40b2-8c86-f75aea4f8d7f"; GroupName = "Pulumi-Provisioner-FawkesProdNZ" },
    @{ ResourceGroupName = "FawkesAppProdAu"; GroupId = "4430972c-c0be-4e98-82fb-12cfd4bed666"; GroupName = "Pulumi-Provisioner-FawkesProdAU" },
    @{ ResourceGroupName = "FawkesAppProdUk"; GroupId = "012c5b97-8bb6-4892-ad1f-7e01f7e1d4c2"; GroupName = "Pulumi-Provisioner-FawkesProdUK" },
    @{ ResourceGroupName = "FawkesAppProdUs"; GroupId = "6d6b7742-f29b-45cd-95cc-f58f4527087f"; GroupName = "Pulumi-Provisioner-FawkesProdUS" }
    @{ ResourceGroupName = "FawkesAppQA"; GroupId = "428031b7-8675-4495-bb98-d8a9f56c1721"; GroupName = "PulumiProvisionerPreProd" },
    @{ ResourceGroupName = "FawkesAppSandbox"; GroupId = "62972a88-e0e9-42f5-8d14-2f364bf24d41"; GroupName = "PulumiPreviewerProd" },
    @{ ResourceGroupName = "FawkesAppProdNz"; GroupId = "62972a88-e0e9-42f5-8d14-2f364bf24d41"; GroupName = "PulumiPreviewerProd" },
    @{ ResourceGroupName = "FawkesAppProdAu"; GroupId = "62972a88-e0e9-42f5-8d14-2f364bf24d41"; GroupName = "PulumiPreviewerProd" },
    @{ ResourceGroupName = "FawkesAppProdUk"; GroupId = "62972a88-e0e9-42f5-8d14-2f364bf24d41"; GroupName = "PulumiPreviewerProd" },
    @{ ResourceGroupName = "FawkesAppProdUs"; GroupId = "62972a88-e0e9-42f5-8d14-2f364bf24d41"; GroupName = "PulumiPreviewerProd" }
)

foreach ($assignment6 in $assignments6) {
    New-AzRoleAssignment -ObjectId $assignment6.GroupId -RoleDefinitionName 'Auror Pulumi Provisioner' -ResourceGroupName $assignment6.ResourceGroupName
}

# Assign Fawkes Envirornment Contributor - 'Storage Blob Data Contributor' Role to Resource Groups
$assignments7 = @(
    @{ ResourceGroupName = "FawkesAppQA"; GroupId = "6f75977b-3518-49e0-b405-217e32753152"; GroupName = "fx-qa-contributor" },
    @{ ResourceGroupName = "FawkesAppSandbox"; GroupId = "214fc5d6-aedc-4f39-95b7-26cbaf117785"; GroupName = "fx-sb-contributor" },
    @{ ResourceGroupName = "FawkesAppProdNz"; GroupId = "f0e0c49f-adc4-4e81-b8e2-b927e4fe023d"; GroupName = "fx-prodnz-contributor" },
    @{ ResourceGroupName = "FawkesAppProdAu"; GroupId = "6da10443-78ec-4a39-9a78-9c443ce3f505"; GroupName = "fx-prodau-contributor" },
    @{ ResourceGroupName = "FawkesAppProdUk"; GroupId = "7df49e34-7e44-4812-99a6-db2f503e06e2"; GroupName = "fx-produk-contributor" },
    @{ ResourceGroupName = "FawkesAppProdUs"; GroupId = "014fd7a9-cb07-4b9f-89e6-e38b4fe75282"; GroupName = "fx-produs-contributor" }
)

foreach ($assignment7 in $assignments7) {
    New-AzRoleAssignment -ObjectId $assignment7.GroupId -RoleDefinitionName 'Storage Blob Data Contributor' -ResourceGroupName $assignment7.ResourceGroupName
}
