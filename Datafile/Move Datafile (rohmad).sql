**NO ARCHIVELOG** 

1. Shutdown 
SQL> SHUTDOWN IMMEDIATE;

2. Pindahkan/move/rename datafile. 
$ mv /oradata/oracle/ts/users01.dbf /oradata/oracle/ts/users02.dbf

3. Startup mount database
SQL> STARTUP MOUNT;

4. Rename datafile di level database
SQL> ALTER DATABASE RENAME FILE '/oradata/oracle/ts/users01.dbf' TO '/oradata/oracle/ts/users02.dbf';

5. Open database
SQL> ALTER DATABASE OPEN;
	
	
------------------------------------------------------------------------------------------------------------------------------------------------
	
***ARCHIVELOG MODE***

1. Tidak perlu shutdown database --cukup offline-kan datafile.
SQL> ALTER DATABASE DATAFILE '/oradata/oracle/ts/users01.dbf' OFFLINE; --ofilnekan tablespace dulu

2. move/rename datafile. 
$ mv /oradata/oracle/ts/users01.dbf /oradata/oracle/ts/users02.dbf

3. Rename datafile di level database
SQL> ALTER DATABASE RENAME FILE '/oradata/oracle/ts/users01.dbf' TO '/oradata/oracle/ts/users02.dbf';

4. Recover datafile.
RMAN> RECOVER DATAFILE '/oradata/oracle/ts/users02.dbf';

5. Online-kan datafile.
SQL> ALTER DATABASE DATAFILE '/oradata/oracle/ts/users01.dbf' ONLINE;