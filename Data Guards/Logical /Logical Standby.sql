--RESTART MRP LOGICAL
--alter database stop logical standby apply;
--alter database start logical standby apply immediate;


--Check UNSUPORTED
select owner,table_name from dba_logstdby_unsupported;


--Check LAST APPLY
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YY HH24:MI:SS';
set lines 999
col NAME for a30
col VALUE for a30
SELECT NAME, VALUE, UNIT FROM V$DATAGUARD_STATS;
SELECT APPLIED_TIME, LATEST_TIME, MINING_TIME, RESTART_TIME FROM V$LOGSTDBY_PROGRESS;


--Check STATUS
set linesize 200
set pagesize 200
col high_scn format 99999999999999999
col type for a15
col status for a100
select type, status, high_scn from gv$logstdby;




--Check DETAIL EVENT
set lines 999
col status for a100
SELECT TO_CHAR(event_time, 'MM/DD HH24:MI:SS') time, commit_scn, current_scn, event, status 
FROM dba_logstdby_events 
ORDER BY event_time, commit_scn, current_scn;



Agung Purwanto, [28.08.21 02:52]
Jalanin 
NODE1
ALTER SESSION DISABLE GUARD;
ALTER SYSTEM FLUSH SHARED_POOL;
ALTER SESSION ENABLE GUARD;

NODE2
ALTER SESSION DISABLE GUARD;
ALTER SYSTEM FLUSH SHARED_POOL;
ALTER SESSION ENABLE GUARD;

Jalanin ini tiap node 1 dan node 2 OPSCM19 yah jgn primary!!



srvctl status database -d OPSCM19
srvctl stop database -d OPSCM19
srvctl start database -d OPSCM19

$ export DISPLAY=10.2.230.111:0.0;
$ ./dbca




--RESTART LSP
1. Stop LSP on logical standby
ALTER database stop logical standby apply;
ALTER SESSION DISABLE GUARD;

2. Defer destination archive to standby
ALTER system set log_archive_dest_state_2=DEFER scope=both sid='*';

3. Start the LSP on logical Standby
ALTER SESSION ENABLE GUARD;
alter database start logical standby apply immediate;

4. Enabel destination archive to standby
ALTER system set log_archive_dest_state_2=ENABLE scope=both sid='*';


SQL> ALTER DATABASE STOP LOGICAL STANDBY APPLY;
SQL> ALTER DATABASE ACTIVATE LOGICAL STANDBY DATABASE;--?
SQL> ALTER DATABASE ACTIVATE LOGICAL STANDBY DATABASE FINISH APPLY;--?