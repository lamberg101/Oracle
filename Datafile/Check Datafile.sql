1. Check NAMA DATAFILE

select name from v$datafile;
select count(*) from v$datafile;

-----------------------------------------------------------------------------------------------------------------------------


2. Check TBS DATAFILE CREATE TIME

col file_name for a45
col tablespace_name for a10
col status for a15
col creation_time for a15
set lines 999 pages 100

select a.file_name, a.tablespace_name, a.status, b.creation_time 
from DBA_DATA_FILES a 
inner join V$DATAFILE b 
on a.file_name = b.name 
where b.file#=250
group by a.file_name, a.tablespace_name, a.status, b.creation_time;

where a.tablespace_name='&tablepace_name'

-----------------------------------------------------------------------------------------------------------------------------

select NAME from gv$datafile where file#=250;

3. Check FILE/PATH DATAFILE DARI TABLESPACE

column file_name format a50
select status, file_name, tablespace_name 
--from dba_temp_files 
from dba_data_files 
where file_name like '%protry_soainfra%';
where tablespace_name='&tablespace_name';

--where tablespace_name='&tablepace_name'



alter tablespace USERS autoextend on next 100M maxsize 800G;

select tablespace_name, file_name,autoextensible, bytes/1024/1024 MB from dba_data_files where tablespace_name='UNDOTBS1';

column FILE_NAME format a50
set linesize 100 pagesize 50
	
SELECT STATUS,FILE_NAME, TABLESPACE_NAME FROM DBA_TEMP_FILES WHERE TABLESPACE_NAME in ('TEMP','TEMP1');

-----------------------------------------------------------------------------------------------------------------------------

--Check SIZE TEMP
select sum(bytes/1024/1024/1024) from dba_temp_files;

-----------------------------------------------------------------------------------------------------------------------------

5. CHECK SPACE TEMPAT DATAFILE DARI TABLESPACE: 

>>Kalo datafile dari tablepace disimpan di diskgroup ASM, check menggunakan query berikut:

select
name group_name
  , total_mb                                 total_mb
	  , (total_mb - free_mb)                     used_mb
	  , free_mb                                  free_mb  
	  , ROUND((1- (free_mb / total_mb))*100, 2)  pct_used
	FROM
		v$asm_diskgroup
	ORDER BY
		4
	/


-----------------------------------------------------------------------------------------------------------------------------

6. Check autoextensible datafile

select file_name, autoextensible from dba_data_files;

select a.file_id, b.file_name, b.autoextensible, b.bytes/1024/1024,sum(a.bytes)/1024/1024
from dba_extents a, dba_data_files b
where a.file_id = b.file_id
group by a.file_id, b.file_name, autoextensible, b.bytes/1024/1024;


-----------------------------------------------------------------------------------------------------------------------------

--Check ATTRIBUTE TABLESPACE 
select def_tablespace_name, count(1) from dba_part_indexes group by def_tablespace_name;
select def_tablespace_name, count(1) from dba_part_tables group by def_tablespace_name;

select def_tablespace_name, count(def_tablespace_name) from dba_part_indexes group by def_tablespace_name;
select def_tablespace_name, count(def_tablespace_name) from dba_part_tables group by def_tablespace_name;

----------------------------------------------------------------------------------------------------------------------------------

--Check DEFAULT TABLESPACE.
select * from dba_users where default_tablesapce='TABLESPACE_NAME';

----------------------------------------------------------------------------------------------------------------------------------

--Check CREATION TIME
col file_name for a45
col tablespace_name for a15
col creation_time for a15
select a.file_name, a.tablespace_name, b.creation_time from dba_data_files a, v$datafile b 
where a.file_name=b.name
and a.tablespace_name='TEMP';


----------------------------------------------------------------------------------------------------------------------------------

--Check AUTOEXTEND TABLESPACE
set lines 999
col file_name for a70
select tablespace_name, file_name, autoextensible, maxbytes
from dba_data_files 
where tablespace_name in ('PROBTTBS_IAS_OPSS','PROOL2_IAS_OPSS','PROBTTBS2_IAS_OPSS');


select tablespace_name, next_extent, max_extents
from dba_tablespaces 
where tablespace_name in ('PROBTTBS_IAS_OPSS','PROOL2_IAS_OPSS','PROBTTBS2_IAS_OPSS');

----------------------------------------------------------------------------------------------------------------------------------

--ALTER DEFAULT TABLESPACE
ALTER DATABASE DEFAULT TABLESPACE TBS_PERM_01;
ALTER DATABASE DEFAULT TEMPORARY TABLESPACE TBS_TEMP_01;

select property_value from database_properties where property_name = 'DEFAULT_PERMANENT_TABLESPACE';
select property_value from database_properties where property_name = 'DEFAULT_TEMP_TABLESPACE';


Note! Jika ini tidak di set, maka user baru yg di create akan menggunakan tb SYSTEM sebagai default tbs nya.
----------------------------------------------------------------------------------------------------------------------------------

--Check status count
SELECT STATUS, COUNT(*) FROM DBA_TABLESPACES GROUP BY STATUS;

----------------------------------------------------------------------------------------------------------------------------------

--Check temp files
select sum(bytes/1024/1024) MB from dba_temp_files;

----------------------------------------------------------------------------------------------------------------------------------


--Check FILE NAME AND CREATION_TIME
col file_name for a45
col tablespace_name for a10
col status for a15
col creation_time for a15
set lines 999 pages 100
select a.file_name, a.tablespace_name, a.status 
from dba_data_files a 
inner join v$datafile b on a.file_name=b.name 
where tablespace_name='TBS_NAME'
group by a.file_name, a.tablespace_name, a.status, b.creation_time;


--Check DATAFILE NAME
column file_name format a50
set linesize 100 pagesize 50
select status, file_name, tablespace_name 
from dba_data_files 
where tablespace_name='ARSYSTEM';



column file_name format a50
set linesize 100 pagesize 50
select tablespace_name,count(file_name) 
from dba_data_files 
where file_name like '+DATAC2%'
group by tablespace_name;


--COUNT DATAFILE
column file_name format a50
set linesize 100 pagesize 50
select count(1) from dba_data_files; 


--Check SIZE DATAFILE 
col file_name for a100
set linesize 200
select tablespace_name,file_name,bytes/1024/1024/1024 
from dba_data_files
where tablespace_name='DATA_TRACK_LOGIN';




