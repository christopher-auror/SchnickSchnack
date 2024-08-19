param(
    [Parameter(Mandatory)]
    [string]
    $SubscriptionId = "078fbcee-c3c5-464f-a52c-3a971648cdbc",

    [Parameter(Mandatory)]
    [string]
    $csvPath = ".\Auror-Az-Role-Assignment-Report.csv",

    [Parameter(Mandatory)]
    [string]
    $workspaceId = "b316f85a-19b4-42ab-bb06-9cfbef44826d"
)

try {
    # Connect to managed identity in our Azure tenant
    Connect-AzAccount -Identity -ErrorAction Stop

    # Set the active subscription
    Set-AzContext -SubscriptionId $SubscriptionId -ErrorAction Stop

    # Log Analytics query for retrieving Role Assignment addition activities for the past 2 days
    $addqr = 'AzureActivity
    | where TimeGenerated > ago(2d)
    | where CategoryValue =~ "Administrative" and  OperationNameValue =~ "Microsoft.Authorization/roleAssignments/write" and ActivityStatusValue =~ "Start"
    | extend RoleDefinition = extractjson("$.Properties.RoleDefinitionId",tostring(Properties_d.requestbody),typeof(string))
    | extend PrincipalId = extractjson("$.Properties.PrincipalId",tostring(Properties_d.requestbody),typeof(string))
    | extend PrincipalType = extractjson("$.Properties.PrincipalType",tostring(Properties_d.requestbody),typeof(string))
    | extend Scope = extractjson("$.Properties.Scope",tostring(Properties_d.requestbody),typeof(string))
    | extend RoleId = split(RoleDefinition,"/")
    | extend InitiatedBy = Caller
    | extend Operation = split(OperationNameValue,"/")
    | project TimeGenerated,InitiatedBy,Scope,PrincipalId,PrincipalType,RoleID=RoleId[4],Operation= Operation[2]'

    # Log Analytics query for retrieving Role Assignment removal activities for the past 2 days
    $rmqr = 'AzureActivity
    | where TimeGenerated > ago(2d)
    | where CategoryValue =~ "Administrative" and OperationNameValue =~ "Microsoft.Authorization/roleAssignments/delete" and (ActivityStatusValue =~ "Success")
    | extend RoleDefinition = extractjson("$.properties.roleDefinitionId",tostring(Properties_d.responseBody),typeof(string))
    | extend PrincipalId = extractjson("$.properties.principalId",tostring(Properties_d.responseBody),typeof(string))
    | extend PrincipalType = extractjson("$.properties.principalType",tostring(Properties_d.responseBody),typeof(string))
    | extend Scope = extractjson("$.properties.scope",tostring(Properties_d.responseBody),typeof(string))
    | extend RoleId = split(RoleDefinition,"/")
    | extend InitiatedBy = Caller
    | extend Operation = split(OperationNameValue,"/")
    | project TimeGenerated,InitiatedBy,Scope,PrincipalId,PrincipalType,RoleID=RoleId[6],Operation= Operation[2]'
}
catch {
    Write-Error "An error occurred: $_"
    exit 1
}

try {
    # Executing the Log Analytics queries
    $addqueryResults = Invoke-AzOperationalInsightsQuery -WorkspaceId $workspaceId -Query $addqr -ErrorAction Stop
    $rmqueryResults = Invoke-AzOperationalInsightsQuery -WorkspaceId $workspaceId -Query $rmqr -ErrorAction Stop
}
catch {
    Write-Error "An error occurred while executing the queries: $_"
    exit 1
}

#Isolating Log Analytics query results
$addqrs = $addqueryResults.Results
$rmqrs = $rmqueryResults.Results

#For each add query result find user/group name and role name to append into the CSV report
foreach ($qr in $addqrs)
{
$rd = Get-AzRoleDefinition -Id $qr.RoleID
if($qr.PrincipalType -eq 'User')
    {     
        $prncpl = Get-AzADUser -ObjectId $qr.PrincipalId
    }
elseif($qr.PrincipalType -eq 'Group'){
        $prncpl = Get-AzADGroup -ObjectId $qr.PrincipalId
    }
else{
        $prncpl = Get-AzADServicePrincipal -ObjectId $qr.PrincipalId
    }
$qr | Add-Member -MemberType NoteProperty -Name 'Role' -Value $rd.Name
$qr | Add-Member -MemberType NoteProperty -Name 'PrincipalName' -Value $prncpl.DisplayName

#Exporting the results to a CSV file
$qr | Export-Csv -Path $csvPath -NoTypeInformation -Append
}

#For each remove query result find user/group name and role name to append into the CSV report
foreach ($qr in $rmqrs)
{
$rd = Get-AzRoleDefinition -Id $qr.RoleID
if($qr.PrincipalType -eq 'User')
    {     
        $prncpl = Get-AzADUser -ObjectId $qr.PrincipalId
    }
elseif($qr.PrincipalType -eq 'Group'){
        $prncpl = Get-AzADGroup -ObjectId $qr.PrincipalId
    }
else{
        $prncpl = Get-AzADServicePrincipal -ObjectId $qr.PrincipalId
    }
$qr | Add-Member -MemberType NoteProperty -Name 'Role' -Value $rd.Name
$qr | Add-Member -MemberType NoteProperty -Name 'PrincipalName' -Value $prncpl.DisplayName

#Exporting the results to a CSV file
$qr | Export-Csv -Path $csvPath -NoTypeInformation -Append
}