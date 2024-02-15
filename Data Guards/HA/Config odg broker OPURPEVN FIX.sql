PRIMARY = OPURPEVN (exapdb62b-scan)
STANDBY = OPEVNURP (exa82absdp-scan1)


+++++++++++++++++++++++++
add service cluster:

primary: 
srvctl status service -d OPURPEVN


primary: 
---------
srvctl add service -d OPURPEVN -service URPEVNDG -preferred OPURPEVN1,OPURPEVN2 -tafpolicy BASIC -role PRIMARY -policy AUTOMATIC -notification TRUE -rlbgoal SERVICE_TIME -failovertype SESSION -failovermethod BASIC

standby 
------
srvctl status service -d OPEVNURP
srvctl add service -d OPEVNURP -service URPEVNDG -preferred OPEVNURP1,OPEVNURP2 -tafpolicy BASIC -role PRIMARY -policy AUTOMATIC -notification TRUE -rlbgoal SERVICE_TIME -failovertype SESSION -failovermethod BASIC

start service nya biasanya sudah auto jika reload listener:

primary :
---------
srvctl start service -d OPURPEVN -s URPEVNDG

srvctl status service -d OPURPEVN --> untuk Check service nya

standby :
---------
srvctl status service -d OPEVNURP
srvctl start service -d OPEVNURP -s URPEVNDG --tidak perlu

+++++++++++++++++++++++
dgmgrl sys/OR4cl35y5#2015@OPURPEVN


primary:
------
--masuk ke grid
asmcmd > 
mkdir -p +DATAC2/OPURPEVN/broker
mkdir -p +RECOC2/OPURPEVN/broker

--masuk ke profile DB
SQL> alter system set dg_broker_config_file1='+DATAC2/OPURPEVN/broker/dr1OPURPEVN.dat' sid='*' scope=both;
SQL> alter system set dg_broker_config_file2='+RECOC2/OPURPEVN/broker/dr2OPURPEVN.dat' sid='*' scope=both;


standby:
--------
--masuk ke grid
asmcmd > 
mkdir -p +DATA1/OPEVNURP/broker
mkdir -p +RECO1/OPEVNURP/broker
--masuk ke profile DB
SQL> alter system set dg_broker_config_file1='+DATA1/OPEVNURP/broker/dr1OPEVNURP.dat' sid='*' scope=both;
SQL> alter system set dg_broker_config_file2='+RECO1/OPEVNURP/broker/dr2OPEVNURP.dat' sid='*' scope=both;


on both db (primary dan standby)
--------------------------------
SQL> alter system set dg_broker_start=true sid='*' scope=both;


Add primary db configuration [ ON PRIMARY]
-------------------------------------
$ dgmgrl sys/OR4cl35y5#2015
DGMGRL> CREATE CONFIGURATION URPEVNDG AS PRIMARY DATABASE IS OPURPEVN CONNECT IDENTIFIER IS OPURPEVN;
DGMGRL> SHOW CONFIGURATION


on standby
----------
SQL> alter system set log_archive_dest_2='' sid='*' scope=both;
SQL> alter system set log_archive_dest_3='' sid='*' scope=both;


Add standby configuration [ ON PRIMARY ]
-----------------------------------------
DGMGRL> add database OPEVNURP as connect identifier is OPEVNURP;

DGMGRL> show configuration

Enable configuration: [ ON PRIMARY]
-----------------------------------
DGMGRL> enable configuration;
DGMGRL> enable database OPURPEVN;
DGMGRL> show database OPURPEVN;

On standby
------------
$ dgmgrl sys/OR4cl35y5#2015
DGMGRL> enable configuration;


add on listener.ora primary: 
--------------------------
$> . .grid_profile
$> cd $ORACLE_HOME/network/admin



#node 1:

--SID_LIST_LISTENER =
--  (SID_LIST =
    (SID_DESC =
      (SID_NAME = OPURPEVN1)
      (ORACLE_HOME = /u01/app/oracle/product/19.0.0.0/dbhome_1)
      (GLOBAL_DBNAME = OPURPEVN_DGMGRL)
    )
--  )
--NOTE, MASUKIN DI SID_LIST YANG SUDAH ADA

#node 2

SID_LIST_LISTENER =
  (SID_LIST =
    (SID_DESC =
      (SID_NAME = OPURPEVN2)
      (ORACLE_HOME = /u01/app/oracle/product/19.0.0.0/dbhome_1)
      (GLOBAL_DBNAME = OPURPEVN_DGMGRL)
    )
  )


add on listener.ora standby:
--------------------------
#node 1

