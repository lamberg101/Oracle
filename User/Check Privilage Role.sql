
--Check DDL ROLE VIA OEM
Home Db > Security > Roles > Search Role Nya > Select > Edit


---------------------------------------------------------------------------------------------------------------------------------------

--Check PRIVILEGE
select * from DBA_SYS_PRIVS 
where privilege='DBA';

---------------------------------------------------------------------------------------------------------------------------------------

--Check USER PREFILEGE
set linesize 200
set pagesize 9999
col username for a30
select distinct a.username||'|'||a.account_status||'|'||a.expiry_date||'|'||a.created||'|'||b.privilege 
from dba_users a, dba_tab_privs b 
where a.username = b.grantee 
and a.username = 'CMS_REPO3' 
order by a.username asc;

---------------------------------------------------------------------------------------------------------------------------------------


--Check ROLE DBA
select * from DBA_ROLE_PRIVS 
where granted_role='DBA';

---------------------------------------------------------------------------------------------------------------------------------------

select username, account_status, created, privilege, a.expiry_date 
from dba_users a inner join dba_sys_privs b 
on a.username = b.grantee  
where privilege like '%UNLIMITED TABLESPACE%' 
and account_status='OPEN' 
order by username asc;


---------------------------------------------------------------------------------------------------------------------------------------

set lines 200
set pages 9999
set colsep "|"
col grantee for a32
col privilege for a32
SELECT a.grantee,a.privilege,GRANTED_ROLE 
FROM DBA_SYS_PRIVS a, DBA_ROLE_PRIVS b 
WHERE a.grantee = b.grantee 
and a.grantee NOT IN ('SYSTEM','SYS','DBSNMP') 
order by a.grantee,GRANTED_ROLE,a.privilege;
