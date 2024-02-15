masuk server
$ sqlplus rasys/ra

--Check BACKUP HISTORY
set linesize 300
set pagesize 1000
col duration format a8
col status format a30
col input_bytes_display format a10
col output_bytes_display format a10
col per_sec format a10
col COMMAND_ID for a20
col START_TIME for a17
col device format a8
SELECT end_time, status, session_key, session_recid, session_stamp, command_id, start_time, 
time_taken_display duration, input_type, output_device_type device, input_bytes_display, output_bytes_display, output_bytes_per_sec_display per_sec
FROM (SELECT end_time, status, session_key, session_recid, session_stamp, command_id, to_char(start_time,'dd/mm/yyyy hh24:mi') start_time, 
time_taken_display, input_type, output_device_type, input_bytes_display, output_bytes_display, output_bytes_per_sec_display
FROM v$rman_backup_job_details ORDER BY end_time ASC);

------------------------------------------------------------------------------------------------------------------

--CHECK BACKUP SYSDATE-8

select input_type, status,
to_char(start_time,'dd/mm/yyyy hh24:mi') start_time,
time_taken_display,
ROUND ((input_bytes/1024/1024/1024),1) input_size_GB,
ROUND ((output_bytes/1024/1024/1024),1) output_size_GB,
output_device_type
from v\$rman_backup_job_details
where start_time > sysdate-8
order by session_key asc;

------------------------------------------------------------------------------------------------------------------

--CHCEK ALL BACKUP
col database_name for a20
col host for a70
col status for a20
set lines 300 pages 1000
select database_name, host, status, 
		to_char(start_time,'dd-MON-yyyy hh24:mi') start_time,
		to_char(end_time,'dd-MON-yyyy hh24:mi') end_time, 
		input_type, output_device_type
from sysman.mgmt$ha_backup
where input_type in ('DB FULL','DB INCR','ARCHIVELOG') and status='FAILED'
and start_time between (sysdate-1) and sysdate
order by host, database_name;


------------------------------------------------------------------------------------------------------------------

--Check BACKUP ElAPSED
set linesize 500 
pagesize 2000 
col Hours format 9999.99 
col STATUS format a10 
select SESSION_KEY, INPUT_TYPE, STATUS, to_char(START_TIME,'mm-dd-yyyy hh24:mi:ss') 
as RMAN_Bkup_start_time, to_char(END_TIME,'mm-dd-yyyy hh24:mi:ss') 
as RMAN_Bkup_end_time, elapsed_seconds/3600 Hours 
from V$RMAN_BACKUP_JOB_DETAILS 
order by session_key;


------------------------------------------------------------------------------------------------------------------


--check total work backup
SELECT SID, SERIAL#, CONTEXT, SOFAR, TOTALWORK,
ROUND (SOFAR/TOTALWORK*100, 2) "% COMPLETE"
FROM V$SESSION_LONGOPS
WHERE OPNAME LIKE 'RMAN%' AND OPNAME NOT LIKE '%aggregate%'
AND TOTALWORK != 0 AND SOFAR <> TOTALWORK order by 6 desc;
