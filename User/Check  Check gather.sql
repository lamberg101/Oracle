--------------------------------------------------------------------------------------------------------------------------------------------------------	

--Check GATHER SCHEMA: 
set lines 300
col operation for a30
col target for a35
col start_time for a40
col end_time for a40
select * from dba_optstat_operations where operation like 'gather_schema%' order by start_time asc;



--Check GATHER SCHEMA
set lines 300
col operation for a30
col target for a35
col start_time for a40
col end_time for a40
select * from DBA_OPTSTAT_OPERATIONS 
where operation like 'gather_schema%' 
order by start_time asc;



--Check GATHER
set lines 300
col operation for a30
col target for a35
col start_time for a40
col end_time for a40
select operation,job_name, target,start_time, end_time,status  
from DBA_OPTSTAT_OPERATIONS 
where operation like '%gather%' 
--and job_name like '%job%'
order by start_time asc;



--Check ERRORS
set linesize 200
col owner for a25
col job_name for a30
col status for a16
col actual_start_date for a50
select owner,job_name,status,actual_start_date,run_duration, errors
from DBA_SCHEDULER_JOB_RUN_DETAILS 
where job_name like '%gather%';



--IDENTIFY STALE STATS
col table_name for a30
col partition_name for a20
col subpartition_name for a20
select owner,table_name,partition_name,subpartition_name,num_rows,last_analyzed 
from DBA_TAB_STATISTICS 
where stale_stats='YES';


