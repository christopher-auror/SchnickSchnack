-- NZ Alert Query - ANPR Camera Health
let allDetections = traces
| where timestamp > ago(7d)
| where operation_Name == "DetectionProcessorFunction"
| where message has "Successfully processed detection"
| parse message with * "from I"" Camera "I" for site" siteld
| project timestamp, Camera;
let summaryDays = allDetections | summarize CountLast7Days = count(), LatestDetection = max(timestamp) by Camera;
let summaryRecent = allDetections | where timestamp > ago(16h) | summarize CountLast16Hours = count
summaryDays
| I join kind=leftouter summaryRecent on Camera
| extend CountLast16Hours=iff(isnull(CountLast16Hours), 0, CountLast16Hours )
| where CountLast16Hours == 0
| count as numberOfflineSites;