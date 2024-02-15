--Check JUMLAH PARTISI

set lines 300
set pages 100
col TABLE_NAME for a30
col TABLE_OWNER for a30
col TABLESPACE_NAME for a30
col PARTITION_NAME for a40
select TABLE_OWNER, TABLE_NAME, TABLESPACE_NAME, count (PARTITION_NAME) as "JUMLAH PARTISI"
from dba_tab_partitions
where TABLE_OWNER='IFTRG_FA_EXT_CONTRACT' 
and TABLE_OWNER = 'FCC114'
--where TABLESPACE_NAME in ('TRACKINGSTREAM_042022','DELIVERYTRACKING_042022')
group by TABLE_OWNER, TABLE_NAME, TABLESPACE_NAME;



------------------------------------------------------------------------------------------------------------------------

--Check SIZE PARTISI PER TABLE

set lines 300
col segment_name for a30
col segment_type for a30
col PARTITION_NAME for a30
col owner for a30
select owner, TABLESPACE_NAME, segment_name, PARTITION_NAME, segment_type,sum(bytes/1024/1024) MB 
from dba_segments 
where segment_name='TCPUR043T'
and owner='NEWTSPOIN'
group by owner, TABLESPACE_NAME, segment_name, PARTITION_NAME, segment_type
order by MB desc;

TS_DATA_TRX_2022Q3Q4
TS_DATA_TRX_2022Q1Q2

------------------------------------------------------------------------------------------------------------------------

--Check TABLE PER PARTISI

SELECT B.PARTITION_NAME,B.NUM_ROWS ,A.HIGH_VALUE,(bytes/1024/1024) MB 
from DBA_TAB_PARTITIONS A, DBA_TAB_PARTITIONS B, DBA_SEGMENTS C 
where A.PARTITION_NAME = C.PARTITION_NAME 
and a.PARTITION_NAME = B.PARTITION_NAME 
and A.TABLESPACE_NAME = 'DATA' 
order BY MB ASC;

select B.PARTITION_NAME, B.NUM_ROWS, A.HIGH_VALUE, (bytes/1024/1024) MB 
from DBA_TAB_PARTITIONS A, DBA_TAB_PARTITIONS B, DBA_SEGMENTS C 
where A.PARTITION_NAME = C.PARTITION_NAME 
and A.PARTITION_NAME = B.PARTITION_NAME 
and A.TABLESPACE_NAME = 'TRACKINGSTREAM_102020'  
order by MB asc;

------------------------------------------------------------------------------------------------------------------------

--Check SIZE PARTITION WITH PERCENT

COL TABLE_NAME FORMAT A32
COL OBJECT_NAME FORMAT A32
COL OWNER FORMAT A30
set lines 300
set pages 300
SELECT owner, table_name, TRUNC(sum(bytes)/1024/1024) "Size in MB", ROUND( ratio_to_report( sum(bytes) ) over () * 100) Percent, tablespace_name
FROM (SELECT segment_name table_name, owner, bytes, tablespace_name
FROM dba_segments
WHERE segment_type IN ('TABLE', 'TABLE PARTITION', 'TABLE SUBPARTITION')
UNION ALL
SELECT i.table_name, i.owner, s.bytes, s.tablespace_name
FROM dba_indexes i, dba_segments s
WHERE s.segment_name = i.index_name
AND   s.owner = i.owner
AND   s.segment_type IN ('INDEX', 'INDEX PARTITION', 'INDEX SUBPARTITION')
UNION ALL
SELECT l.table_name, l.owner, s.bytes, s.tablespace_name
FROM dba_lobs l, dba_segments s
WHERE s.segment_name = l.segment_name
AND   s.owner = l.owner
AND   s.segment_type IN ('LOBSEGMENT', 'LOB PARTITION')
UNION ALL
SELECT l.table_name, l.owner, s.bytes, s.tablespace_name
FROM dba_lobs l, dba_segments s
WHERE s.segment_name = l.index_name
AND   s.owner = l.owner
AND   s.segment_type = 'LOBINDEX')
WHERE table_name in  (
'PRO_AUTO_REQUEST'
)
--and owner='OWNER_NAME'
GROUP BY table_name, owner, tablespace_name
HAVING SUM(bytes)/1024/1024 > 1
ORDER BY SUM(bytes) asc;



------------------------------------------------------------------------------------------------------------------------

--Check HIGH_VALUE

set lines 999
set pages 999
col high_value for a35
col high_value for a75
col table_owner for a15
col table_name for a30
col partition_name for a30
col tablespace_name for a35
select table_owner, tablespace_name, table_name, partition_name, high_value
from dba_tab_partitions 
where TABLESPACE_NAME in ('TBS_SCV_LOAD_USR')
--where table_owner='DOM'
and table_name='KPI_RECHARGE'
--and partition_name='SYS_P94070'
;



------------------------------------------------------------------------------------------------------------------------

*** Check YG DI MINTA KANG YUYU ***

