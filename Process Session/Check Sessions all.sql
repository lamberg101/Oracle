--SESSION DALAM SEMINGGU/SEHARI
select count(*) 
from gv$session 
where username='CI_AUDIT' 
and last_call_et > (60*60*1) 
and status = 'INACTIVE'
order by 1;

--1 jam (60*60*1)
--1 hari (60*60*24)
--10 hari (60*60*240)


---------------------------------------------------------------------------------------------------------------------------------------


col machine for a60
  col username for a30
  col osuser for a30
  set lines 300 pages 1000
  SELECT inst_id,machine,username,osuser,
      NVL(active_count, 0) AS active,
      NVL(inactive_count, 0) AS inactive,
      NVL(killed_count, 0) AS killed 
  FROM   ( SELECT inst_id,machine, status,username,osuser, count(*) AS quantity
      FROM   gv$session
      GROUP BY inst_id, status, machine, status,username,osuser)
  PIVOT  (SUM(quantity) AS count FOR (status) IN ('ACTIVE' AS active, 'INACTIVE' AS inactive, 'KILLED' AS killed))
  where username not in ('SYS')
 ---and machine like 'halopoin%'
 --and inst_id='2'
-- and osuser='U s e r'
  ORDER BY inactive asc;



--Check SESSION HA
set lines 300 pages 1000
col machine for a40
col username for a35
col osuser for a35
col SERVICE_NAME for a30
 SELECT INST_ID,machine,username,SERVICE_NAME,last_call_et,
        NVL(active_count, 0) AS active,
        NVL(inactive_count, 0) AS inactive,
        NVL(killed_count, 0) AS killed 
 FROM   ( SELECT INST_ID,machine, status,username,SERVICE_NAME,last_call_et, count(*) AS quantity
          FROM   gv$session where username is not null
      --and service_name like 'OPSCVTBS'
      --and service_name like 'DGSCVHA'
	  --and username='DGSCVHA'
	  and sample_time  
between to_date('03-DEC-2021 00:00:00','DD-MON-YYYY HH24:MI:SS')
and  to_date('03-DEC-2021 01:00:00','DD-MON-YYYY HH24:MI:SS')
	  and username not in ('SYS','SYSDG','PUBLIC')
          GROUP BY INST_ID,machine, status,username,SERVICE_NAME,last_call_et)
 PIVOT  (SUM(quantity) AS count FOR (status) IN ('ACTIVE' AS active, 'INACTIVE' AS inactive, 'KILLED' AS killed))
 ORDER BY machine,username;
 
----------------------------------------------------------------------------------------------------------------------------------------

--Check EVENT

select INST_ID, SQL_ID,event,count(*) from gv$session 
where type!='BACKGROUND' 
and status='ACTIVE' 
group by SQL_ID,event, INST_ID 
order by 3;

----------------------------------------------------------------------------------------------------------------------------------------

col sql format a35
 col username format a20
 col child format 999
 col secs format 9999
 col machine format a12
 col event format a25
 col state format a10
 select /*+ rule */ distinct
 w.sid,s.username,substr(w.event,1,25) event,substr(s.machine,1,12) machine,substr(w.state,1,10) state,s.SQL_ID,--q.CHILD_NUMBER CHILD,
 substr(q.sql_text,1,33) "SQL",round(s.LAST_CALL_ET/60) "MINS", round(s.LAST_CALL_ET) "Sec"
 from gv$session_wait w,gv$session s,gv$sql q where w.event like '%&event%'
 and w.sid=s.sid
 and s.SQL_HASH_VALUE=q.HASH_VALUE(+)
 and s.status='ACTIVE'
 and s.username is not null
 and substr(w.event,1,25) not like 'SQL*Net message from clie%'
 order by "MINS"
 /

----------------------------------------------------------------------------------------------------------------------------------------

--Check SESSION MASUK SELAMA 3 BULAN

set lines 300
set pages 9999
col machine for a32
col username for a32
col event for a32
select /* PARALLEL(12) */ DISTINCT  a.machine,to_char(sample_time,'DD-MON-YYYY') "TGL", a.user_id, b.user_id, b.USERNAME, event
from dba_hist_active_sess_history a, dba_users b
where sample_time  
between to_date('03-DEC-2021 00:00:00','DD-MON-YYYY HH24:MI:SS')
and to_date('03-DEC-2021 01:00:00','DD-MON-YYYY HH24:MI:SS')
and a.user_id=b.user_id
and b.username not in ('DBSNMP','SYSTEM','SYS','BACKUP_ADMIN')
--and b.username='POMAPP_MASS'
--and a.machine='repocrmmgtpapp1.telkomsel.co.id'
order by to_char(sample_time,'DD-MON-YYYY') desc;


