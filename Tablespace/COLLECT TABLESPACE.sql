1. Collect TBS all DB under 2019 untuk offline

set pages 10000
select 'ALTER TABLESPACE '||TABLESPACE_NAME||' OFFLINE;'
from dba_data_files where TABLESPACE_NAME like '%201%' and TABLESPACE_NAME not like '%2019%'
AND TABLESPACE_NAME NOT IN('SYS','USERS','SYSTEM','SYSAUX','UNDOTBS1','UNDOTBS2') ;

contoh hasil:
ALTER TABLESPACE CLS_IN_OUT_RS_M_201404_C OFFLINE;
ALTER TABLESPACE CLS_IN_OUT_RS_M_201404_A OFFLINE;


------------------------------------------------------------------------------------------------------------------------


2. Collect tbs untuk create ulang

set linesize 200
set pagesize 200                                                                
SELECT 'CREATE TABLESPACE '||TABLESPACE_NAME||' DATAFILE ''+DATAC4'' size 100M autoextend on next 512M maxsize 5MB;' 
from dba_segments where OWNER in ('DMS','DIAMOND','WEBDEALER') group by tablespace_name;SQL> SQL>   2  

Contoh hasil:
CREATE TABLESPACE CLS_IN_OUT_RS_M_201404_C DATAFILE '+DATAC4' size 100M autoextend on next 512M maxsize 5MB;
CREATE TABLESPACE CLS_IN_OUT_RS_M_201405_A DATAFILE '+DATAC4' size 100M autoextend on next 512M maxsize 5MB;


------------------------------------------------------------------------------------------------------------------------


3. Check DAN GET SCRIPT UNTUK CRETE TBS

set linesize 200
set pagesize 200                                                                
SELECT 'CREATE TABLESPACE '||TABLESPACE_NAME||' DATAFILE ''+DATAC4'' size 1M autoextend on next 1M maxsize 5M;' 
from dba_segments where OWNER in ('DMS','DIAMOND','WEBDEALER') group by tablespace_name;

Contoh hasil:
CREATE TABLESPACE CLS_IN_OUT_RS_M_201404_C DATAFILE '+DATAC4' size 1M autoextend on next 1M maxsize 5M;
CREATE TABLESPACE CLS_IN_OUT_RS_M_201405_A DATAFILE '+DATAC4' size 1M autoextend on next 1M maxsize 5M;
CREATE TABLESPACE CLS_IN_OUT_RS_M_201405_B DATAFILE '+DATAC4' size 1M autoextend on next 1M maxsize 5M;
