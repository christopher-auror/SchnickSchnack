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
traces | where severityLevel >= 3 or customDimensions['LogLevel'] in ('Error', 'Fatal') | project ItemId = itemId, Timestamp = timestamp, GroupTitle = strcat('*', tostring(customDimensions.MessageTemplate), '* :dotnet:'), AppName = appName, Message = strcat(iif(isnotempty(customDimensions.SourceContext), strcat('*', customDimensions.SourceContext, '*\n'), ''), iif(message == tostring(customDimensions.MessageTemplate), '', extract('([^\n]*)', 1, tostring(message)))), Color = '#FF7E47', Title = strcat('*', operation_Name, '* ', operation_Id) | extend data = pack_all() | order by Timestamp asc | summarize TotalResults = count(), Items = makelist(data, 3), MinTimestamp = min(Timestamp), MaxTimestamp = max(Timestamp), AppName = any(AppName) by GroupTitle | extend SearchUrlFilterJson = pack('eventTypes', pack_array(1, 4, 2, 6, 13, 3, 5), 'typeFacets', pack('MessageTemplate', pack_array(GroupTitle))) | order by MinTimestamp

Web Error Log (NEW)
AppTraces | where SeverityLevel >= 3 or Properties['LogLevel'] in ('Error', 'Fatal') | project ItemId = ReferencedItemId, Timestamp = TimeGenerated, GroupTitle = strcat('*', tostring(Properties.MessageTemplate), '* :dotnet:'), AppName = AppRoleName, Message = strcat(iif(isnotempty(Properties.SourceContext), strcat('*', Properties.SourceContext, '*\n'), ''), iif(Message == tostring(Properties.MessageTemplate), '', extract('([^\n]*)', 1, tostring(Message)))), Color = '#FF7E47', Title = strcat('*', OperationName, '* ', OperationId) | extend data = pack_all() | order by Timestamp asc | summarize TotalResults = count(), Items = makelist(data, 3), MinTimestamp = min(Timestamp), MaxTimestamp = max(Timestamp), AppName = any(AppName) by GroupTitle | extend SearchUrlFilterJson = pack('eventTypes', pack_array(1, 4, 2, 6, 13, 3, 5), 'typeFacets', pack('MessageTemplate', pack_array(GroupTitle))) | order by MinTimestamp

------------------------------------------------------------------------------------------------

Web Exception Log (OLD)
traces | where severityLevel >= 3 or customDimensions['LogLevel'] in ('Error', 'Fatal') | project ItemId = itemId, Timestamp = timestamp, GroupTitle = strcat('*', tostring(customDimensions.MessageTemplate), '* :dotnet:'), AppName = appName, Message = strcat(iif(isnotempty(customDimensions.SourceContext), strcat('*', customDimensions.SourceContext, '*\n'), ''), iif(message == tostring(customDimensions.MessageTemplate), '', extract('([^\n]*)', 1, tostring(message)))), Color = '#FF7E47', Title = strcat('*', operation_Name, '* ', operation_Id) | extend data = pack_all() | order by Timestamp asc | summarize TotalResults = count(), Items = makelist(data, 3), MinTimestamp = min(Timestamp), MaxTimestamp = max(Timestamp), AppName = any(AppName) by GroupTitle | extend SearchUrlFilterJson = pack('eventTypes', pack_array(1, 4, 2, 6, 13, 3, 5), 'typeFacets', pack('MessageTemplate', pack_array(GroupTitle))) | order by MinTimestamp

Web Exception Log (NEW)
AppTraces | where SeverityLevel >= 3 or Properties ['LogLevel'] in ('Error', 'Fatal') | project ItemId = ReferencedItemId, Timestamp = TimeGenerated, GroupTitle = strcat('*', tostring(Properties.MessageTemplate), '* :dotnet:'), AppName = AppRoleName, Message = strcat(iif(isnotempty(Properties.SourceContext), strcat('*', Properties.SourceContext, '*\n'), ''), iif(Message == tostring(Properties.MessageTemplate), '', extract('([^\n]*)', 1, tostring(Message)))), Color = '#FF7E47', Title = strcat('*', OperationName, '* ', OperationId) | extend data = pack_all() | order by Timestamp asc | summarize TotalResults = count(), Items = makelist(data, 3), MinTimestamp = min(Timestamp), MaxTimestamp = max(Timestamp), AppName = any(AppName) by GroupTitle | extend SearchUrlFilterJson = pack('eventTypes', pack_array(1, 4, 2, 6, 13, 3, 5), 'typeFacets', pack('MessageTemplate', pack_array(GroupTitle))) | order by MinTimestamp

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
| where Properties ['LogLevel'] == ('Warning') or SeverityLevel == 2
| project 
    GroupTitle = strcat('*', tostring(Properties.MessageTemplate), '* :warning:')
    , AppName = AppRoleName
    , Timestamp = TimeGenerated
    , ItemId = ReferencedItemId
    , Title = strcat('*', OperationId, '* ', OperationId) 
    , Color = '#f1e7fe'
    , Message = Message 
| extend data = pack_all() 
| summarize 
    TotalResults = count()
    , Items = makelist(data, 3)
    , MinTimestamp = min(Timestamp)
    , MaxTimestamp = max(Timestamp) by GroupTitle, AppName
| order by TotalResults desc


------------------------------------------------------------------------------------------------