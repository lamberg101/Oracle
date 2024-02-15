1. enable flashback:
--------------------
SQL> select name,open_mode,log_mode,flashback_on from v$database;

SQL> alter database flashback on;

SQL> create restore point before_upgrade guarantee flashback database;

SQL> select GUARANTEE_FLASHBACK_DATABASE,NAME ,TIME from v$restore_point;

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
create pfile='/home/oracle/pfile_odtest11.txt' from spfile;

5. makesure parameter sec_case_sensitive_logon = true 
------------------------------------------------------
SQL> show parameter sec_case_sensitive_logon;

6. preupgrade:
--------------
/u01/app/oracle/product/19.0.0.0/dbhome_1/jdk/bin/java -jar /u01/app/oracle/product/19.0.0.0/dbhome_1/rdbms/admin/preupgrade.jar TERMINAL TEXT

7. upgrade using dbua:
----------------------
$ . .ODTEST19
$ dbua



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
$ srvctl config database -d ODTEST
$ srvctl status database -d ODTEST
$ srvctl remove database -d ODTEST

$ srvctl add database -d ODTEST -o /u01/app/oracle/product/11.2.0/dbhome_1
$ srvctl add instance -d ODTEST -i ODTEST1 -n exaimcpdb01-mgt
$ srvctl add instance -d ODTEST -i ODTEST2 -n exaimcpdb02-mgt
$ srvctl modify database -d ODTEST -r PRIMARY
$ srvctl modify database -d ODTEST -p '+DATAIMC/ODTEST/spfileODTEST.ora'