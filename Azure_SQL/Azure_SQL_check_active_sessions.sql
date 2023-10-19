-- count of active SQL sessions
SELECT COUNT(session_id) AS [Active Connections] FROM sys.dm_exec_sessions

-- login time of sessions
SELECT * FROM sys.dm_exec_sessions

-- get more details from active connections
SELECT 
    session_id, 
    login_name, 
    host_name, 
    status, 
    client_interface_name
FROM 
    sys.dm_exec_sessions
WHERE 
    is_user_process = 1;

-- see current requests
SELECT 
    session_id,
    start_time,
    status,
    command,
    sql_handle,
    statement_start_offset,
    statement_end_offset
    database_id
FROM 
    sys.dm_exec_requests;


