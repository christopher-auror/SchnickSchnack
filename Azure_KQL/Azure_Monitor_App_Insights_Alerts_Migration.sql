ap-prodau-web-app-response-slow-excluding-expected-endpoints-alert (OLD)
requests
| extend path = tostring(parse_url(url).Path)
| summarize 
    count_ = count(),
    p50 = percentile(duration, 50)
    by path, bin(timestamp, 1h)
| where path !contains "ScheduledTransition/TriggerAll" // This is slow, we know and we don't mind
| where path !contains "AurorAdmin/AllDebts" // This is slow, we know and we don't mind
| where 
    (path contains "Payment/Create" and p50 > 4000)
or  (path !contains "Payment/Create" and p50 > 1500)


ap-prodau-web-app-response-slow-excluding-expected-endpoints-alert (NEW)
AppRequests
| extend path = tostring(parse_url(Url).Path)
| summarize 
    count_ = count(),
    p50 = percentile((DurationMs), 50)
    by path, bin(TimeGenerated, 1h)
| where path !contains "ScheduledTransition/TriggerAll" // This is slow, we know and we don't mind
| where path !contains "AurorAdmin/AllDebts" // This is slow, we know and we don't mind
| where 
    (path contains "Payment/Create" and p50 > 4000)
or  (path !contains "Payment/Create" and p50 > 1500)

------------------------------------------------------------------------------------------------

CEXP event publishing (OLD)
union isfuzzy=true traces
| where severityLevel in ("2")
| where message has "Coles Express batch event publishing failed"
| order by timestamp desc

CEXP event publishing (NEW)
union isfuzzy=true AppTraces
| where SeverityLevel  in ("2")
| where Message has "Coles Express batch event publishing failed"
| order by TimeGenerated desc

------------------------------------------------------------------------------------------------

Critical - Alfiepay failed to communicate a change back to Fawkes (OLD)
traces
| where * contains "FawkesDebtRecoveryEventService" 
| where * matches regex "OrgId \\d+, IntelEventId \\d+"
| order by timestamp desc


Critical - Alfiepay failed to communicate a change back to Fawkes (NEW)
AppTraces
| where * contains "FawkesDebtRecoveryEventService" 
| where * matches regex "OrgId \\d+, IntelEventId \\d+"
| order by TimeGenerated desc

------------------------------------------------------------------------------------------------

fx-prodau-fawkes-alert-mgmt-db-scaling-failed (OLD)
traces
| where cloud_RoleName =~ 'fx-prodau-func-app-mgmt-all' and operation_Name =~ 'ScaleUpDatabase'
| where severityLevel > 1
| order by timestamp desc

fx-prodau-fawkes-alert-mgmt-db-scaling-failed (NEW)
AppTraces
| where AppRoleName =~ 'fx-prodau-func-app-mgmt-all' and OperationName =~ 'ScaleUpDatabase'
| where SeverityLevel > 1
| order by TimeGenerated desc

------------------------------------------------------------------------------------------------

NZ Police VOI Ingestion (OLD)
traces
| where operation_Name == "POST Voi/AddVoiList"
| where message startswith "Starting ingestion of \"https://fxprodnzstoragevoi.blob.core.windows.net/csv-output/17"

NZ Police VOI Ingestion (NEW)
AppTraces
| where OperationName == "POST Voi/AddVoiList"
| where Message startswith "Starting ingestion of \"https://fxprodnzstoragevoi.blob.core.windows.net/csv-output/17"

------------------------------------------------------------------------------------------------

prodau notification job stopped (OLD)
traces | project timestamp, message | where message contains 'Notification job triggered'

prodau notification job stopped (NEW)
AppTraces | project TimeGenerated, Message | where Message contains 'Notification job triggered'

------------------------------------------------------------------------------------------------

prodau search indexing job stopped (OLD)
traces | project timestamp, message | where message contains 'Search indexing triggered'

prodau search indexing job stopped (NEW)
AppTraces | project TimeGenerated, Message | where Message contains 'Search indexing triggered'

------------------------------------------------------------------------------------------------