SELECT LOB_PARTITION_NAME, B.PARTITION_NAME, B.NUM_ROWS, HIGH_VALUE, (BYTES/1024/1024) MB 
FROM DBA_LOB_PARTITIONS A, DBA_TAB_PARTITIONS B, DBA_SEGMENTS C 
WHERE A.LOB_PARTITION_NAME = C.PARTITION_NAME 
AND A.PARTITION_NAME = B.PARTITION_NAME 
AND A.TABLESPACE_NAME = 'DATAL03' 
ORDER BY MB DESC;


------------------------------------------------------------------------------------------------------------------------

--Check PARTITION

set linesize 200
set pagesize 200
col segment_name for a50
col OWNER for a20
col partition_name for a30
select owner,segment_name,partition_name,segment_type,tablespace_name,bytes/1024/1024 MB 
from dba_segments 
where tablespace_name='DGPOS_DATA_NEW' 
and partition_name like '%USER_MESSAGES%'
order by MB asc;

------------------------------------------------------------------------------------------------------------------------

--Check HIGH VALUE / LAST PARTISI

set lines 300
col high_value for a35
select table_owner, table_name, partition_name, high_value 
from dba_tab_partitions
where table_name='t_his_batch_open_invoice'
order by table_name desc;

--LAST PARTISI
select max (RECORD_DTM) from PGATEENH.T_HIS_BATCH_OPEN_INVOICE;       
select max (TRANS_DTM_TSEL) from PGATEENH.T_RECON_PG;		      

note! atau Check dan sesuaikan dengan type nya, cari yg date

------------------------------------------------------------------------------------------------------------------------

--Check SIZE TABLE PARTITION

select sum(bytes)/1024/1024 "Sise in MB" 
from dba_segments where owner='OWNER' 
and segment_type like '%TABLE_PART%' 
and segment_name ='%TRACK_LOGIN%';

--Check SIZE INDEX NYA
select sum(bytes)/1024/1024 "Sise in MB" 
from dba_segments where owner='OWNER' 
and segment_type='INDEX' 
and segment_name like '%NAMA_TABLE%';

TR_USER.TRACK_LOGIN
------------------------------------------------------------------------------------------------------------------------

--CHECK PARTITION TIMESTAMP

set lines 300
col HIGH_VALUE for a35
col table_owner for a30
col table_name for a30
col partition_name for a30
select TABLE_OWNER, TABLE_NAME, PARTITION_NAME, HIGH_VALUE 
from DBA_TAB_PARTITIONS
where TABLESPACE_NAME='DELIVERYTRACKING_022022'
order by PARTITION_NAME desc;

------------------------------------------------------------------------------------------------------------------------

--Check TABLE (PARTITION/NON PARTITION)

set linesize 9999 
set pagesize 9999
col segment_name for a30
select OWNER, SEGMENT_NAME, SEGMENT_TYPE, PARTITION_NAME, ROUND(BYTES/(1024*1024),2) SIZE_MB, TABLESPACE_NAME 
from DBA_SEGMENTS 
where SEGMENT_TYPE in ('TABLE', 'TABLE PARTITION', 'TABLE SUBPARTITION','INDEX', 'INDEX PARTITION', 'INDEX SUBPARTITION', 'TEMPORARY', 'LOBINDEX', 'LOBSEGMENT', 'LOB PARTITION')
--and TABLESPACE_NAME LIKE 'COSTE%' 
--and SEGMENT_NAME LIKE 'P2010201%' 
--and partition_name LIKE 'P20100201%'
--and segment_type = 'TABLE'
--and OWNER = 'OTPGATE3' 
--and ROUND(bytes/(1024*1024),2) > 1000 
order by bytes desc;


export ORACLE_HOME=/u02/app/oracle/product/12.1.0/dbhome_10
export ORACLE_SID=ODBIPREP
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/OPatch:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib

export ORACLE_BASE=/u01/apps/oracle
export ORACLE_SID=MODB
export ORACLE_HOME=/u01/app/oracle/product/19.0.0.0/dbhome_1
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
PATH=$PATH:$HOME/bin:$ORACLE_HOME/bin:$ORACLE_HOME/opmn/bin:$ORACLE_HOME/dcm/bin

modb123

========================================================================================================================


--Check INDEX PARTISI

select INDEX_NAME, INDEX_OWNER, HIGH_VALUE, TABLESPACE_NAME 
from dba_ind_partitions
where TABLESPACE_NAME in ('DELIVERYTRACKING_IDX_112021','TRACKINGSTREAM_IDX_112021')
order by INDEX_NAME;

------------------------------------------------------------------------------------------------------------------------

--COUNT ROWS IN PARTITION
SELECT /*+ PARALLEL 10 */ COUNT (*) FROM PROAPP.TBAP_ITEM PARTITION (PART_TBAP_ACTIVE_JAN2038);
SELECT COUNT (*) FROM PROAPP.TBAP_ITEM PARTITION (PART_TBAP_ACTIVE_FEB2038);
