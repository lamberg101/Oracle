Collect STANDBY_BECAME_PRIMARY_SCN

SQL> select to_char(standby_became_primary_scn) from v$database;

TO_CHAR(STANDBY_BECAME_PRIMARY_SCN)
----------------------------------------
15290580959131
SQL> !date
Mon Mar  8 23:17:43 WIB 2021

----------------------------------------------------------------------

--ENABLE FLASHBACK
standby
select name,open_mode,log_mode,flashback_on from v$database;
alter database flashback on;
create restore point upgrade_poin19 guarantee flashback database;

primary
select name,open_mode,log_mode,flashback_on from v$database;
alter database flashback on; 
alter system set log_archive_dest_state_3=DEFER scope=memory sid='*';

standby
alter database recover managed standby database cancel;
SQL> alter database activate standby database;
#> srvctl stop database -d OPPOIN19
#> srvctl config database -d OPPOIN19
#> srvctl modify database -d OPPOIN19 -r primary
#> srvctl start database -d OPPOIN19

SQL> select name, open_mode, database_role from v$database;

accticate standby database.
alter database activate standby database;


--in standby (new primary) 
--DROP INVALID OBJECT AND PURGE RECYCLE BIN

2. check invalid object
-----------------------
SQL> 
set pagesize 100
set linesize 200
col object_name for a50
select object_name, object_type, owner from dba_objects where status<>'VALID';

if want recompile:
-------------------
EXEC DBMS_UTILITY.compile_schema(schema => 'OMS', compile_all => false);
EXEC DBMS_UTILITY.compile_schema(schema => 'RAFA', compile_all => false);
EXEC DBMS_UTILITY.compile_schema(schema => 'FORTUNE', compile_all => false);
EXEC DBMS_UTILITY.compile_schema(schema => 'OMSDEV', compile_all => false);
EXEC DBMS_UTILITY.compile_schema(schema => 'USODEV', compile_all => false);


if want drop:
SQL> 
set linesize 200
set heading off
select 'drop ' || object_type || ' "' || owner || '"."' || object_name || '";'
from dba_objects
where status='INVALID';

3. recyclebin must be null
--------------------------
SQL> purge dba_recyclebin;

4. backup pfile:
----------------
create pfile='/home/oracle/ssi/slam/OPTOIP/pfile_backup_optoip_24022021.txt' from spfile;

5. makesure parameter sec_case_sensitive_logon = true 
------------------------------------------------------
SQL> show parameter sec_case_sensitive_logon;


--drop
DROP USER HENDRICK_LAMBOK CASCADE;
DROP USER TSELPOIN CASCADE;
DROP USER CLP CASCADE;

--purge
PURGE DBA_RECYCLEBIN;



6. preupgrade:
--------------
/u01/app/oracle/product/19.0.0.0/dbhome_1/jdk/bin/java -jar /u01/app/oracle/product/19.0.0.0/dbhome_1/rdbms/admin/preupgrade.jar TERMINAL TEXT

7. upgrade using dbua:
----------------------
$ . .OPTOIP19
export ORACLE_SID=OPTOIP191
export ORACLE_HOME=/u01/app/oracle/product/19.0.0.0/dbhome_1
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/jdk/jre/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib

$ dbua


DBUA

Check log di:
tail -500f /u01/app/oracle/cfgtoollogs/dbua/upgrade2021-03-09_12-11-56AM/OPPOIN19/Oracle_Server.log


after dbua


1. 
SQL> select name, open_mode, database_role from gv$database;

NAME       OPEN_MODE         DATABASE_ROLE
--------- -------------------- ----------------
OPHPOINT   READ WRITE         PRIMARY
OPHPOINT   READ WRITE         PRIMARY



2. in standby
TO_CHAR(STANDBY_BECAME_PRIMARY_SCN)
----------------------------------------
SCN 15290580959131