set lines 300
set pages 9999
col machine for a32
col username for a32
col event for a32
select /* PARALLEL(12) */ DISTINCT  a.machine, b.username, c.OSUSER, c.status, count(c.status)
from dba_hist_active_sess_history a, dba_users b, gv$session c
where sample_time  
between to_date('01-DEC-2020 00:00:00','DD-MON-YYYY HH24:MI:SS') 
and to_date('25-JAN-2021 10:00:00','DD-MON-YYYY HH24:MI:SS')
and a.user_id=b.user_id
and a.machine=c.machine
and b.username not in ('DBSNMP','SYSTEM','SYS','BACKUP_ADMIN')
group by a.machine, b.username, c.OSUSER, c.status;



select  distinct a.sql_id
from  v$active_session_history a, v$sql s
where a.sql_id=s.sql_id
and blocking_session is not null
and a.user_id <> 0 
and a.sample_time between 
to_date('25/02/2021 15:00', 'dd/mm/yyyy hh24:mi') and ----> SESUAIKAN PARAMETER/TANGGALNYA
to_date('25/02/2021 16:00', 'dd/mm/yyyy hh24:mi');

----------------------------------------------------------------------------------------------------------------------------------------

--Check SESSION YG PAKE DB LINK
set linesize 999
set pagesize 999
col inst_id for 999
col time for a10
col machine for a35
col username for a10
col osuser for a15
col event for a30
select a.inst_id,a.machine,a.status, a.osuser,a.username,a.sid,a.serial#,a.sql_id,a.event, 
from gv$session a,gv$sqlarea b
where a.sql_address=b.address
and a.sql_hash_value=b.hash_value 
and event like '%link%';



set lines 300
set pages 9999
col machine for a40
col username for a32
col event for a32
select /* PARALLEL(4) */ DISTINCT  a.machine, a.user_id, b.user_id, b.username, a.sample_time, sql_id, event
from dba_hist_active_sess_history a, dba_users b
where sample_time  
between to_date('01-APR-2022 00:00:00','DD-MON-YYYY HH24:MI:SS') 
and to_date('02-APR-2022 00:00:00','DD-MON-YYYY HH24:MI:SS')
and a.user_id=b.user_id
and USERNAME not like '%SYS%'
and username not like '%DBSNMP%'
--and sql_id ='6pb6v3bmq4vbx'
--and event like '%replace%'
;



set lines 300
set pages 9999
col machine for a40
col username for a32
col event for a32
select /* PARALLEL(4) */ DISTINCT  a.machine, a.user_id, b.user_id, b.username
from dba_hist_active_sess_history a, dba_users b, DBA_HIST_SQLTEXT s
where sample_time  
between to_date('01-MAR-2022 00:00:00','DD-MON-YYYY HH24:MI:SS') 
and to_date('01-MAY-2022 00:00:00','DD-MON-YYYY HH24:MI:SS')
and a.user_id=b.user_id
AND a.sql_id = s.sql_iD
AND username not in ('SYSTEM','BACKUP_ADMIN','DBSNMP','SYS')
;





--Check PAKE INI KALAU YG DIATAS NO ROW
set lines 900
set pages 9999
set heading on
set long 999999 longchunksize 999999
column sample_time for a25
column username for a16
column sql_text for a80
column program for a30
column machine for a40
column event for a30
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY HH24:MI:SS';
SELECT /* PARALLEL(4) */ h.sample_time, u.username, h.machine, h.event, s.sql_id
--, s.SQL_TEXT
FROM DBA_HIST_ACTIVE_SESS_HISTORY h, DBA_USERS u, DBA_HIST_SQLTEXT s
where sample_time  
between to_date('01-APR-2022 00:00:00','DD-MON-YYYY HH24:MI:SS')
and  to_date('02-APR-2022 00:00:00','DD-MON-YYYY HH24:MI:SS')
AND h.user_id=u.user_id
AND h.sql_id = s.sql_iD
and USERNAME not like '%SYS%'
--AND h.event like '%dblink%'
--AND s.sql_text like '%@TKSRM%'
ORDER BY 1;

