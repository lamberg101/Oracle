1. Resizing	
ALTER DATABASE DATAFILE '+DATAIMC/OPCRMSBIMC/DATAFILE/UNDOTBS2.14215.980114857' RESIZE 3G;
ALTER DATABASE DATAFILE '+DATAIMC/OPCRMSBIMC/DATAFILE/UNDOTBS2.14215.980114857' AUTOEXTEND ON  NEXT 4096M MAXSIZE 1024000M;

------------------------------------------------------------------------------------------------------------

2. Offlining	
ALTER DATABASE DATAFILE 'C:\ORACLE\TEST.DBF' OFFLINE; --you must offline the tablespace first

------------------------------------------------------------------------------------------------------------

3. Onlining	
ALTER DATABASE DATAFILE '+DATAIMC/opapmimc/datafile/apmuim.554.957659001' ONLINE;

------------------------------------------------------------------------------------------------------------

4. RENAME DATAFILE 
SQL> ALTER DATABASE DATAFILE '/u01/app/oracle/product/11.2.0.4/dbhome_1/dbs/DATAC1' OFFLINE;
RMAN> copy datafile '/u01/app/oracle/product/11.2.0.4/dbhome_1/dbs/DATAC1' to '+DATAC1/opcmc62/datafile/trackingstream_082019_NEW';
SQL> alter database rename file '/u01/app/oracle/product/11.2.0.4/dbhome_1/dbs/DATAC1' to '+DATAC1/opcmc62/datafile/trackingstream_082019_NEW';
RMAN> SWITCH DATAFILE '+DATAC1/opcmc62/datafile/trackingstream_082019_NEW' to copy;
RMAN> recover datafile '+DATAC1/opcmc62/datafile/trackingstream_082019_NEW';
SQL> alter database datafile '+DATAC1/opcmc62/datafile/trackingstream_082019_NEW' online;

------------------------------------------------------------------------------------------------------------

5. Autoexend ON/OFF
ALTER DATABASE DATAFILE 'c:\oracle\test.dbf' AUTOEXTEND ON;
ALTER DATABASE DATAFILE 'c:\oracle\test.dbf' AUTOEXTEND OFF;


------------------------------------------------------------------------------------------------------------

