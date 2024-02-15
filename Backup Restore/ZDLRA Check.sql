

---CHECK RESERVED SPACE AND DB SIZE ESTIMATE
set numf 9,999,999.999  
set lines 1000 pages 1000
col recovery_window_goal for a30 
col new_recovery_window for a30 
col max_retention_window for a30 
col db_unique_name for a20 
select PURGE_ORDER, rad.DB_UNIQUE_NAME, size_estimate, disk_reserved_space, space_usage, PCT_STORAGE 
from ra_purging_queue rapq, ra_database rad 
where rapq.db_key=rad.db_key
and  rad.DB_UNIQUE_NAME='OPDMSNEW'
order by PCT_STORAGE desc;

------------------------------------------------------------------------------------------------------------------------------

--CHECK SIZE ZDLRA
set numf 9,999,999.999
column name format a10
SELECT name, total_space, used_space, freespace, freespace_goal, SUM(recovery_window_space) sum_recovery_window_space
FROM ra_storage_location JOIN ra_database ON (storage_location = name)
GROUP BY name, total_space, used_space, freespace, freespace_goal;


------------------------------------------------------------------------------------------------------------------------------


--CHECK JOB RUNNING
SELECT task_type, priority, state, count(*) current_count,
      DECODE(state, 'RUNNING',TO_CHAR(MIN(last_execute_time), 'DD-MON-YYYY HH24:MI:SS'),NULL) last_execute_time,
      (CASE WHEN priority >= 300 
      THEN 'Maintenance' WHEN task_type IN ('PURGE_SBT', 'BACKUP_SBT','RESTORE_SBT', 'OBSOLETE_SBT')
      THEN 'SBT' ELSE 'Work' END) work_type, TO_CHAR(MIN(creation_time), 'DD-MON-YYYY') min_creation
FROM ra_task WHERE archived = 'N'
GROUP BY state, task_type, priority
ORDER BY state, priority desc;