----------------------------------------------------------------------------------------------------------------------------------------

--Check ALL SESSION COUNT
set lines 999
set pages 999
select inst_id, status,machine,username,count(*) 
from gv$session where username is not null
group by inst_id, status,machine,username;



set lines 999
set pages 999
select machine,count(*) 
from gv$session 
where machine not like '%-rac-%'
group by machine;


set pages 500
col username for a30
col osuser for a30
col machine for a30
select distinct username,machine, osuser,inst_id,sql_id, count(*) from gv$session  
--where osuser != 'oracle' 
where sid in (141)
group by username,machine, osuser, inst_id, sql_id order by count(*) desc;


----------------------------------------------------------------------------------------------------------------------------------------

select distinct(service_name), count(*) from gv$session group by service_name;

----------------------------------------------------------------------------------------------------------------------------------------


--Check SESSION (COUNT)
set linesize 999   
col username for a30  
col machine for a30 
select inst_id,machine, username, program,status, count(*) 
from gv$session 
group by machine, username,inst_id,status, program 
having count(*) >= 6 
order by count(*) desc;


--SESSION COUNT SQL_ID
set lines 300
select distinct username,machine, osuser,inst_id, sql_id, count(*) 
from gv$session  
where osuser != 'oracle' 
group by username,machine, osuser, inst_id, sql_id
order by count(*) desc;
	


--SESSION (INACTIVE)
set linesize 900
set pages 200
select inst_id, machine, username,count(*), sql_id, status 
from gv$session 
where status = 'INACTIVE' 
group by machine, username,inst_id ,sql_id,status 
order by 1; 


--SESSION (ACTIVE)
set lines 1000
set pages 200
col username for 20
select inst_id,sid,serial#,username,program,machine,status,
--,program,module,
event,sql_id
--,osuser 
from gv$session 
where username is not null
and username='FCC114'
--and status='ACTIVE'
--and machine like '%WORKGROUP%'
order by status
;


set linesize 999
set pagesize 999
col inst_id for 999
col time for a10
col machine for a10
col username for a10
col osuser for a10
col event for a20
select a.INST_ID,a.machine, a.PROGRAM, 
a.status, 
a.osuser,a.username,a.sid,a.serial#,a.SQL_ID,a.EVENT,
(case
   when trunc(last_call_et)<60 then to_char(trunc(last_call_et))||' Sec(s)'
   when trunc(last_call_et/60)<60 then to_char(trunc(last_call_et/60))||' Min(s)'
   when trunc(last_call_et/60/60)<24 then to_char(trunc(last_call_et/60/60))||' Hour(s)'
   when trunc(last_call_et/60/60/24)>=1  then to_char(trunc(last_call_et/60/60/24))||' Day(s)'
end) as time,sql_fulltext
from gv$session a,gv$sqlarea b
where a.sql_address=b.address
and a.sql_hash_value=b.hash_value 
and a.username is not null
--and a.status='INACTIVE'
--and a.username='FCC114'
and users_executing>0 order by time desc;

select status, machine from gv$session where machine like '%SGH%';
----------------------------------------------------------------------------------------------------------------------------------------

--Check UTIL
set lines 200
select inst_id,resource_name, current_utilization, max_utilization, limit_value 
from gv$resource_limit 
where resource_name in ('sessions', 'processes');


-- UTIL DB DENGAN %
set lines 300
col initial_allocation for a17
col limit_value for a12
col RESOURCE_NAME for a30
select inst_id,resource_name,current_utilization,max_utilization,
INITIAL_ALLOCATION,LIMIT_VALUE,round(((current_utilization*100)/(INITIAL_ALLOCATION)),2) as "Process limit %"
from gv$resource_limit
where resource_name in ('sessions', 'processes');


----------------------------------------------------------------------------------------------------------------------------------------

--Check SESSION (yg masuk dari host dan user mana saja)

set linesize 200
set pagesize 200
col machine for a40
col username for a30
select inst_id,machine, username, status, program,count(*)  
from gv$session 
group by machine, username,inst_id, status, program 
having count(*) > 5 
and machine in ('reflexmasspapp2','reflexprempapp5','dombsdpapp1')
order by username, count(*) desc;



----------------------------------------------------------------------------------------------------------------------------------------

--Check SESSIONS (yang masuk lagi ngapain/sql_text)

