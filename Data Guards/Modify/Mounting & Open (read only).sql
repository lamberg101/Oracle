step read only db opuimimc (STANDBY OPUIMTBS)

--SHUTDOWN MRP NODE 1
SQL> alter database recover managed standby database cancel;


--OPEN READY ONLY  NODE 1
SQL> alter database open read only;


--OPEN READ ONLY NODE 2
SQL> alter database open read only;


--ACTIVATE MRP NODE 1
SQL> alter database recover managed standby database using current logfile disconnect from session;


--DI PRIMARY
SQL > alter system switch logfile; --5kali

Pastikan status nya synch dan no gap



-------------------------------------------------------------------------------------------------------------------------

step mount db opuimimc (STANDBY OPUIMTBS)

--SHUTDOWN MRP NODE 1
SQL> alter database recover managed standby database cancel;


--STOP DB
$ srvctl status database -d OPUIMIMC
$ srvctl stop database -d OPUIMIMC -o immediate


--START MOUNT DB
srvctl status database -d OPUIMIMC
srvctl start database -d OPUIMIMC -o mount


--ACTIVATE MRP NODE 1
SQL> alter database recover managed standby database disconnect from session;


--DI PRIMARY
SQL> alter system switch logfile; --5kali

Pastikan status nya synch dan no gap