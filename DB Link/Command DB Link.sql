--test dblinke:
select * from dual@dblink_name;

--PRE-CHECK
Pastikan telnet dan tnsping sudah aman
Megubah Database link tidak bisa, harus drop dan create ulang.


--Check DB LINK
set lines 999
set pages 999
col db_link for a30
col username for a30
col host for a30
col created for a20
col service for a90
select owner, db_link, username, host, created 
from dba_db_links;

------------------------------------------------------------------------------------------------------------------------------------------

--CREATE DB_LINK

create database link nama_database_link
connect to nama_user_db_target
identified by password_user_db_target
using 'tns_names_db_target';


--PUBLIC DB_LINK:
create public database link GET_T_TSREP_PUB 
connect to T_TSREP_USER 
identified by T_TSREP_PASS 
using 'T_TSREP';

create public database link PUB_OPPEPRG 
connect to SYSTEM 
identified by OR4cl35y5#2015 
using 'OPPEPRG';


Note!
Pass nya minta dari team apps

------------------------------------------------------------------------------------------------------------------------------------------

3. Test DB_LINK
select * from schema.table@db_link_name; 

select sysdate from dual@DB_LINK_NAME;
select count (*) from all_tables@DB_LINK_NAME;


select count(column) from owner.table@db_link_name;
select count(bill_cycle) from tcsimapp.customer@crmbe_auxt;

------------------------------------------------------------------------------------------------

select sys_context ('USERENV','CURRENT_SCHEMA') from dual;

alter session set CURRENT_SCHEMA='usern_source'
select sys_context ('USERENV','CURRENT_SCHEMA') from dual;

select /*PARALLEL (10) */ count(*) from owner.table@db_link_name;

------------------------------------------------------------------------------------------------

#TES DB LINK
SQL> select count(*) from CIS_TEMPORARY.TEMP_REMAP@CIS_REPORT;
--kalau select ke db link dan masih error bisa Check parameter global 

SQL> show parameter global;
--kalau masih true, dan di suruh ubah ke false

SQL> alter system set global_names=false sid='*' scope=both;


------------------------------------------------------------------------------------------------------------------------------------------

4. Grant
grant create database link to USER;
grant create public database link to USER;
grant drop public database link to USER;
grant drop database link to USER;

------------------------------------------------------------------------------------------------------------------------------------------

5. Drop DB_LINK
drop database link DB_LINK_NAME;
drop public database link DB_LINK_NAME;