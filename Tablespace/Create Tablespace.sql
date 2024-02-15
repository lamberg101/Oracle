

--CREATE
CREATE TABLESPACE TS_NAME DATAFILE '+DATAIMC' SIZE 100M AUTOEXTEND ON NEXT 512M MAXSIZE 30G;

--ALTER QUOTA
ALTER USER SCHEMA_NAME QUOTA UNLIMITED ON TS_NAME;


------------------------------------------------------------------------------------------------------------

--UNDO TABLESPACE
CREATE UNDO TABLESPACE TS_UNDO DATAFILE '/dbf/undo.dbf' SIZE 100M;

------------------------------------------------------------------------------------------------------------

--PERMANENT TABLESPACE
create tablespace TS_NAME logging datafile '/dbf1/ts_sth.dbf' size 32m autoextend on next 32m maxsize 2048m extent management local;
create tablespace TS_NAME datafile '/home/oracle/databases/ora10/data.dbf' size 10M autoextend on maxsize 200M extent management local uniform size  64K;


------------------------------------------------------------------------------------------------------------

--TEMPORARY TABLESPACE
CREATE TEMPORARY TABLESPACE TEMP_TS_NAME TEMPFILE '/dbf1/mtr_temp01.dbf' SIZE 32M AUTOEXTEND ON NEXT 32M MAXSIZE 2048M EXTENT MANAGEMENT LOCAL;	
--NOTE! a temporary tablespace has tempfiles, not datafiles.

------------------------------------------------------------------------------------------------------------

--NOTE! More than one datafile can be created with a single create tablespace command:
CREATE TABLESPACE TS_STH 
datafile 'c:\xx\sth_01.dbf' size 4M autoextend off,
		'c:\xx\sth_02.dbf' size 4M autoextend off,
		'c:\xx\sth_03.dbf' size 4M autoextend off
		logging
		extent management local;
	
