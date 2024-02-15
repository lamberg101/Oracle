1. On each compute server: at the linux prompt get the Recovery Appliance version

$ rpm --query ra_automation
2. For  ZDLRA  Version 12.2.1.1.1 and higher, on the first compute server at the linux prompt as root user

#  racli version
3. On each compute server: at the linux prompt get the Recovery Appliance release information

$ $ORACLE_HOME/rdbms/utl/list-zdlra-patches
$ cat  $ORACLE_HOME/rdbms/install/zdlra/zdlra-software-id
4. On the first compute server: at the linux prompt get the Cluster status

$ $GI_HOME/bin/crsctl stat res -t
5. For  ZDLRA  Version 12.2.1.1.1 and higher, on the first compute server at the linux prompt as root user  get the status of the appliance

# racli status appliance
6. On the first compute server: at SQL prompt as catalog owner (rasys)

set pages 60
set lines 79

--Query catalog version
SELECT value FROM config WHERE name = '_build';

-- Query the incident log.
SELECT severity, last_seen, component, task_id, db_unique_name,
error_text
FROM ra_incident_log
WHERE status = 'ACTIVE'
ORDER BY last_seen;

-- Query tasks with incidents
SELECT task_id, state, task_type, error_count, interrupt_count,
creation_time, last_execute_time, error_text
FROM ra_incident_log join ra_task using (task_id)
WHERE status = 'ACTIVE'
AND severity in ('ERROR', 'INTERNAL')
ORDER BY last_seen;

-- Active system info
SELECT state FROM ra_server;
SELECT SUBSTR(job_name, 1,9) job_type, COUNT(*) proc
FROM USER_SCHEDULER_RUNNING_JOBS
GROUP BY SUBSTR(job_name, 1,9)
ORDER BY 1;

-- Query to get current state of live system.
column state format a15
SELECT state, task_type, count(*)
FROM ra_task
WHERE archived = 'N'
GROUP BY state, task_type
ORDER BY state, task_type;

7. On the first compute server: at SQL prompt as catalog owner (rasys)

EXEC DBMS_RA.DUMP(do_dpdump => FALSE);
 a. Now look under /radump directory for a file that is similar to radump_time_<time>__ospid_<spid>_RADUMP.txt that has just been created. The file will be on the first compute server. Upload the file when it has been identified.

ls -lt /radump/radump_time*dat | head
 b. Also locate and upload any RADUMP & DATAPUMP files from around the time of the incident. Looking for the dmp/log/dat files under /radump similar to:

# ls -al *radump_time_103214*
-rw-r----- 1 oracle dba 840052736 Jul 7 10:42 radump_time_103214__ospid_88059_DATAPUMP.dmp
-rw-r--r-- 1 oracle dba 21152 Jul 7 10:42 radump_time_103214__ospid_88059_DATAPUMPlog.log
-rw-r--r-- 1 oracle dba 211774672 Jul 7 10:42 radump_time_103214__ospid_88059_RADUMP.dat
 

8. Upload the output of the ZDLRA System Activity script referenced in the note below:
==>> Zero Data Loss Recovery Appliance System Activity Script (Doc ID 2275176.1)
