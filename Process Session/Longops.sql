1. Longops

set lines 500
set pages 500
COLUMN sid FORMAT 9999
COLUMN serial# FORMAT 9999999
COLUMN machine FORMAT A32
COLUMN progress_pct FORMAT 99999999.00
COLUMN elapsed FORMAT A10
COLUMN remaining FORMAT A10
col MESSAGE for a85

SELECT s.sid,
       s.serial#,
       s.machine,
     sl.message,
       ROUND(sl.elapsed_seconds/60) || ':' || MOD(sl.elapsed_seconds,60) elapsed,
       ROUND(sl.time_remaining/60) || ':' || MOD(sl.time_remaining,60) remaining,
       ROUND(sl.sofar/sl.totalwork*100, 2) progress_pct
FROM   gv$session s,
       gv$session_longops sl
WHERE  s.sid     = sl.sid
AND    s.serial# = sl.serial#
and sl.totalwork>sl.sofar;


-------------------------------------------------------------------------------------------------------------------------

2. session_longops

select 	SQL_ID,	target_desc, (Sofar*100)/totalwork as percentage_complete 
from gv$session_longops
where SQL_ID like 'fv36q%'
;

-------------------------------------------------------------------------------------------------------------------------

3. sqL_monitor

select 	SQL_ID, ACTION, SQL_TEXT, ELAPSED_TIME, QUEUING_TIME 
from V$SQL_MONITOR
where SQL_ID='4sqpq8km90z6k'
;













