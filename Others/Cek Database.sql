--VERSION
col product format a35
col version format a15
col status format a15 
select * from product_component_version;

--NAME
select name from v$database;

--STARTUP_TIME
select instance_name, to_char(startup_time,'mm/dd/yyyy hh24:mi:ss') as startup_time  from v$instance;

--CREATED
select created from v$database;

--INSTANCE_NAME
select instance_name,status from v$instance;

--ROLE
select inst_id,name, open_mode, database_role from gv$database;

--UNIQUE_NAME
select distinct host_name, name, db_unique_name, instance_name from gv$instance, gv$database; 


-------------------------------------------------------------------------------------------------------------------

1. Check SIZE DATABASE
	
Segment: ukurannya/current
select sum (bytes/1024/1024/1024) GB from dba_segments;
	
Datafile: Max sizenya
select sum (bytes/1024/1024/1024) GB from dba_data_files;


2. Check SIZE (Akumulasi)

select (
select round(sum(bytes)/1024/1024/1024,2) data_size 
from DBA_DATA_FILES ) + ( select round(nvl(sum(bytes),0)/1024/1024/1024,2) temp_size 
from DBA_TEMP_FILES ) + ( select round(sum(bytes)/1024/1024/1024,2) redo_size 
from SYS.V_$LOG ) + ( select round(sum(BLOCK_SIZE*FILE_SIZE_BLKS)/1024/1024/1024,2) controlfile_size 
from V$CONTROLFILE ) "Size in GB" from dual;


3. purge dba_recyclebin;
select sum (bytes/(1024*1024)) " db segemen size in mb" from dba_segments;
	


