# Cara unsable index trackring stream

1. Check berdasarkan tablespaces
set lines 300
set pages 1000
col index_owner for a20
col index_name for a30
col partition_name for a20
col high_value for a40
select index_owner, index_name, partition_name, high_value, status, tablespace_name 
from dba_ind_partitions 
where tablespace_name like '%TRACKINGSTREAM_IDX%' order by 6;


2. Alter index partisi berdasarkan tablespace
select 'alter index '||index_owner||'.'||index_name||' modify partition '||partition_name||' UNUSABLE;' from dba_ind_partitions 
where tablespace_name like '%TRACKINGSTREAM_IDX_12%';







