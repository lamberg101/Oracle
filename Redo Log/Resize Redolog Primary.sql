1. Check current size/status
select group#, thread#,sequence#,bytes/1024/1024 "MB", archived, status from v$log;

2. Check standby redolog.
set linesize 900
col MEMBER format a80
SELECT * FROM V$LOGFILE;  


2. resize/add redolog : 
------------
alter database add logfile thread 1 group 13 ('+DATAC2','+RECOC2') size 4096M,group 14 ('+DATAC2','+RECOC2') size 4096M,group 15 ('+DATAC2','+RECOC2') size 4096M,group 16 ('+DATAC2','+RECOC2') size 4096M,group 17 ('+DATAC2','+RECOC2') size 4096M;

alter database add logfile thread 2 group 18 ('+DATAC2','+RECOC2') size 4096M,group 19 ('+DATAC2','+RECOC2') size 4096M,group 20 ('+DATAC2','+RECOC2') size 4096M,group 29 ('+DATAC2','+RECOC2') size 4096M,group 30 ('+DATAC2','+RECOC2') size 4096M;


3. Check lagi
select group#, thread#,sequence#,bytes/1024/1024 "MB", archived, status from v$log;


4. yg sudah inactive, langsung di drop
alter database drop logfile group 7;
alter database drop logfile group 10;
alter database drop logfile group 11;
alter database drop logfile group 12;

5.	Switch redo log / rubah status yg baru di add.
alter system switch logfile;

6. untuk mengubah status redolog nya atau di swicth

alter system checkpoint global;

6. Check lagi
select group#, thread#,sequence#,bytes/1024/1024 "MB", archived, status from v$log;

============================================================================================================================


** RESIZE REDOLOG STANDBY ****

1.	Log Dest Database (--di primary)
alter system set log_archive_dest_state_2=DEFER scope=both sid='*';
note!
Check log_archive_dest_state_ dengan show parameter, 
lalu Check yg valuenya: SERVICE=OPAPM62B1 ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=OPAPM62B

2. Shutdown MRP (---di standby)
alter database recover managed standby database cancel;


3. Check current size/status
select group#, thread#,sequence#,bytes/1024/1024 "MB", archived, status from v$standby_log;

4. Check standby redolog.
set linesize 900
col MEMBER format a80
SELECT * FROM GV$LOGFILE;  


5. resize/add redolog : 
------------
alter database add standby logfile thread 1 
group 31 ('+DATAIMC','+RECOIMC') size 4096M,
group 32 ('+DATAIMC','+RECOIMC') size 4096M,
group 33 ('+DATAIMC','+RECOIMC') size 4096M,
group 34 ('+DATAIMC','+RECOIMC') size 4096M,
group 35 ('+DATAIMC','+RECOIMC') size 4096M,
group 36 ('+DATAIMC','+RECOIMC') size 4096M;

alter database add standby logfile thread 2 
group 37 ('+DATAIMC','+RECOIMC') size 4096M,
group 38 ('+DATAIMC','+RECOIMC') size 4096M,
group 39 ('+DATAIMC','+RECOIMC') size 4096M,
group 40 ('+DATAIMC','+RECOIMC') size 4096M,
group 41 ('+DATAIMC','+RECOIMC') size 4096M,
group 42 ('+DATAIMC','+RECOIMC') size 4096M;


6. Check lagi
select group#, thread#,sequence#,bytes/1024/1024 "MB", archived, status from v$standby_log;

7. yg sudah inactive, langsung di drop
alter database drop standby logfile group 21;
alter database drop standby logfile group 22;
alter database drop standby logfile group 23;
alter database drop standby logfile group 24;
alter database drop standby logfile group 25;
alter database drop standby logfile group 26;
alter database drop standby logfile group 27;
alter database drop standby logfile group 28;



8.	Switch redo log / rubah status yg baru di add.
alter system switch  logfile;
alter system checkpoint global; ==>> untuk mengubah status redolog nya atau di swicth

9. Check lagi
select group#, thread#,sequence#,bytes/1024/1024 "MB", archived, status from v$standby_log;

10. Re-enable 
alter system set log_archive_dest_state_2=ENABLE scope=both sid='*';

11. Activate MRP
SQL> alter database recover managed standby database using current logfile disconnect from session;

12. Check lagi MRP
SELECT PROCESS, STATUS, THREAD#, SEQUENCE#, BLOCK#, BLOCKS 
FROM V$MANAGED_STANDBY
WHERE PROCESS like '%MRP%'
;