srvctl status database -d OPPOIN19
srvctl stop database -d OPPOIN19
SQL> startup mount;
SQL> flashback Database To (scn in primary point 1);
SQL> Alter Database Convert To Physical Standby;
SQL> shutdown immediate;
#> srvctl config database -d OPPOIN19
#> srvctl modify database -d OPPOIN19 -r physical_standby
#> srvctl start database -d OPPOIN19 -o mount
SQL> alter database recover managed standby database using current logfile disconnect from session;





------------------------------------------------------------------------------------------------------------------------------------

tailf /u01/app/oracle/cfgtoollogs/dbua/upgrade2021-03-09_04-11-14AM/OPPOIN19/Oracle_Server.log


jalanin after DBUA OPPOIN19 09/maret/2021

in standby
----------
profile v19:
-------------
$ srvctl status database -d OPPOIN19
$ srvctl stop database -d OPPOIN19


profile v11 :
------------
. .OPPOINNEW19_profile
SQL> startup mount pfile='/home/oracle/pfilepoin11.txt';
SQL> flashback database to restore point UPGRADE_POIN19;
SQL> create spfile='+DATAIMC/oppoin19/parameterfile/spfileoppoin19.ora' from pfile='/home/oracle/pfilepoin11.txt';
SQL> Alter Database Convert To Physical Standby;


profile v19:
------------
$ srvctl remove database -d OPPOIN19 


profile v11:
-------------
. .OPPOINNEW19_profile
SQL> shutdown immediate;
$ srvctl add database -d OPPOIN19 -o /u01/app/oracle/product/11.2.0/dbhome_1
$ srvctl add instance -d OPPOIN19 -i OPPOIN191 -n exaimcpdb01-mgt
$ srvctl add instance -d OPPOIN19 -i OPPOIN192 -n exaimcpdb02-mgt
$ srvctl modify database -d OPPOIN19 -r physical_standby
$ srvctl modify database -d OPPOIN19 -p '+DATAIMC/oppoin19/parameterfile/spfileoppoin19.ora'
$ srvctl start database -d OPPOIN19 -o mount
SQL> alter database recover managed standby database using current logfile disconnect from session;


primary
--------
alter system set log_archive_dest_state_3=ENABLE scope=both sid='*';


standby:
---------
SQL> select GUARANTEE_FLASHBACK_DATABASE,NAME ,TIME from v$restore_point;
SQL> drop restore point upgrade_poin19;





------------------------------------------------------------------------------------------------------------------------------------

col username for a30
col account_status for a30
col default_tablespace  for a30
col temporary_tablespace  for a30
col created for a30
col profile for a30
SELECT Username,Account_Status,Default_Tablespace,Profile,Temporary_Tablespace FROM DBA_USERS
where username in ('HENDRICK_LAMBOK','TSELPOIN','CLP')
order by account_status, username;


------------------------------------------------------------------------------------------------------------------------------------

8. rollback to v11 using flashback:
--------------------------------
$> su – oracle.
$> sqlplus / as sysdba;
SQL> select current_scn from v$database;
SQL> shutdown immediate;
SQL> startup mount;
SQL> select * from v$restore_point;
SQL> flashback database to restore point before_upgrade;
SQL> alter database open resetlogs;

remove and readd service cluster:
--------------------------------
$ srvctl config database -d OPTOIPIMC
$ srvctl status database -d OPTOIPIMC
$ srvctl remove database -d OPTOIPIMC

$ srvctl add database -d OPTOIPIMC -o /u01/app/oracle/product/11.2.0/dbhome_1
$ srvctl add instance -d OPTOIPIMC -i OPTOIPIMC1 -n exaimcpdb01-mgt
$ srvctl add instance -d OPTOIPIMC -i OPTOIPIMC -n exaimcpdb02-mgt
$ srvctl modify database -d OPTOIPIMC -r PRIMARY
$ srvctl modify database -d OPTOIPIMC -p '+DATAIMC/optoipimc/parameterfile/spfileoptoipimc.ora'
