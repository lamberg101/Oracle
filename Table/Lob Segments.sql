--DBA_SEGMENTS
set lines 300
col segment_name for a35
col owner for a35
select  owner,tablespace_name,segment_type,segment_name,sum(bytes/1024/1024) MB 
from dba_segments
--where tablespace_name in ('FOM_OMS_PRD')
where segment_name in (
'SYS_LOB0000512827C00007$$','SYS_LOB0000512858C00007$$','SYS_LOB0000512858C00008$$'
)
--and segment_type in ('LOBSEGMENT','LOBINDEX')
group by owner, tablespace_name, segment_name, segment_type
order by segment_type, segment_name;





--DBA LOBS
col owner for a30
col table_name for a30
col ablespace_name for a30
col column_name for a30
col segment_name  for a30
select owner,table_name,tablespace_name,column_name,segment_name 
from dba_lobs 
where 
--tablespace_name in ('TRIPWIRE_TBS') and 
table_name in 
('SMTB_IMAGE_UPLOAD','SVTM_CIF_SIG_DET','SVTM_CIF_SIG_MASTER') ;



--DBA_SEGMENTS JOIN
set lines 300
set lines 300
col segment_name for a35
col owner for a35
select  a.owner, a.tablespace_name, a.segment_type, b.segment_name,b.table_name,sum(bytes/1024/1024) MB 
from dba_segments a, dba_lobs b
where a.segment_name=b.segment_name
and a.tablespace_name in ('FOM_OMS_PRD','FOM_OMS_PRD_P12','FOM_OMS_PREPRD')
and b.table_name in ('DATA_MODEL','SERVER_CACHE')
and a.segment_type in ('LOBSEGMENT')
group by a.owner, a.tablespace_name, b.segment_name, a.segment_type, b.table_name
order by a.segment_type, b.segment_name;



========================================================================================================================

--Check SIZE DBA_LOB_PARTITIONS

set linesize 200
col table_name for a32
col table_owner for a32
col partition_name for a32
col tablespace_name for a32
select table_owner,table_name,column_name,a.tablespace_name,sum(b.bytes/1024/1024) MB 
from DBA_LOB_PARTITIONS a,dba_segments b 
where a.table_owner=b.owner 
and a.partition_name=b.partition_name 
and a.table_name='KPI_REVENUE_2' 
--and a.tablespace_name='TRACKINGSTREAM_102020' 
group by table_owner,table_name,column_name,a.tablespace_name 
order by 5;