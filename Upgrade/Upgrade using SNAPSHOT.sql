Converting a Physical Standby Database into a Snapshot Standby Database

--Step 1 : login as sysdba

$ sqlplus / as sysdba

--Step 2 : Check the database mode --> must be flashback_on = YES

SQL> select log_mode,flashback_on from v$database;

LOG_MODE     FLASHBACK_ON
------------ ------------------
ARCHIVELOG   NO

if flashback_on = NO must be changed.

SQL > ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
SQL > ALTER DATABASE FLASHBACK ON;

---------------------------------------------------------------------------------------------------------------------------------------

--Step 2 : Check the database mode

SQL> Select DB_UNIQUE_NAME, OPEN_MODE, DATABASE_ROLE from gv$database;

--ON DATABASE PRIMARY.
SQL> alter system set log_archive_dest_state_4=defer sid='*' scope=both;	


---------------------------------------------------------------------------------------------------------------------------------------

--Step 3 : Issue the following SQL statement to perform the conversion

SQL> ALTER DATABASE CONVERT TO SNAPSHOT STANDBY;


---------------------------------------------------------------------------------------------------------------------------------------

--Step 4 : Bounce the standby DB

$ srvctl status database -d OPCRMSB19
$ srvctl stop database -d OPCRMSB19
$ srvctl start database -d OPCRMSB19

SQL> select GUARANTEE_FLASHBACK_DATABASE,NAME ,TIME from v$restore_point;


---------------------------------------------------------------------------------------------------------------------------------------

--Step 5 : Confirm the database mode and inform the application team, that the DB is ready to use for testing purpose

SQL> Select DB_UNIQUE_NAME, OPEN_MODE, DATABASE_ROLE from gv$database;

--recyclebin must be null
SQL> purge dba_recyclebin;

--makesure parameter sec_case_sensitive_logon = true (primary dan standby)
SQL> show parameter sec_case_sensitive_logon;


=======================================================================================================================================

** UPGRADE **

dbca


--Step 1: Check for current database role
SQL> Select DB_UNIQUE_NAME, OPEN_MODE, DATABASE_ROLE from gv$database;

---------------------------------------------------------------------------------------------------------------------------------------

--Step 2 : shutdown the snapshot standby db and mount it
$ srvctl stop database -d OPCRMSB19

sqlplus / as sysdba
startup mount;

---------------------------------------------------------------------------------------------------------------------------------------

--Step 3 : Do the conversion of snapshot standby database to physical standby database.
SQL> ALTER DATABASE CONVERT TO PHYSICAL STANDBY;

sqlplus / as sysdba
shutdown immediate;

$ srvctl remove database-d OPCRMSB19

$ srvctl add database -d OPCRMSB19 -o /u01/app/oracle/product/11.2.0/dbhome_1
$ srvctl add instance -d OPCRMSB19 -i OPCRMSB191 -n exaimcpdb01-mgt
$ srvctl add instance -d OPCRMSB19 -i OPCRMSB192 -n exaimcpdb02-mgt
$ srvctl modify database -d OPCRMSB19 -r physical_standby
$ srvctl modify database -d OPCRMSB19 -p '+DATAIMC/OPCRMSB19/PARAMETERFILE/spfileOPCRMSB19.ora'

---------------------------------------------------------------------------------------------------------------------------------------

--Step 5 : Mount the database

$ srvctl start database -d OPCRMSB19 -o mount

On Database Primary.
SQL> alter system set log_archive_dest_state_4 = ENABLE sid='*' scope=both;	

---------------------------------------------------------------------------------------------------------------------------------------

--Step 7 : Activate the MRP on standby database
SQL> alter database recover managed standby database using current logfile disconnect from session;



