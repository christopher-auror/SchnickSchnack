SELECT *
FROM sys.dm_operation_status
WHERE major_resource_id = 'fx-produs-fawkes'
ORDER BY start_time DESC;