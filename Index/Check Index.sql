Note!
--kalau tanya last use index, cek dlu index monitoring nya on atau off
--saat rebuild index, dari yang kecil ke besar, karena akan makan space juga.
--dan juga bisa pake clause parallel dan online untuk mengindari locking.

----------------------------------------------------------------------------------------------------

--Check INDEX
set linesize 200
set pagesize 200
col index_name for a30
col table_name for a30
select owner,table_name,index_name, status,TABLESPACE_NAME
from dba_indexes 
where table_name ='ACTB_HISTORY'
order by 2 desc;


----------------------------------------------------------------------------------------------------

--CHECK INDEX PARTITION
select INDEX_OWNER, INDEX_NAME, count(PARTITION_NAME)
from dba_ind_partitions 
where INDEX_NAME in ('MDS_CDR_ROAMWARE_MAP')
group by INDEX_OWNER, INDEX_NAME, PARTITION_NAME;

----------------------------------------------------------------------------------------------------


--Check INDEX COLUMN
set lines 200
col table_owner for a30
col table_name for a30
col index_name for a30
col column_name for a30
select table_owner, table_name, index_name, column_name
from dba_ind_columns 
where TABLE_NAME ='ACTB_HISTORY';

----------------------------------------------------------------------------------------------------

--Check SIZE INDEX
select owner,index_type,index_name,bytes/1024/1024 "MB" 
from dba_indexes 
where table_name='IDX_RS_CT';
group by owner,index_type,index_name; --kalu tak bisa, Check nya pake top object ajaa wkwkwk


--------------------------------------------------------------------------------------------------------------------------------------------

--Check REBUILD LAST ANALYSED
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY HH24:MI:SS';
set lines 999
col owner for a30
col index_name for a30
select OWNER, INDEX_NAME, LAST_ANALYZED, DEGREE, LOGGING, STATUS 
from dba_indexes
where INDEX_NAME ='INDEX_NAME';


--------------------------------------------------------------------------------------------------------------------------------------------

--LAST ANALYSED AND TOTAL EXEC
select i.owner,i.table_name,i.index_name,TOTAL_ACCESS_COUNT,TOTAL_EXEC_COUNT,LAST_USED 
from dba_indexes i, dba_index_usage u 
where i.index_name = u.name 
and table_name='DELIVERY_ORDER_DETAIL' 
order by 4,5 DESC;

