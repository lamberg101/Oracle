Detailed database services for this activity

#OPRAFM
Oracle SID 		: OPRAFM1/ OPRAFM2
Serive Name 	: OPRAFM
Oracle Version 	: 11.2.0.4.0
IP address 		: 10.54.128.6/10.54.128.7

OPRAFM=
       (DESCRIPTION =
               (ADDRESS_LIST = (ADDRESS =
                       (PROTOCOL = TCP)(HOST = exa62bsda-scan)(PORT = 1521)))
               (CONNECT_DATA = (SERVER = DEDICATED)
       (SERVICE_NAME = OPRAFM )
      (UR=A)
   )
)

#OPRAFM19
Oracle SID 		: OPRAFM191/ OPRAFM192
Service Name 	: OPRAFM19
Oracle Version 	: 19.6.0.0.0
IP address 		: 10.54.128.6/10.54.128.7
 
OPRAFM19 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = exa62bsda-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = OPRAFM19)
    )
  )

=========================================================================================================================


1. Check GAP ON OPRAFM (PRIMARY)
--pakai query Check gap

2. STOP APPLIKASI
--dari team apps


3. Check LAST APPLIED ON OPRAFM19 (STANDBY)
SQL> ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YY HH24:MI:SS';
SQL> SELECT APPLIED_TIME, LATEST_TIME, MINING_TIME, RESTART_TIME FROM V$LOGSTDBY_PROGRESS;


4. DEFER DESTINATION ON PRIMARY OPRAFM (PRIMARY)
SQL> ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_2 = DEFER sid='*' scope=both; 


5. STOP MRP LOGICAL STANDBY
SQL> ALTER DATABASE STOP LOGICAL STANDBY APPLY;



6. SWITCH SERVICE NAME

--PRIMARY from OPRAFM to OPRAFMOLD  
SQL> alter system set service_names='OPRAFMOLD' sid='*' scope=both;

--STANDBY OPRAFM19 to OPRAFM 
SQL> alter system set service_names='OPRAFM' sid='*' scope=both;



7. Activate and Change DB Standby (OPRAFM19) to PRIMARY
--Change status db standby to primary
SQL> ALTER DATABASE ACTIVATE LOGICAL STANDBY DATABASE;

$> srvctl status database -d OPRAFM19
$> srvctl stop database -d OPRAFM19
$> srvctl config database -d OPRAFM19
$> srvctl modify database -d OPRAFM19 -r primary
$> srvctl start database -d OPRAFM19

SQL> select name, open_mode, database_role from gv$database;


8. START APPLIKASI
--dari team apps



9.	CHANGE STATUS DATABASE OPRAFM TO READONLY --post config

OLD PRIMARY versi 11
$> srvctl stop database -d OPRAFM
$> srvctl start database -d OPRAFM -o mount

SQL> alter database open readonly;   --> on both nodes


=========================================================================================================================

Check OBJECTS

set pagesize 100
set linesize 200
col object_name for a50
col owner for a30
select object_name, object_type, owner, status from dba_objects where status<>'VALID' order by 1,2,3;



========================================================================================================




STEPS EXECUTE CUT OFF: 
-----------------------

#DI DATABASE PRIMARY --setelah tim apps mematikan services apps ke arah database primary: 
--------------------
1.1. switch logfile --> dikedua node 3x switch 
SQL> alter system switch logfile;  

1.2. set dest_2
SQL> alter system set log_archive_dest_state_2='defer' scope=memory sid='*'; 
SQL> show parameter log_archive_dest_state_2; 


#DI DATABASE STANDBY
---------------------
2.1. Cancel recover managed standby database di database standby: 
SQL> alter database recover managed standby database cancel;

2.2. Configure and restart database OPIDMEXAP di database standby menjadi database primary: 
SQL> alter database activate standby database; 
sql> select process, status, thread#, sequence#, block#, blocks from v$managed_standby where process ='MRP0'; 

$> srvctl stop database -d OPIDMEXAP 
$> srvctl config database -d OPIDMEXAP 
$> srvctl modify database -d OPIDMEXAP -r primary 
$> srvctl start database -d OPIDMEXAP 

SQL> select name, open_mode, database_role from v$database; 






















