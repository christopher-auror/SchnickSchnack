param (
    [Parameter(Mandatory=$true)]
    [string]$workspaceId = "b316f85a-19b4-42ab-bb06-9cfbef44826d",

    [Parameter(Mandatory=$true)]
    [string]$storageAccountName = "cloudshellchristopher",

    [Parameter(Mandatory=$true)]
    [string]$storageContainerName = "auror-azure-reports"
)

[string]$csvPath = "Role-Assignment-Report.csv"
[string]$storageBlobName = "Role-Assignment-Report.csv"

# Connect to managed identity in our Azure tenant
try {
    Connect-AzAccount -Identity -ErrorAction Stop
    Write-Output "Successfully connected to Azure account."
} catch {
    Write-Error "Failed to connect to Azure account: $_"
    exit 1
}

# Log Analytics query for retrieving Role Assignment addition activities for the past one day
$addqr = 'AzureActivity
| where TimeGenerated > ago(1d)
| where CategoryValue =~ "Administrative" and  OperationNameValue =~ "Microsoft.Authorization/roleAssignments/write" and ActivityStatusValue =~ "Start"
| extend RoleDefinition = extractjson("$.Properties.RoleDefinitionId",tostring(Properties_d.requestbody),typeof(string))
| extend PrincipalId = extractjson("$.Properties.PrincipalId",tostring(Properties_d.requestbody),typeof(string))
| extend PrincipalType = extractjson("$.Properties.PrincipalType",tostring(Properties_d.requestbody),typeof(string))
| extend Scope = extractjson("$.Properties.Scope",tostring(Properties_d.requestbody),typeof(string))
| extend RoleId = split(RoleDefinition,"/")
| extend InitiatedBy = Caller
| extend Operation = split(OperationNameValue,"/")
| project TimeGenerated,InitiatedBy,Scope,PrincipalId,PrincipalType,RoleID=RoleId[4],Operation= Operation[2]'

# Log Analytics query for retrieving Role Assignment removal activities for the past one day
$rmqr = 'AzureActivity
| where TimeGenerated > ago(1d)
| where CategoryValue =~ "Administrative" and OperationNameValue =~ "Microsoft.Authorization/roleAssignments/delete" and (ActivityStatusValue =~ "Success")
| extend RoleDefinition = extractjson("$.properties.roleDefinitionId",tostring(Properties_d.responseBody),typeof(string))
| extend PrincipalId = extractjson("$.properties.principalId",tostring(Properties_d.responseBody),typeof(string))
| extend PrincipalType = extractjson("$.properties.principalType",tostring(Properties_d.responseBody),typeof(string))
| extend Scope = extractjson("$.properties.scope",tostring(Properties_d.responseBody),typeof(string))
| extend RoleId = split(RoleDefinition,"/")
| extend InitiatedBy = Caller
| extend Operation = split(OperationNameValue,"/")
| project TimeGenerated,InitiatedBy,Scope,PrincipalId,PrincipalType,RoleID=RoleId[6],Operation= Operation[2]'

# Execute the queries and store the results
$addResults = Invoke-AzOperationalInsightsQuery -WorkspaceId $workspaceId -Query $addqr
$rmResults = Invoke-AzOperationalInsightsQuery -WorkspaceId $workspaceId -Query $rmqr

# Combine the results
$combinedResults = $addResults.Results + $rmResults.Results

# Count the number of role assignments
$roleAssignmentCount = $combinedResults.Count

# Convert the results to CSV format
$combinedResults | Export-Csv -Path $csvPath -NoTypeInformation

try {
    # Upload the CSV file to the Azure Storage account
    $storageContext = New-AzStorageContext -StorageAccountName $storageAccountName -UseConnectedAccount
    Set-AzStorageBlobContent -File $csvPath -Container $storageContainerName -Blob $storageBlobName -Context $storageContext -Force

    Write-Output "CSV file uploaded successfully."
} catch {
    Write-Error "Failed to upload CSV file to Azure Storage account: $_"
    exit 1
}

# Print the success message with the count of role assignments
Write-Output "Role Assignment Report has been generated and uploaded to Azure Storage Account. Total role assignments found: $roleAssignmentCount"