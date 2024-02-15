RENAME/MOVE DATAFILE from MOUNTPOINT TO ASM

1. Check datafile id dan nama file:
col file_name format a70
select file_id, file_name, online_status 
from dba_data_files 
where file_name like '%/u01%';

--------------------------------------------------------------------------------------------------------------------------------

2. Offline datafile:
SQL> ALTER DATABASE DATAFILE '/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/DATAIMC' OFFLINE; 

--jika tidak bisa, pakai id
SQL>ALTER DATABASE DATAFILE 250 OFFLINE;

--------------------------------------------------------------------------------------------------------------------------------


3. crosscheck.
select file_id, file_name, online_status 
from dba_data_files 
where file_name like '%/u01%'; 

--------------------------------------------------------------------------------------------------------------------------------

4. Copy datafile by RMAN

RMAN> COPY DATAFILE '/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/DATAIMC' to '+DATAIMC';

--------------------------------------------------------------------------------------------------------------------------------

5. Check output new file hasil copy rman --hasil step no 4.
SQL> ALTER DATABASE RENAME FILE '/u01/app/oracle/product/11.2.0.3/dbhome_1/dbs/ +DATA_TESTET' to 'file name hasil copy rman';
SQL> ALTER DATABASE RENAME FILE '/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/DATAIMC' to '+DATAIMC/OPTOIPIMC/DATAFILE/users.2915.1095723563';

RMAN> RECOVER DATAFILE  'file name hasil copy rman'; ???
RMAN> RECOVER DATAFILE  '+DATAIMC/OPTOIPIMC/DATAFILE/users.2915.1095723563'; 

SQL> ALTER DATABASE DATAFILE 'file name hasil copy rman' online;
SQL> ALTER DATABASE DATAFILE '+DATAIMC/OPTOIPIMC/DATAFILE/users.2915.1095723563' online;

--------------------------------------------------------------------------------------------------------------------------------

6. Crosscheck:

--hasilnya harusnya no row
select file_id, file_name, online_status 
from dba_data_files 
where file_name like '%/u01%';

--hasilnya harusnya sudah ke diskgroup +DATA_TESTET
select file_id, file_name, online_status 
from dba_data_files 
where file_id='250'; 
