PRECHECK LIST	
	
	primary node1
1	 Check cluster
	$ crsctl stat res -t
2	Check service
	$ srvctl status service -d OTOPE
3	backup spfile
	SQL > CREATE PFILE='/home/oracle/ssi/PFILE_otope.ORA FROM SPFILE';
4	Check crontab (capture to notepad)
	$ crontab -l
5	Check parameter  job_queue_processes
	SQL> SHOW PARAMETER JOB  job_queue_processes
	
	primary node1 dan standby node1
6	Check database
	$ ps -ef | grep pmon
	select open_mode from v$database;
	select status from v$instance;
	Check state-2 (harus enable dc dan drc)
	SQL> SHOW PARAMETER state_2 
	
	primary node1
7	Check archive log list, status applied dan gap
	SQL> ARCHIVE LOG LIST
	SQL> select * from v$archive_gap;
	
	standby  node1
8	Check archive log list, status applied dan gap
	SQL> ARCHIVE LOG LIST
	SQL> SELECT  THREAD#,SEQUENCE#,ARCHIVED, APPLIED FROM V$ARCHIVED_LOG WHERE THREAD#=1 ORDER BY 1,2;
	SQL> SELECT  THREAD#,SEQUENCE#,ARCHIVED, APPLIED FROM V$ARCHIVED_LOG WHERE THREAD#=2 ORDER BY 1;
	SQL>select max(sequence#), THREAD#, APPLIED from v$archived_log WHERE APPLIED='YES' GROUP BY thread#,APPLIED;
	
	Aktivity
	
	primary node1
1	remark crontab (copy crontab ke local)
	crontab -e
2	Check parameter job_queue_proses  dan set menjadi=0
	SQL> SHOW PARAMETER JOB  job_queue_processes
	SQL> alter system set job_queue_processes = 0;
3	Shutdown Instance Node 2
	$ srvctl stop instance -d OTOPE -i OTOPE2
4	Check Database Role(status = primary)
	SQL> SELECT DATABASE_ROLE FROM V$DATABASE;
5	Check Switchover Status(status = to_standby atau sessions active)
	SQL> SELECT SWITCHOVER_STATUS FROM V$DATABASE;
6	mengarchivekan redo log terakhir
	alter system archive log current;
7	Melakukan Proses Switchover Database menjadi Standby
	ALTER DATABASE COMMIT TO SWITCHOVER TO PHYSICAL STANDBY WITH SESSION SHUTDOWN;
8	start database
	STARTUP MOUNT
9	Check Database Role (status= DATABASE_ROLE)
	SELECT DATABASE_ROLE FROM V$DATABASE;
10	Check Database Status(status=mounted)
	SQL> select open_mode from v$database;
	
	
	STANDBY (OTOPETBS)
	
No	Command
1	Check Database Role
	SQL> SELECT DATABASE_ROLE FROM V$DATABASE;
	DATABASE_ROLE
	----------------
	PHYSICAL STANDBY
	
2	Check Switchover Status
	SQL> SELECT SWITCHOVER_STATUS FROM V$DATABASE;
	SWITCHOVER_STATUS
	--------------------
	TO PRIMARY
	
3	Melakukan proses switchover (new) primary 
	SQL>ALTER DATABASE COMMIT TO SWITCHOVER TO PRIMARY;
	
4	Melakukan proses restart database
	SQL> SHUTDOWN IMMEDIATE
	SQL> STARTUP
	
5	Shutdown lalu start database di semua node
	SQL> SHUTDOWN IMMEDIATE;
	$ srvctl start database -d OTOPETBS -o OPEN
	
6	Check status semua instance
	$ srvctl status database -d OTOPETBS
	
7	Check Database Role
	SQL> SELECT DATABASE_ROLE FROM V$DATABASE;
	DATABASE_ROLE
	----------------
	PRIMARY
	
8	Edit parameter log_archive_dest_state_2 menjadi ENABLE
	SQL>ALTER SYSTEM SET  log_archive_dest_state_2=ENABLE SCOPE=both;
	
9	set job queue proses ke nilai awal
	SQL> alter system set job_queue_processes = 0;
	SQL> SHOW PARAMETER JOB  job_queue_processes
	
	NEW STANDBY (OTOPE)
No	Command
1	Melakukan apply log process pada database (new) standby
	SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;
	
2	Check recovery mode
	select DEST_ID,dest_name,status,type,srl,recovery_mode from v$archive_dest_status where dest_id=1; 
	
	
	
	post check
	new primary node1
	archive log list;
	alter system switch logfile;  (3kali)
	archive log list;
	SQL> select * from v$archive_gap;
	
	new standby node1
	archive log list;
	SQL> SELECT  THREAD#,SEQUENCE#,ARCHIVED, APPLIED FROM V$ARCHIVED_LOG WHERE THREAD#=1 ORDER BY 1,2
	SQL> SELECT  THREAD#,SEQUENCE#,ARCHIVED, APPLIED FROM V$ARCHIVED_LOG WHERE THREAD#=2 ORDER BY 1
	SQL>select max(sequence#), THREAD#, APPLIED from v$archived_log WHERE APPLIED='YES' GROUP BY thread#,APPLIED;
	
	
	#> srvctl stop database -d OPAPM62A
#> srvctl config database -d OPAPM62A
#> srvctl modify database -d OPAPM62A -r primary
#> srvctl start database -d OPAPM62A
SQL> select name, open_mode, database_role from v$database;

$ srvctl add database -d OTOPETBS -o /u01/app/oracle/product/12.1.0.2/dbhome_1
$ srvctl add instance -d OTOPETBS -i OTOPETBS1 -n exa62tbspdb1-mgt
$ srvctl add instance -d OTOPETBS -i OTOPETBS2 -n exa62tbspdb2-mgt
$ srvctl modify database -d OTOPETBS -r physical_standby
$ srvctl modify database -d OTOPETBS -p '+DATAC5/OTOPETBS/PARAMETERFILE/spfileOTOPETBS.ora'
