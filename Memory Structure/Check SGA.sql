select pool, name, sum (bytes)/1024/1024/1024 
from v$sgastat 
where pool ='shared pool'
and name like '%NUMA%'
group by name, pool;

------------------------------------------------------------------------------------------------------------------------
select * from v$sgainfo;


------------------------------------------------------------------------------------------------------------------------

--SGA RESIZE OPERATION
set lines 1000
set pages 1000
col component for a25
col oper_type for a15
col oper_mode for a10
col parameter for a22
SELECT component, oper_type, oper_mode, parameter, 
initial_size/1024/1024 init_MB,  target_size/1024/1024 target_MB,  
final_size/1024/1024 final_MB, status, to_char(start_time,'dd-mon hh24:mi:ss') started_at, 
to_char(end_time,'dd-mon hh24:mi:ss')  ended_at  
FROM V$SGA_RESIZE_OPS;

------------------------------------------------------------------------------------------------------------------------

select name,SUM (bytes)/1024/1024 as mb from v$sgainfo group by name;

------------------------------------------------------------------------------------------------------------------------

Check resizeable
select name, bytes/1024/1024, resizeable, con_id from dv$sgainfo;



set pages 999
col c1 heading "start|time"
col c2 heading "type"       format a20
col c3 heading "operation"  format a20
break on c1 skip 2
select distinct
   to_char(start_time,'DD-MON-YY hh24:mi') c1,
   parameter c2,
   oper_type c3
from v$memory_resize_ops
order by c1 ;