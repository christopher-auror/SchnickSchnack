requests
| project
    timestamp,
    id,
    operation_Name,
    success,
    resultCode,
    duration,
    operation_Id,
    cloud_RoleName,
    invocationId=customDimensions['InvocationId']
| where timestamp > ago(30d)
| where cloud_RoleName =~ 'fx-prodnz-func-app-all' and operation_Name =~ 'NZPoliceVOIFunction'
| order by timestamp desc
| take 20
