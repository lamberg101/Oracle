Converting a Snapshot Standby Database into a Physical Standby Database


--CHECK FOR CURRENT DATABASE ROLE
SQL> Select DB_UNIQUE_NAME, OPEN_MODE, DATABASE_ROLE from v$database;

NAME OPEN_MODE DATABASE_ROLE
-------------------------------------- ---------- ---------------------------
ORCL READ WRITE SNAPSHOT STANDBY



--SHUTDOWN THE SNAPSHOT STANDBY DB AND MOUNT IT
$ srvctl stop database -d OPPOMTBS
$ srvctl start database -d OPPOMTBS -o mount


--DO THE CONVERSION OF SNAPSHOT STANDBY DATABASE TO PHYSICAL STANDBY DATABASE.
SQL> ALTER DATABASE CONVERT TO PHYSICAL STANDBY;



--SHUTDOWN THE DB AND START THE INSTANCE;
$ srvctl stop database -d OPPOMTBS


--MOUNT THE DATABASE
$ srvctl start database -d OPPOMTBS -o mount

--On Database Primary.
SQL> alter system set log_archive_dest_state_2=enable sid='*' scope=both;	



--ACTIVATE THE MRP ON STANDBY DATABASE
SQL> alter database recover managed standby database using current logfile disconnect from session;
