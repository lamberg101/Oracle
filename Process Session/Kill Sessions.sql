--COLLECT KILL 
select 'ALTER SYSTEM KILL SESSION '''||sid||','||serial#||',@'||inst_id||''' IMMEDIATE;' 
from gv$session 
where username=''
--sql_id in ('b72dhugj0xz9p')
and last_call_et > (60*60*1)
order by inst_id;


--last_call_et > (60/60) 
--last_call_et > (60*60*24) 1 hari

--last_call_et > (60*60*1) 1 jam
--last_call_et > (60*60*24) 1 hari
--last_call_et > (60*60*240) 10 hari

------------------------------------------------------------------------------------------------------------------------------------

--where sql_id ='4rm5mf1t7vcb5'

select 'ALTER SYSTEM KILL SESSION '''||sid||','||serial#||',@'||inst_id||''' IMMEDIATE;' 
FROM gv$session 
where sid in (17)
and serial# in (63843)
ORDER BY inst_id;
	        
ALTER SYSTEM KILL SESSION '222,53655,@1' IMMEDIATE;




------------------------------------------------------------------------------------------------------------------------------------


select 'ALTER SYSTEM KILL SESSION '''||sid||','||serial#||',@'||inst_id||''' IMMEDIATE;' 
FROM gv$session 
where username in ('TR_USER','ESBPAPP')
and status='INACTIVE'
AND last_call_et > (60*3)
and inst_id='1'
ORDER BY inst_id;



SELECT 
'alter system kill session ''' || SID || ',' || s.serial# || ',@'||inst_id||''';',sid,username,serial#,process,NVL (sql_id, 0),
sql_address,blocking_session,wait_class,event,p1,p2,p3,seconds_in_wait
FROM gv$session s WHERE blocking_session_status = 'VALID'
OR sid IN (SELECT blocking_session
FROM gv$session WHERE blocking_session_status = 'VALID');


------------------------------------------------------------------------------------------------------------------------------------

--ALL JOBS 
select * from  all_jobs;

--Check STATUS
select sid, serial#, inst_id, status, sql_id from gv$session 
where sid in (1206)
;


==========================================================================================================================================

--KILL SESSION RMAN OS
ps -ef | grep rman ---> lihat paling kiri pid nya
lalu kill -9 pid --kill -9 309186

kill -9 pid1 pid2 pid3 dst

--KILL SESSION RMAN SQLPLUS
select 'alter system kill session '''||sid||','||serial#||',@'||inst_id||''' IMMEDIATE;'  
from gv$session 
where username is not null and program like 'rman%';

------------------------------------------------------------------------------------------------------------------------------------

--CHECK SESSION RMAN AVAILABLE
set linesize 900
select b.inst_id, b.sid, b.serial#, a.spid, b.client_info, to_char(b.logon_time, 'hh24:mi dd/mm/yy') LOGON_TIME 
from gv$process a, gv$session b where a.addr=b.paddr 
and client_info like 'rman%';
  

--ALTER KILL 
select 'ALTER SYSTEM KILL SESSION '''||b.sid||','||b.serial#||',@'||b.inst_id||''' IMMEDIATE;' 
from gv$process a, gv$session b where a.addr=b.paddr 
and client_info like 'rman%';

------------------------------------------------------------------------------------------------------------------------------------

--Kill OS LEVEL
ps -ef | grep 348889 ---> untuk Check
kill -9 spid
kill -9 127376


--kill background
ps -ef | grep LOCAL=NO
kill -9 `ps -ef | grep LOCAL=NO | grep oracleODRMSS3C1| grep -v grep | awk '{print $2}'`


------------------------------------------------------------------------------------------------------------------------------------

--KILL SESSION INACTIVE USER.
set pages 999
set lines 999
select 'alter system kill session '''||sid||','||serial#||',@'||inst_id||''' IMMEDIATE;' 
from gv$session 
where username in ('DOM_USER','DOM')
and last_call_et > (60*30) 
and status = 'INACTIVE' 
order by inst_id;

--last_call_et > (60*60*1) 1 jam
--last_call_et > (60*60*24) 1 hari
--last_call_et > (60*60*240) 10 hari
