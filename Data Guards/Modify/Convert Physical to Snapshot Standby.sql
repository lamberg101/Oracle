Converting a Physical Standby Database into a Snapshot Standby Database

--LOGIN AS SYSDBA
$ sqlplus / as sysdba


--FLASHBACK_ON has to be YES
SQL> select log_mode,flashback_on from v$database;

--if flashback_on = NO must be changes,
SQL > ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
SQL > ALTER DATABASE FLASHBACK ON;


--CHECheck OPEN_MODE, to make sure the db mode before convert to snapshot

--CONVERT to SNAPSHOT
SQL> ALTER DATABASE CONVERT TO SNAPSHOT STANDBY;



--CHECK THE RECOVERY PARAMETER
SQL> show parameter db_recover
NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
db_recovery_file_dest		     string	 +RECOC5
db_recovery_file_dest_size	     big integer 3000G


--CHANGE THE RECOVERY PARAMETER IF NECESSARY
SQL> alter system set db_recovery_file_dest='/u05/fast_recovery_area';
SQL> alter system set db_recovery_file_dest_size=20480M;



--STOP THE ARCHIVELOG SYNCHRONIZATION
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;	
--On Database Primary.
SQL> alter system set log_archive_dest_state_2=defer sid='*' scope=both;	



--SHUTDOWN THE STANDBY DB AND MOUNT IT , IF STATUS DATABASE OPEN READ ONLY
$ srvctl stop database -d OPPOMTBS
$ srvctl start database -d OPPOMTBS -o mount


--ISSUE THE FOLLOWING SQL STATEMENT TO PERFORM THE CONVERSION
SQL> ALTER DATABASE CONVERT TO SNAPSHOT STANDBY;


--BOUNCE THE STANDBY DB
$ srvctl status database -d OPPOMTBS
$ srvctl stop database -d OPPOMTBS
$ srvctl start database -d OPPOMTBS


--CROSSCHEK
--Confirm the database mode and inform the application team, that the DB is ready to use for testing purpose
SQL> Select DB_UNIQUE_NAME, OPEN_MODE, DATABASE_ROLE from v$database;

NAME OPEN_MODE DATABASE_ROLE
---------- ---------------------------
ORCL READ WRITE SNAPSHOT STANDBY