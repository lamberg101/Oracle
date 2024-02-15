
--Find the Top 10 long running Query by User parameter
select sofar Blocks_Processed,totalwork Total_Work,round((sofar/totalwork)*100,2) Percentage_Completed,
totalwork-sofar Total_Work_Left,start_time Start_Time,round((elapsed_seconds/60),0) Elapsed_Minutes,
substr(message,1,33) Message,username
from v$session_longops where rownum < 10 and username ='SYS'


--Find the Percentage of Long Running Query Status
select sofar Blocks_Processed,totalwork Total_Work,
totalwork-sofar Total_Work_Left,start_time Start_Time,round((elapsed_seconds/60),0) Elapsed_Minutes,
substr(message,1,33) Message,username, round(sofar/totalwork*100,2) || '%' "Completed"
from v$session_longops where totalwork-sofar > 0 order by start_time desc;


--Find the SQL ID of long running query
SELECT SID, SERIAL#, OPNAME, TARGET, SOFAR, TOTALWORK, UNITS,
TO_CHAR(START_TIME,'DD/MON/YYYY HH24:MI:SS') START_TIME,
TO_CHAR(LAST_UPDATE_TIME,'DD/MON/YYYY HH24:MI:SS') LAST_UPDATE_TIME,
TIME_REMAINING, ELAPSED_SECONDS, MESSAGE, USERNAME
FROM V$SESSION_LONGOPS
WHERE TIME_REMAINING != 0;


--Find the Sql Text related with SQL _id
SELECT SQL_ID, SQL_TEXT, ELAPSED_TIME 
from V$SQL WHERE SQL_ID = (SELECT SQL_ID FROM V$SESSION WHERE SID=????);



--Find the Process running from last 24 hours in longops query
SELECT username,sid, serial#,
TO_CHAR(CURRENT_TIMESTAMP,'HH24:MI:SS') AS curr,
TO_CHAR(start_time,'HH24:MI:SS') AS logon,
(sysdate - start_time)*24*60 AS mins
FROM V$SESSION_LONGOPS
WHERE username is not NULL
AND (SYSDATE - start_time)*24*60 > 1 ;



--Find the percentage of Completed except sys or system user
SELECT a.sid, a.serial#, b.username , opname OPERATION, target OBJECT,
TRUNC(elapsed_seconds, 5) "ET (s)", TO_CHAR(start_time, 'HH24:MI:SS') start_time,
ROUND((sofar/totalwork)*100, 2) "COMPLETE (%)"
FROM v$session_longops a, v$session b
WHERE a.sid = b.sid AND b.username not IN ('SYS', 'SYSTEM') AND totalwork > 0
ORDER BY elapsed_seconds;