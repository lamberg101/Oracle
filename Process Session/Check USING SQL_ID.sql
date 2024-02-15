1. Check using sql_id

SELECT sid, serial#, USERNAME,MACHINE,SQL_ID, STATUS 
from v$session 
where SQL_ID='7d3rnu30jk89j';

---------------------------------------------------------------------------------------------------------------------------------------

2. sql run history :

set linesize 200
set pages 100
col username for a32
select username,b.user_id,b.sql_id,b.SQL_EXEC_START,b.TIME_WAITED 
from dba_users a, dba_hist_active_sess_history b 
where a.user_id=b.user_id 
and sql_id='awah734w7dzj4' 
and username <> 'SYS' order by 4;



---------------------------------------------------------------------------------------------------------------------------------------

3. GENERATE PLAN CHANGE REPORT SQL_ID >> Check rata-rata elapsed time 

set echo off hea on
set lines 700 pages 10000 long 10000
col sql_id from a30
col snaptime for a30 
select to_char(begin_interval_time,'yy-mm-dd hh24:mi')|| ' - ' || to_char(end_interval_time,'hh24:mi') snaptime,sql_id,PLAN_HASH_VALUE PLAN_HASH,
(CASE EXECUTIONS_DELTA WHEN 0 THEN 1 ELSE EXECUTIONS_DELTA END) EXEC_DELTA,
TRUNC((ELAPSED_TIME_DELTA/1000000)) ELAP_DELTA_SEC,
TRUNC((ELAPSED_TIME_DELTA/1000000)/(CASE EXECUTIONS_DELTA WHEN 0 THEN 1 ELSE EXECUTIONS_DELTA END),3) AVG_ELAP_SEC,
ROWS_PROCESSED_DELTA ROWS_DELTA,
TRUNC(ROWS_PROCESSED_DELTA/(CASE EXECUTIONS_DELTA WHEN 0 THEN 1 ELSE EXECUTIONS_DELTA END)) AVG_ROW,TRUNC(DISK_READS_DELTA/(CASE EXECUTIONS_DELTA WHEN 0 THEN 1 ELSE EXECUTIONS_DELTA END)) DISK_READS
from dba_hist_sqlstat a join dba_hist_snapshot b on (a.snap_id=b.snap_id and a.instance_number=b.instance_number)
and begin_interval_time > trunc(sysdate-7) and sql_id like '44jzaaysdf3ns' and b.instance_number=1 order by 1;


---------------------------------------------------------------------------------------------------------------------------------------

4. Check full using SQL_ID

set linesize 999
set pagesize 999
col INST_ID for 999
col TIME for a10
col MACHINE for a35
col USERNAME for a10
col osuser for a15
col event for a30
sql_fulltext for a60
col sid for 9999999
select a.INST_ID,a.machine,a.osuser,a.username,a.sid,a.serial#,a.SQL_ID,a.EVENT,
(case
   when trunc(last_call_et)<60 then to_char(trunc(last_call_et))||' Sec(s)'
   when trunc(last_call_et/60)<60 then to_char(trunc(last_call_et/60))||' Min(s)'
   when trunc(last_call_et/60/60)<24 then to_char(trunc(last_call_et/60/60))||' Hour(s)'
   when trunc(last_call_et/60/60/24)>=1  then to_char(trunc(last_call_et/60/60/24))||' Day(s)'
end) as time,sql_fulltext
from gv$session a,gv$sqlarea b
where a.sql_address=b.address
and a.sql_hash_value=b.hash_value
and a.sql_id in ('0cqg483k3s3rq')
and a.username is not null
and users_executing>0 order by 6 desc;
