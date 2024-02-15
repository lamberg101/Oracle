Note!
Untuk undo jangan off, di autoextend (On).


1. UNDO Tablesapce

--CREATE UNDO 
SQL> CREATE UNDO TABLESPACE UNDOTBS1 DATAFILE '/oradata/oracle/ts_bak/undotbs01.dbf' size 10G;
SQL> CREATE UNDO TABLESPACE UNDOTBS1 DATAFILE '+DATAC4' size 1G autoextend on next 100M maxsize 30G;


--ADD UNDO 
SQL> ALTER TABLESPACE UNDOTBS2 ADD DATAFILE '+DATAIMC' size 1G autoextend on next 100M maxsize 30G
SQL> ALTER TABLESPACE UNDOTBS1 ADD DATAFILE '/oradata/oracle/ts_bak/undotbs01.dbf' size 1G autoextend on next 100M maxsize 30G;
SQL> ALTER TABLESPACE UNDOTBS1 ADD DATAFILE '/oradata/oracle/ts_bak/undotbs01.dbf' size 10G;


--RESIZE UNDO
SQL> ALTER DATABASE DATAFILE '/oradata/oracle/ts_bak/undotbs01.dbf' resize 200G; 


--SET DEFAULT UNDO
SQL> show parameter undo
SQL> ALTER SYSTEM SET UNDO_TABLESPACE=UNDOTBS2 SCOPE=BOTH; --jangan pake SID, karena tiap node beda


--DROP UNDO
SQL> DROP TABLESPACE UNDOTBS3 INCLUDING CONTENTS AND DATAFILES;

====================================================================================================================================


