1. Check STATUS RMAN

set lines 500
set pages 500
column sid format 9999
column serial# format 9999999
column machine format a32
column progress_pct format 99999999.00
column elapsed format a10
column remaining format a10
col message for a85
select s.sid, s.serial#, s.machine, sl.message, 
round(sl.elapsed_seconds/60) || ':' || MOD(sl.elapsed_seconds,60) elapsed, 
round(sl.time_remaining/60) || ':' || MOD(sl.time_remaining,60) remaining, 
round(sl.sofar/sl.totalwork*100, 2) progress_pct 
from gv$session s, gv$session_longops sl 
where  s.sid = sl.sid AND s.serial# = sl.serial# 
and sl.totalwork>sl.sofar;

--------------------------------------------------------------------------------------------------------

2. Check LOG BACKUP.	

set lines 200
set pages 1000
select output
from GV$RMAN_OUTPUT
where session_recid = &SESSION_RECID
and session_stamp = &SESSION_STAMP
order by recid;


--------------------------------------------------------------------------------------------------------


#Check STATUS RMAN BACKGROUND

SET LINESIZE 100
COLUMN spid FORMAT A10
COLUMN username FORMAT A10
COLUMN program FORMAT A45

SELECT s.inst_id,
       s.sid,
       s.serial#,
       --s.sql_id,
       p.spid,
       s.username,
       s.program
FROM   gv$session s
       JOIN gv$process p ON p.addr = s.paddr AND p.inst_id = s.inst_id
WHERE  s.type != 'BACKGROUND';