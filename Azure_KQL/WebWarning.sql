AppTraces
| where SeverityLevel >= 3 or Properties['LogLevel'] in ('Error', 'Fatal')
| where AppRoleName hasprefix "fx-prodnz-web-app" 
| project
    _ItemId = _ItemId,
    TimeGenerated = TimeGenerated,
    GroupTitle = strcat('*', tostring(Properties.MessageTemplate), '* :dotnet:'),
    _ResourceId = _ResourceId,
    Message = strcat(iif(isnotempty(Properties.SourceContext), strcat('*', Properties.SourceContext, '*\n'), ''), iif(Message == tostring(Properties.MessageTemplate), '', extract('([^\n]*)', 1, tostring(Message)))),
    Color = '#FF7E47',
    Title = strcat('*', OperationName, '* ', OperationId) 
| extend data = pack_all()
| order by TimeGenerated asc 
| summarize
    TotalResults = count(),
    Items = makelist(data, 3),
    MinTimeGenerated = min(TimeGenerated),
    MaxTimeGenerated = max(TimeGenerated),
    _ResourceId = any(_ResourceId)
    by GroupTitle 
| extend SearchUrlFilterJson = pack('eventTypes', pack_array(1, 4, 2, 6, 13, 3, 5), 'typeFacets', pack('MessageTemplate', pack_array(GroupTitle))) 
| order by MinTimeGenerated