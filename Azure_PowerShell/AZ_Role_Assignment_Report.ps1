#Login Azure Account
# TODO uncomment - Add-AzAccount
# still has some errors

#Log Analytics query for retrieving Role Assignment addition activities for the past 2 days
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


#Log Analytics query for retrieving Role Assignment removal activities for the past 2 days
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

#Please replace with appropriate workspace ID
$addqueryResults = Invoke-AzOperationalInsightsQuery -WorkspaceId "b316f85a-19b4-42ab-bb06-9cfbef44826d" -Query $addqr
$rmqueryResults = Invoke-AzOperationalInsightsQuery -WorkspaceId "b316f85a-19b4-42ab-bb06-9cfbef44826d" -Query $rmqr

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

#Replace with appropriate path
$qr | Export-Csv -Path ".FileName.csv" -NoTypeInformation -Append
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

#Replace with appropriate path
$qr | Export-Csv -Path ".\Auror-Az-Role-Assignment-Report.csv" -NoTypeInformation -Append
}

# End of Script