
--CHECK OUTPUT VIA SQLPLUS
select output 
from v$rman_status
where session_recid in 
    (select session_recid from v$rman_status where start_time > sysdate-30)
order by recid ;



------------------------------------------------------------------------------------------------------------------------------

--CHECK RECID
select session_recid, session_stamp, start_time 
from v$rman_status 
where session_recid in
    (select session_recid from v$rman_status where start_time > sysdate-50)
order by recid ;


------------------------------------------------------------------------------------------------------------------------------

--CHECK OTHERS
set linesize 1000
set pagesize 300
col time_taken_display for a10
select session_recid, session_stamp,input_type, status, 
to_char(start_time,'dd/mm/yyyy hh24:mi') start_time,
output_device_type 
from v$rman_backup_job_details 
order by session_key desc;
    