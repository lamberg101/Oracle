set lines 700 pages 10000 long 10000
col sql_id from a30
col snaptime for a30 
select to_char(begin_interval_time,'yy-mm-dd hh24:mi')|| ' - ' || to_char(end_interval_time,'hh24:mi') snaptime,sql_id,plan_hash_value plan_hash, 
(case executions_delta when 0 then 1 else executions_delta end) exec_delta,
trunc((elapsed_time_delta/1000000)) elap_delta_sec,
trunc((elapsed_time_delta/1000000)/(case executions_delta when 0 then 1 else executions_delta end),3) avg_elap_sec, rows_processed_delta rows_delta,
trunc(rows_processed_delta/(case executions_delta when 0 then 1 else executions_delta end)) avg_row,
trunc(disk_reads_delta/(case executions_delta when 0 then 1 else executions_delta end)) disk_reads
from dba_hist_sqlstat a 
join dba_hist_snapshot b 
on (a.snap_id=b.snap_id 
and a.instance_number=b.instance_number)
and begin_interval_time > trunc(sysdate-7) 
and sql_id= '&sqlid' 
and b.instance_number=1 
order by 1;

fc2v0zmnz6fgr