set linesize 999
set pagesize 999
col inst_id for 999
col time for a10
col machine for a35
col username for a10
col osuser for a15
col event for a30
select a.INST_ID,a.machine, 
--a.PROGRAM, 
a.status, 
a.osuser,a.username,a.sid,a.serial#,a.SQL_ID,a.EVENT,
(case
   when trunc(last_call_et)<60 then to_char(trunc(last_call_et))||' Sec(s)'
   when trunc(last_call_et/60)<60 then to_char(trunc(last_call_et/60))||' Min(s)'
   when trunc(last_call_et/60/60)<24 then to_char(trunc(last_call_et/60/60))||' Hour(s)'
   when trunc(last_call_et/60/60/24)>=1  then to_char(trunc(last_call_et/60/60/24))||' Day(s)'
end) as time,sql_fulltext
from gv$session a,gv$sqlarea b
where a.sql_address=b.address
and a.sql_hash_value=b.hash_value 
and a.username is not null
--and a.SQL_ID = ' ar2t94xfts42k'
--and a.sid =1990
and users_executing>0 order by time desc;


----------------------------------------------------------------------------------------------------------------------------------------

--Check AKTIF SESSION
set linesize 500
set pagesize 1000
column username format a15
column event format a50
column osuser format a15
column spid format a6
column sid format 99999
column serial# format 99999
column lockwait format 99999999
column service_name format a15
column module format a60
column machine format a35
column logon_time format a20
column current_sql format a55
col event for a32
col inst_id for 99
SELECT 	NVL(s.username, '(oracle)') AS username, 
		s.inst_id, 
		s.osuser,
		to_char(s.logon_time,'dd/mm/yyyy hh24:mi:ss')   logon_time,
        s.sid, 
		s.serial#, 
		--p.spid, 
		s.status,
        s.machine, 
		s.event, 
		s.sql_id,
        --s.lockwait,s.module,s.machine,s.program,
        round(s.last_call_et/60,0) last_call,
        SUBSTR(sa.sql_text, 1, 45) current_sql
FROM   gv$session s, gv$process p, gv$sqlarea sa
WHERE  s.paddr = p.addr 
AND s.sql_address    =  sa.address(+) 
AND s.sql_hash_value =  sa.hash_value(+)
--AND s.username NOT LIKE '%oracle%'
--AND s.username NOT in ('DBSNMP','SYS','SYSRAC','SYSTEM')
--and s.username like '%FCCEOD%'
and s.machine like '%SGH43%'
ORDER BY s.logon_time;
  


col inst_id for a30
col osuser for a30
col sid for a30
col serial# for a30
col sql_id for a30
col prev_sql_id for a30
col spid for a30
col lockwait for a30
col status for a30
col module for a30
col machine for a30
col program for a30
SELECT NVL(s.username, '(oracle)') AS username,
       s.inst_id,
       s.osuser,
       s.sid,
       s.serial#,
       s.sql_id,
       s.prev_sql_id,
       p.spid,
       s.lockwait,
       s.status,
       s.module,
       s.machine,
       s.program,
       TO_CHAR(s.logon_Time,'DD-MON-YYYY HH24:MI:SS') AS logon_time
FROM   gv$session s,
       gv$process p
WHERE  s.paddr   = p.addr
AND    s.inst_id = p.inst_id
AND    s.type != 'BACKGROUND'
AND    s.machine like 'LAPTOP%'
ORDER BY s.username, s.osuser;

---------------------------------------------------------------------------------------------------------------------------------------

--Check FAILED LOGON
select machine, a.sample_time, count(1) sum 
from gv$active_session_history a 
where  lower(event) like '%failed%'
and a.sample_time 
between '20-APR-21 02.00.00.00 AM' 
and '20-APR-21 03.00.00.00 PM'
group by machine,a.sample_time 
order by sum;


---------------------------------------------------------------------------------------------------------------------------------------

--Check session rollback/undotbs
SELECT s.username,
       s.SID,
       s.serial#,
       s.logon_time,
       t.xidusn,
       t.ubafil,
       t.ubablk,
       t.used_ublk,
       t.start_time AS txn_start_time,
       t.status,
       ROUND (t.used_ublk * TO_NUMBER (x.VALUE) / 1024 / 1024, 2) || ' Mb'
          "Undo"
  FROM v$session s, v$transaction t, v$parameter x
WHERE s.saddr = t.ses_addr 
AND x.name = 'db_block_size'
and username='CEO';


--Check PROSES rollback (nunggu sampe 0)
select used_ublk from v$transaction;