SID_LIST_LISTENER =
  (SID_LIST =
    (SID_DESC =
      (SID_NAME = OPEVNURP1)
      (ORACLE_HOME = /u01/app/oracle/product/19.0.0.0/dbhome_1)
      (GLOBAL_DBNAME = OPEVNURP_DGMGRL)
    )
  )

#node 2

SID_LIST_LISTENER =
  (SID_LIST =
    (SID_DESC =
      (SID_NAME = OPEVNURP2)
      (ORACLE_HOME = /u01/app/oracle/product/19.0.0.0/dbhome_1)
      (GLOBAL_DBNAME = OPEVNURP_DGMGRL)
    )
  )

setelah itu di lsnrctl reload (makesure di service ada *DGMGRL)


--RELOAD LISTENER
$> . .grid_profile
$> lsnrctl status
$> lsnrctl reload LISTENER

Note! 


Enable flasback --> can be done before reload listener

===================== ON STANDBY ==============
SQL> select log_mode,flashback_on from gv$database;

LOG_MODE     FLASHBACK_ON
------------ ------------------
ARCHIVELOG   NO

SQL> alter database recover managed standby database cancel;

Database altered.

SQL> alter database flashback on;

Database altered.

SQL> select log_mode,flashback_on from gv$database;

LOG_MODE     FLASHBACK_ON
------------ ------------------
ARCHIVELOG   YES

SQL> alter database recover managed standby database using current logfile disconnect from session;

======== ON PRIMARY=================
SQL> select log_mode,flashback_on from gv$database;

LOG_MODE     FLASHBACK_ON
------------ ------------------
ARCHIVELOG   NO

SQL> alter database flashback on;

SQL> select log_mode,flashback_on from gv$database;

LOG_MODE     FLASHBACK_ON
------------ ------------------
ARCHIVELOG   YES


=========================

--bagian apps
jdbc:oracle:thin:@(DESCRIPTION=(FAILOVER=on)(LOAD_BALANCE=off)(CONNECT_TIMEOUT=2)(RETRY_COUNT=2)(RETRY_DELAY=2)(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=exapdb62b-scan.telkomsel.co.id)(PORT=1521))(ADDRESS=(PROTOCOL=TCP)(HOST=exa82absdp-scan1.telkomsel.co.id)(PORT=1521)))(CONNECT_DATA=(SERVICE_NAME=URPEVNDG)))

URPEVNDG =
  (DESCRIPTION =
    (FAILOVER = ON)(LOAD_BALANCE = OFF)
	(CONNECT_TIMEOUT=2)(RETRY_COUNT=2)(RETRY_DELAY=2)
    (ADDRESS = (PROTOCOL = TCP)(HOST = exapdb62b-scan.telkomsel.co.id)(PORT = 1521))
    (ADDRESS=(PROTOCOL=TCP)(HOST= exa82absdp-scan1.telkomsel.co.id)(PORT=1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = URPEVNDG)
      )
    )
  )





config observer (10.49.132.75) :
---------------------------------
add terlebih dahulu constring ke tnsnames.ora

OPURPEVN =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = exapdb62b-scan.telkomsel.co.id)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = OPURPEVN)
    )
  )

OPEVNURP  =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST =  exa82absdp-scan1.telkomsel.co.id)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = OPEVNURP )
    )
  )


akses profile
$> . .19_profile
nohup /apps/oracle/product/19.0.0/client_1/bin/dgmgrl -logfile /apps/dataguard/log/OPURPEVN.log sys/OR4cl35y5#2015@OPURPEVN "start observer file='/apps/dataguard/OPURPEVN.fsfo'" &

Note! sambil running, exec srcipt berikut di primary
$> dgmgrl sys/OR4cl35y5#2015
DGMGRL> edit configuration set property tracelevel=support;
DGMGRL> edit configuration set property FastStartFailoverThreshold=95;
DGMGRL> edit configuration set property ObserverReconnect=30;


enable fsfo di primary:
-----------------------
DGMGRL> enable fast_start failover;

set master observer:
-------------------
DGMGRL> SET MASTEROBSERVER to dgbsdpdb1.telkomsel.co.id;
DGMGRL> show observer; --> Check status observer nya


==============================================================================

--Connection to database string returns ORA-1017.Please check if database opevnurp is using a remote password file,
--its remote_login_passwordfile is set to SHARED or EXCLUSIVE,and the SYS or SYSDG password is the same as this database.

recreate pass file add sysdg=y:
$> orapwd file=orapwOPURPEVN1 password=OR4cl35y5#2015 entries=10 force=y  format=12 SYSDG=Y