*** HK FRA standby **

archive log list; 
--kadang hasilnya di standby 0, makanya Check manual pake script dibawah

select sequence#,applied from v$archived_log where thread#=1 order by 1;
select sequence#,applied from v$archived_log where thread#=2 order by 1;


-- cek SYNCH ODG :
select max(sequence#) from v$log_history;

=======================================================================================================================

--RESTART DEST_STATE
alter system set log_archive_dest_state_2=DEFER SCOPE=BOTH SID='*';
alter system set log_archive_dest_state_2=ENABLE SCOPE=BOTH SID='*';

-----------------------------------------------------------------------------------------------------------------------

--RESTART MRP
select INST_ID,sequence#,process,status from gv$managed_standby where process like 'MRP%';

--SHUTDOWN MRP
alter database recover managed standby database cancel;

--ACTIVATE MRP
alter database recover managed standby database using current logfile disconnect from session;

--check status sequence
select process, thread#, sequence#, status from v$managed_standby;

=======================================================================================================================

alter system set log_archive_dest_2 ='SERVICE="zdlrabsda-scan:1521/rabsdp:dedicated",  VALID_FOR=(ALL_LOGFILES, ALL_ROLES) ASYNC DB_UNIQUE_NAME=rabsdp' sid='*' scope=both;
alter system set log_archive_dest_2=ENABLED sid='*' scope=both;


=======================================================================================================================

alter session set nls_date_format = 'DD-MON-YY HH24:MI:SS';
select sysdate, applied_time from gv$logstdby_progress;


set lines 999
col name for a30
col value for a30
select name, value, unit from v$dataguard_stats;
select applied_time, latest_time, mining_time, restart_time from v$logstdby_progress;


set linesize 200
set pagesize 200
col high_scn format 99999999999999999
col type for a15
col status for a100
select type, status, high_scn  from v$logstdby;


--Check LAST TIME APPLY (YES)
set lines 999
select t.sequence#,t.applied,t.first_time,t.next_time,t.completion_time 
from v$archived_log t 
where t.applied='YES' 
order by t.sequence# asc;


column dict_begin format a10;
select file_name, sequence#, first_change#, next_change#, timestamp, dict_begin, dict_end, thread# as thr# 
from dba_logstdby_logorder by sequence#;


column status format a50
column type format a12
SELECT TYPE, HIGH_SCN, STATUS FROM V$LOGSTDBY;


column name format a35
column value format a35
select name, value from v$logstdby_stats where name like 'coordinator%' or name like 'transactions%';

select sequence#, first_time, applied from dba_logstdby_log order by sequence#;


--check status sequence
select process, thread#, sequence#, status from v$managed_standby;


--Check PAKE INIIIII
select name, value, unit from v$dataguard_stats;

col last_app_timestamp for a22
select a.thread#, b.last_seq as pimary, a.applied_seq as standby, a.last_app_timestamp, b.last_seq-a.applied_seq arc_diff 
from (select thread#, max(sequence#) applied_seq, to_char(max(next_time),'dd-mm-yyyy hh24:mi:ss') last_app_timestamp 
from gv$archived_log 
where applied = 'YES' or applied ='IN-MEMORY' group by thread#) a,(select  thread#, max (sequence#) last_seq 
from gv$archived_log group by thread#) b where a.thread# = b.thread#;



1. Checking arhive sequence db standby ngrs txnsolopdb2 (by PAM)

col name for a60
set lines 300
set pages 999
select name, first_time, applied,thread#, sequence# 
from gv$archived_log 
where applied = 'YES' 
order by 5 asc;


--Check LOG GAP NYA 
set linesize 999
col event for a70
col status for a100
select to_char(event_time, 'MM/DD HH24:MI:SS') time, event, status 
from dba_logstdby_events 
order by event_time, commit_scn, current_scn;


---ALTER ALL LOGFILE
alter system switch all logfile;


alter system set log_archive_dest_state_2=ENABLE SCOPE=BOTH SID='*';
================================================================================================================

--Check STATUS DEST
set linesize 200
set pagesize 200
col destination for a40
select inst_id,destination, status, error from gv$archive_dest;


--Check ERROR
set linesize 200
set pagesize 200
select inst_id, dest_id,status, error 
from gv$archive_dest_status where dest_id in (1,2,3);


SELECT  distinct a.sql_id, a.blocking_session,a.blocking_session_serial#,
a.user_id,s.sql_text,a.module, a.sample_time
FROM  V$ACTIVE_SESSION_HISTORY a, v$sql s
where a.sql_id=s.sql_id
and blocking_session is not null
and a.user_id <> 0 
and a.sample_time between to_date('22/10/2021 20:00', 'dd/mm/yyyy hh24:mi')
and to_date('22/10/2021 21:30', 'dd/mm/yyyy hh24:mi');



select sequence#, process, status from v$managed_standby where process like 'MRP%';
select process from v$managed_standby where process like 'MRP%'; 

--Check PASS_FILE
col username for a20
col last_login for a40
select username, sysoper, sysasm, sysbackup, sysdg, syskm, account_status, expiry_date, last_login
from v$pwfile_users;


--ALTER TO SYS --gap ke ODG
alter system set redo_transport_user='SYS' sid='*' scope=both;

--ALTER TO RAVPC1 --gap ke zdlra
alter system set redo_transport_user='RAVPC1' sid='*' scope=both;

alter system switch all logfile; 

=======================================================================================================================

--HK BASED ON SEQUENCE

set pages 999
set lines 999
select dest_id, thread#, sequence#, first_time, next_time, blocks, standby_dest, archived, registrar, applied, deleted, status, fal 
from gv$archived_log where THREAD#=1 and applied='YES' and deleted='NO' 
order by first_change# desc fetch first 2000 row only;

RMAN>
delete force archivelog from sequence 32246 until sequence 32246 thread 1;


set pages 999
set lines 999
select dest_id, thread#, sequence#, first_time, next_time, blocks, standby_dest, archived, registrar, applied, deleted, status, fal 
from gv$archived_log where THREAD#=2 and applied='YES' and deleted='NO' 
order by first_change# desc fetch first 2000 row only;

RMAN>
delete force archivelog from sequence 32732 until sequence 32744 thread 2;
