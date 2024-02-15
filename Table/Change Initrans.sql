Check Initrans:
------------
select table_name,ini_trans from dba_tables where table_name='CUSTOMER_KPI_RL';

create tbs new with manual management:
--------------------------------------
CREATE TABLESPACE TBS_SCV_LOAD_USR_NEW DATAFILE 
'+DATAC4' SIZE 100M AUTOEXTEND ON NEXT 1024M MAXSIZE 30720M
LOGGING
PERMANENT
EXTENT MANAGEMENT LOCAL AUTOALLOCATE
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT MANUAL
FLASHBACK ON;



move table :
------------
ALTER TABLE SCV_LOAD_USR.CUSTOMER_KPI_RL MOVE TABLESPACE TBS_SCV_LOAD_USR_NEW;
--move table
ALTER TABLE OWNER.TABLE_NAME MOVE TABLESAPCE NEW_TBS; --immediate will be moved


rebuild index:
---------------
ALTER INDEX SCV_LOAD_USR.CUSTOMER_KPI_RL_UNI_CLUST_IDX REBUILD;



change initrans:
----------------
ALTER TABLE SCV_LOAD_USR.CUSTOMER_KPI_RL INITRANS 10;



change initrans index:
----------------------
ALTER INDEX SCV_LOAD_USR.CUSTOMER_KPI_RL_UNI_CLUST_IDX INITRANS 10;