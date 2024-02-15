--Check ROLE
SELECT INST_ID,NAME, OPEN_MODE, DATABASE_ROLE FROM GV$DATABASE;


----------------------------------------------------------------------------------------------------------------------------------

--Check UPTIME 
SELECT INSTANCE_NAME,STATUS,DATABASE_STATUS,
to_char(startup_time,'mm/dd/yyyy hh24:mi:ss') as STARTUP_TIME 
FROM GV$INSTANCE;


----------------------------------------------------------------------------------------------------------------------------------

--Check STATUS 
SELECT INSTANCE_NAME,STATUS FROM V$INSTANCE;


----------------------------------------------------------------------------------------------------------------------------------

--Check VERSION
col product format a35
col version format a15
col status format a15 
SELECT * FROM PRODUCT_COMPONENT_VERSION;

----------------------------------------------------------------------------------------------------------------------------------

--DATAFILE
select sum (bytes/1024/1024/1024) "Datafile (GB)" from dba_data_files;


--SEGMENT
select sum (bytes/1024/1024/1024) "Segments (GB)" from dba_segments;



--ALL --(datafile + temp_file + v$log + v$controlfile)
select ( select ROUND(sum(bytes)/1024/1024/1024,2) data_size 
from dba_data_files ) + ( 
select ROUND(nvl(sum(bytes),0)/1024/1024/1024,2) temp_size from dba_temp_files ) + ( 
select ROUND(sum(bytes)/1024/1024/1024,2) redo_size from sys.v_$log ) + ( 
select ROUND(sum(BLOCK_SIZE*FILE_SIZE_BLKS)/1024/1024/1024,2) controlfile_size 
from v$controlfile) "Size in GB" from dual;