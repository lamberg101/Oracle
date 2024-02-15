--Check job name/status

SQL> 
set lines 999
col JOB_NAME for a30
col OWNER_NAME for a30
col OPERATION for a20
col JOB_MODE for a20
col STATE for a20
select * from dba_datapump_jobs;

OWNER_NAME 	JOB_NAME 			OPERATION 	JOB_MODE 	STATE 		DEGREE ATTACHED_SESSIONS DATAPUMP_SESSIONS
-----------	-------------------	-----------	-----------	-----------	------	---------------- -----------
SYSTEM 		SYS_EXPORT_FULL_01 	EXPORT 		FULL 		EXECUTING 	1 		1 					3


--EXAMPLE:
$ impdp system/oracle@ODC2P3 attach=SYS_IMPORT_TABLE_01
$ expdp '"sys/OR4cl35y5#2015 as sysdba"' attach=SYS_EXPORT_SCHEMA_01


--crosscheks and kill the kill_job
> KILL_JOB
Are you sure you wish to stop this job ([yes]/no): yes




$ impdp system/oracle@ODCEO19 attach=SYS_IMPORT_FULL_01


$ expdp system/oracle@ODPOM attach=SYS_EXPORT_TABLE_01