Web Error Log (OLD)
traces | where severityLevel >= 3 or customDimensions['LogLevel'] in ('Error', 'Fatal')
| where cloud_RoleName !hasprefix "fx-prodnz-web-app-staging" 
| project ItemId = itemId, Timestamp = timestamp, GroupTitle = strcat('*', tostring(customDimensions.MessageTemplate), '* :dotnet:'), AppName = appName, Message = strcat(iif(isnotempty(customDimensions.SourceContext), strcat('*', customDimensions.SourceContext, '*\n'), ''), iif(message == tostring(customDimensions.MessageTemplate), '', extract('([^\n]*)', 1, tostring(message)))), Color = '#FF7E47', Title = strcat('*', operation_Name, '* ', operation_Id) 
| extend data = pack_all() | order by Timestamp asc 
| summarize TotalResults = count(), Items = makelist(data, 3), MinTimestamp = min(Timestamp), MaxTimestamp = max(Timestamp), AppName = any(AppName) by GroupTitle 
| extend SearchUrlFilterJson = pack('eventTypes', pack_array(1, 4, 2, 6, 13, 3, 5), 'typeFacets', pack('MessageTemplate', pack_array(GroupTitle))) 
| order by MinTimestamp

Web Error Log (NEW)
AppTraces | where SeverityLevel >= 3 or Properties['LogLevel'] in ('Error', 'Fatal')
| where AppRoleInstance !hasprefix "fx-prodnz-web-app-staging" 
| project _ItemId = _ItemId, TimeGenerated = TimeGenerated, GroupTitle = strcat('*', tostring(Properties.MessageTemplate), '* :dotnet:'), _ResourceId = _ResourceId, Message = strcat(iif(isnotempty(Properties.SourceContext), strcat('*', Properties.SourceContext, '*\n'), ''), iif(Message == tostring(Properties.MessageTemplate), '', extract('([^\n]*)', 1, tostring(Message)))), Color = '#FF7E47', Title = strcat('*', OperationName, '* ', OperationId) 
| extend data = pack_all() | order by TimeGenerated asc 
| summarize TotalResults = count(), Items = makelist(data, 3), MinTimeGenerated = min(TimeGenerated), MaxTimeGenerated = max(TimeGenerated), _ResourceId = any(_ResourceId) by GroupTitle 
| extend SearchUrlFilterJson = pack('eventTypes', pack_array(1, 4, 2, 6, 13, 3, 5), 'typeFacets', pack('MessageTemplate', pack_array(GroupTitle))) 
| order by MinTimeGenerated

------------------------------------------------------------------------------------------------

Web Exception Log (OLD)
let validExceptions = exceptions
| extend logLevel = customDimensions.LogLevel
| where cloud_RoleName !hasprefix "fx-prodnz-web-app-staging"
| where (isempty(logLevel) and isempty(severityLevel)) or (isnotempty(logLevel) and logLevel in ('Error', 'Fatal')) or (isnotempty(severityLevel) and severityLevel >= 3);
let messages = validExceptions
| project logMessage = customDimensions.RenderedMessage, outerMessage, innermostMessage, operation_Id, operation_Name, type, appName
| extend messages = pack_array(logMessage, innermostMessage, outerMessage)
| mvexpand messages
| extend firstLineOfMessage = extract('([^\n]*)', 1, tostring(messages))
| where isnotempty(firstLineOfMessage) and firstLineOfMessage != type
| extend firstLineOfMessage = strcat(substring(firstLineOfMessage, 0, 255), iif(strlen(firstLineOfMessage) > 255, '...', ''))
| summarize messages = makeset(firstLineOfMessage) by operation_Id, operation_Name, type, appName; validExceptions
| order by timestamp asc
| extend method = strcat('*at ', method, '*')
| summarize timestamp = min(timestamp), method = makeset(method), itemId = any(itemId), sdkVersion = any(sdkVersion) by operation_Id, operation_Name, type, appName
| join kind= leftouter messages on operation_Id, operation_Name, type, appName
| extend Message = array_concat(method, messages)
| extend Message = strcat_array(Message, '\n')
| project Title = strcat('*', operation_Name, '* ', operation_Id), Message, Timestamp = timestamp, GroupTitle = strcat('*', type, '*',
iif(sdkVersion has 'javascript', ' :js:', ' :dotnet:')), ExceptionType = type, Color = iif(sdkVersion has 'javascript', '#F0DB4E', '#68257B'), ItemId = itemId, AppName = appName
| extend data = pack_all()
| summarize TotalResults = count(), Items = makelist(data, 3), MinTimestamp = min(Timestamp), MaxTimestamp = max(Timestamp) by GroupTitle, ExceptionType, AppName
| extend SearchUrlFilterJson = pack('eventTypes', pack_array(1, 4, 2, 6, 13, 3, 5), 'typeFacets', pack('basicException.typeName', pack_array(ExceptionType)))
| order by MinTimestamp

