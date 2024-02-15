--Check user
set lines 999
col username for a30
col account_status for a30
col lock_date for a30
col expiry_date  for a30
col default_tablespace  for a30
col temporary_tablespace  for a30
col created for a30
col profile for a30
col external_name  for a30
col last_login  for a50
select username, account_status, 
profile,
default_tablespace,temporary_tablespace,
--lock_date,
--expiry_date,
--external_name,
created
--last_login
from dba_users
where username like '%DBSNMP%'
order by account_status, username;





select dbms_metadata.get_ddl('USER','HRNSRC')  from dual;

-----------------------------------------------------------------------------------------------------------------

--Check SIZE
select owner,sum(bytes/1024/1024/1024) "segment in GB" 
from dba_segments 
where owner in ('TSEL_VERONAVC','TSEL_VERONAUM','TSEL_VERONANT') 
group by owner;


-----------------------------------------------------------------------------------------------------------------

--Check LOGON TIME
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY HH24:MI:SS';
select  max(timestamp), a.username 
from dba_audit_trail a 
where action_name = 'LOGON' 
and username='POMAPP_MASS'
group by username 
order by 1 desc;

-----------------------------------------------------------------------------------------------------------------

--Check PASSWORD CHANGE TIME
alter session set nls_date_format = 'DD-MM-YYYY HH24:MI:SS';
select name, ctime "USER CREATED", ptime "PASSWORD CHANGE TIME"
from sys.user$
where name='username';



=================================================================================================================

--CREATE USER
CREATE USER username IDENTIFIED BY username#2021
DEFAULT TABLESPACE DATA
TEMPORARY TABLESPACE TEMP
PROFILE LEVEL2;
GRANT CONNECT, RESOURCE to username;



CREATE USER username IDENTIFIED BY username#2021;
ALTER USER HRNSRC DEFAULT TABLESPACE HRNDATA_DATA;
ALTER USER username TEMPORARY TABLESPACE TEMP;
ALTER USER SYSTEM PROFILE LEVEL2;
GRANT CONNECT, RESOURCE to username;

ALTER USER SYSTEM PROFILE LEVEL2;
ALTER USER PESAGG PROFILE LEVEL2;


---SAMAKAN DENGAN USER YG ADA
BUKA TOAD >CARI USER >KLIK KANAN >CLONE >MASUKA PASSSWORD >DONE

-----------------------------------------------------------------------------------------------------------------

--CHANGE USER PASSWORD
ALTER USER SYSTEM IDENTIFIED BY OR4cl35y5#2015;
ALTER USER DBSNMP IDENTIFIED BY DbsnmpTsel#2016 ACCOUNT UNLOCK;
ALTER USER BACKUP_ADMIN IDENTIFIED BY Welcome123;

ALTER USER PRE2_IRISAPP IDENTIFIED BY Ir1sApp#2021 ACCOUNT UNLOCK;

ALTER USER ADMIN IDENTIFIED BY admin#2022 ACCOUNT UNLOCK profile LEVEL2;




1. MASUK ke db OPCAMUNDA

2. Check STATUS USERNYA
SQL> 
select username, account_status, profile,created, expiry_date
from dba_users where username in ('SYSTEM')
order by account_status, username;

3. ALTER PROFILE NYA
SQL> ALTER USER SYSTEM PROFILE LEVEL2;

4. ALTER PASSWORDNYA
SQL> ALTER USER SYSTEM IDENTIFIED BY OR4cl35y5#2015;

5. Check LAGI PAKE QUERY NO 2

--USER IN DB CONTAINER
sqlplus / as sysdba
ALTER SESSION SET CONTAINER=CONTAINER_DB;
connect / as sysdba
ALTER USER SYSTEM IDENTIFIED BY oracle;

ALTER USER SYSTEM IDENTIFIED BY oracle container=all;

Alter user sys
SQL> connect / as sysdba
SQL> alter user system identified by oracle;

-----------------------------------------------------------------------------------------------------------------

--BY VALUES (USE OLD PASS)
select name, password 
from sys.user$ 
where NAME='SYS';

ALTER USER AGIT_JUNAEDI IDENTIFIED by values '901821C85D30DFC6';

-----------------------------------------------------------------------------------------------------------------

--UNLOCK/LOCK USER

ALTER USER ARIS_SUPARDIMAN_X ACCOUNT UNLOCK;
ALTER USER OMS ACCOUNT LOCK;

-----------------------------------------------------------------------------------------------------------------

--DROP USER
DROP USER USERNAME CASCADE;

-----------------------------------------------------------------------------------------------------------------

--GRANT QUOTA UNLIMITED
ALTER USER USERNAMENYA QUOTA UNLIMITED ON TRXID_DATA;


