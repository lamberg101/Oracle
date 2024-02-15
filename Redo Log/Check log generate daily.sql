Check SIZE LOG GENERATED DAILY.

select trunc(COMPLETION_TIME) TIME, SUM(BLOCKS * BLOCK_SIZE)/1024/1024 SIZE_MB 
from V$ARCHIVED_LOG 
group by trunc (COMPLETION_TIME) 
order by 1;

--Check size Redo generate daily

select trunc(completion_time) rundate,count(*) logswitch, round((sum(blocks*block_size)/1024/1024)) "REDO PER DAY (MB)"
from v$archived_log
group by trunc(completion_time)
order by 1;