Web Exception Log (NEW)
let validExceptions = AppExceptions
| extend logLevel = Properties.LogLevel
| where AppRoleName !hasprefix "fx-prodnz-web-app-staging"
| where (isempty(logLevel) and isempty(SeverityLevel)) or (isnotempty(logLevel) and logLevel in ('Error', 'Fatal')) or (isnotempty(SeverityLevel) and SeverityLevel >= 3);
let Message = validExceptions
| project logMessage = Properties.RenderedMessage, OuterMessage, InnermostMessage, OperationId, OperationName, Type, _ResourceId
| extend Message = pack_array(logMessage, InnermostMessage, OuterMessage)
| mvexpand Message
| extend firstLineOfMessage = extract('([^\n]*)', 1, tostring(Message))
| where isnotempty(firstLineOfMessage) and firstLineOfMessage != Type
| extend firstLineOfMessage = strcat(substring(firstLineOfMessage, 0, 255), iif(strlen(firstLineOfMessage) > 255, '...', ''))
| summarize Message = makeset(firstLineOfMessage) by OperationId, OperationName, Type, _ResourceId; validExceptions
| order by TimeGenerated asc
| extend Method = strcat('*at ', Method, '*')
| summarize TimeGenerated = min(TimeGenerated), Method = makeset(Method), _ItemId = any(_ItemId), SDKVersion = any(SDKVersion) by OperationId, OperationName, Type, _ResourceId
| join kind= leftouter Message on OperationId, OperationName, Type, _ResourceId
| extend Message = array_concat(Method, Message)
| extend Message = strcat_array(Message, '\n')
| project Title = strcat('*', OperationName, '* ', OperationId), Message, TimeGenerated = TimeGenerated, GroupTitle = strcat('*', Type, '*',
iif(SDKVersion has 'javascript', ' :js:', ' :dotnet:')), ExceptionType = Type, Color = iif(SDKVersion has 'javascript', '#F0DB4E', '#68257B'), _ItemId = _ItemId, _ResourceId = _ResourceId
| extend data = pack_all()
| summarize TotalResults = count(), Items = makelist(data, 3), MinTimeGenerated = min(TimeGenerated), MaxTimeGenerated = max(TimeGenerated) by GroupTitle, ExceptionType, _ResourceId
| extend SearchUrlFilterJson = pack('eventTypes', pack_array(1, 4, 2, 6, 13, 3, 5), 'TypeFacets', pack('basicException.TypeName', pack_array(ExceptionType)))
| order by MinTimeGenerated

------------------------------------------------------------------------------------------------

Web Warnings (OLD)
traces
| where customDimensions['LogLevel'] == ('Warning') or severityLevel == 2
| project 
    GroupTitle = strcat('*', tostring(customDimensions.MessageTemplate), '* :warning:')
    , AppName = appName
    , Timestamp = timestamp
    , ItemId = itemId
    , Title = strcat('*', operation_Name, '* ', operation_Id) 
    , Color = '#f1e7fe'
    , Message = message 
| extend data = pack_all() 
| summarize 
    TotalResults = count()
    , Items = makelist(data, 3)
    , MinTimestamp = min(Timestamp)
    , MaxTimestamp = max(Timestamp) by GroupTitle, AppName
| order by TotalResults desc

Web Warnings (NEW)
AppTraces
| where Properties['LogLevel'] == ('Warning') or SeverityLevel == 2
| project 
    GroupTitle = strcat('*', tostring(Properties.MessageTemplate), '* :warning:')
    , _ResourceId = _ResourceId
    , TimeGenerated = TimeGenerated
    , _ItemId = _ItemId
    , Title = strcat('*', OperationName, '* ', OperationId) 
    , Color = '#f1e7fe'
    , Message = Message 
| extend data = pack_all() 
| summarize 
    TotalResults = count()
    , Items = makelist(data, 3)
    , MinTimeGenerated = min(TimeGenerated)
    , MaxTimeGenerated = max(TimeGenerated) by GroupTitle, _ResourceId
| order by TotalResults desc


------------------------------------------------------------------------------------------------