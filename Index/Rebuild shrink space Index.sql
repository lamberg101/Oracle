

--Check LIST INDEX PARTITION
select INDEX_OWNER, partition_name, partition_position, status 
from dba_ind_partitions 
where index_name='USER_MSG_LOCAL_IDX';


--SCRIPT COLLECT
SELECT 'ALTER INDEX '||OWNER||'.'||index_name||' REBUILD PARTITION ONLINE;' 
FROM DBA_INDEXES 
WHERE TABLE_NAME='TCNPM608T';


--------------------------------------------------------------------------------------------------------------------

Note!
--abis rebuild, jika menggunakan paralal/no logging, maka di set ke paralel dan no logging lagi

SQL> ALTER INDEX schema.index_name REBUILD ONLINE PARALLEL 4 NOLOGGING;
SQL> ALTER INDEX schema.index_name NOPARALLEL LOGGING;


--------------------------------------------------------------------------------------------------------------------------------------------

--PARTITION ONLINE

--WITHOUT PARALLEL
ALTER INDEX schema.index_name REBUILD PARTITION ONLINE; --tanpa parallel

--WITH PARALLEL
ALTER INDEX schema.index_name PARTITION partition_name REBUILD ONLINE PARALLEL 4;
ALTER INDEX schema.index_name PARTITION partition_name NOPARALLEL;

--
ALTER INDEX schema.index_name REBUILD PARTITION partition_name ONLINE PARALLEL 4;
ALTER INDEX schema.index_name REBUILD PARTITION partition_name NOPARALLEL;

--
ALTER INDEX schema.index_name REBUILD ONLINE TABLESPACE tbs_name;

--
ALTER INDEX schema.index_name REBUILD  ONLINE PARALLEL 8 TABLESPACE tbs_name;


--------------------------------------------------------------------------------------------------------------------------------------------

--ALTER TRXID PARTITION TABLE AND INDEX

ALTER TABLE schema.table_name MOVE PARTITION P_NODE1 INITRANS 10 STORAGE (FREELISTS 16 FREELIST GROUPS 2);
ALTER INDEX schema.index_name REBUILD PARTITION P_NODE1 INITRANS 10 STORAGE (FREELIST GROUPS 2 FREELISTS 16);
ALTER INDEX schema.index_name REBUILD INITRANS 10 STORAGE (FREELIST GROUPS 2 FREELISTS 16);


--------------------------------------------------------------------------------------------------------------------------------------------

--MOVE TABLE PARTITION AND REBUILD INDEX

ALTER TABLE schema.table_name MOVE PARTITION partition_name TABLESPACE tbs_name PARALLEL(DEGREE 4);
ALTER INDEX schema.index_name REBUILD PARTITION partition_name TABLESPACE tbs_name NOLOGGING PARALLEL(DEGREE 4);


ALTER INDEX schema.index_name REBUILD ONLINE PARALLEL 8 NOLOGGING;
ALTER INDEX schema.index_name NOPARALLEL;
ALTER INDEX schema.index_name LOGGING;


ALTER INDEX schema.index_name REBUILD ONLINE PARALLEL 4;	
ALTER INDEX schema.index_name NOPARALLEL;
