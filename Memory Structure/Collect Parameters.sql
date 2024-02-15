set lines 300
col INSTANCE_NAME for a12
col host_name for a32
col Datafile for 999,999,999.99
col Segment for 999,999,999.99
col sga_max_size for a20
col sga_target for a20
col pga_aggregate_limit for a10
col pga_aggregate_target for a20
col memory_max_target for 999,999,999.99
col memory_target for 999,999,999.99
col database_role  for a20
set colsep '|'
set pages 0
SELECT
(select INSTANCE_NAME from v$instance) INSTANCE_NAME,
(select host_name from v$instance) host_name,
(select sum(bytes/1024/1024/1024) from dba_data_files) Datafile,
(select sum(bytes/1024/1024/1024) from dba_segments) Segment,
(select value/1024/1024 from v$parameter where name = 'sga_max_size') "sga_max_size MB",
(select value/1024/1024 from v$parameter where name = 'sga_target') "sga_target MB" ,
(select value/1024/1024 from v$parameter where name = 'pga_aggregate_limit') "pga_aggregate_limit MB",
(select value/1024/1024 from v$parameter where name = 'pga_aggregate_target') "pga_aggregate_target MB",
(select value/1024/1024 from v$parameter where name = 'memory_max_target') memory_max_target,
(select value/1024/1024 from v$parameter where name = 'memory_target') memory_target
from dual;