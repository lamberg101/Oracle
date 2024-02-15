1. from dbms_metadata

--TABLE
set heading off;
set echo off;
Set pages 999;
set long 90000;
select dbms_metadata.get_ddl('TABLE','CREDIT_SCORING','LOENA') from dual;


--Check DDL ALL TALE DARI USER 
set pages 0
set lines 200
select 'select dbms_metadata.get_ddl("TABLE","'||TABLE_NAME||'","PGATEENH")from dual;' from dba_tables where owner='PGATEENH';

--pgateenh di export ddl tablenya ke satu file .sql --semua struktur table schema pgateenh


--INDEX
set heading off;
set echo off;
Set pages 999;
set long 90000;
select dbms_metadata.get_ddl('INDEX','E0045','SA') from dual;

-------------------------------------------------------------------------------------------------------------------------------------------------

--DBA_TAB_MODIFICATIONS

select TABLE_OWNER,TABLE_NAME,INSERTS,UPDATES,DELETES,TRUNCATED,TIMESTAMP 
from dba_tab_modifications 
where TABLE_OWNER='OTPGATE3';

-------------------------------------------------------------------------------------------------------------------------------------------------

--LAST DDL
set linesize 200
set pagesize 30
col owner for a10
col object_name for a40
select owner, object_name, object_type, created, to_char(last_ddl_time,'YYYY-MM-DD HH24:mi:ss')
from dba_objects 
where owner='DOM' 
order by 5;


-------------------------------------------------------------------------------------------------------------------------------------------------
LEWAT OEM
>schema 
>users 
>cari shcema nya/masukan di object name 
>klik username nya 
>pilih generate ddl di action 
>go

