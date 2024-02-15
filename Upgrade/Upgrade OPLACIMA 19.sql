prereq:
------
1. check space reco/fra (on standby)
alter system set db_recovery_file_dest_size=500G sid='*' scope=both;

2. check status flashback (on standby)
select FLASHBACK_ON from v$database;
alter database recover managed standby database cancel;
alter database flashback on;
alter database recover managed standby database using current logfile disconnect from session;

3. disable parameter rac (on standby)
alter system set cluster_database=false scope=spfile sid='*';

4. backup controlfile (on standby dan primary)
alter database backup controlfile to trace as '/home/oracle/ssi/slam/OPLACIMA19/controlfile.txt';

5. check broker makesure value false (on standby dan primary)
show parameter dg_broker_start;

6. check protection mode (must not maximum protection) (on standby dan primary)
select protection_mode, protection_level from v$database;

7. check invalid object (on standby dan primary)
set pagesize 100
set linesize 200
col object_name for a50
select object_name, object_type, owner from dba_objects where status<>'VALID';

if want drop:
set linesize 200
set heading off
select 'drop ' || object_type || ' "' || owner || '"."' || object_name || '";'
from dba_objects
where status='INVALID';

8. gather statistic (makesure last gather stat running)
EXEC DBMS_STATS.gather_database_stats;


9. backup full + pfile
backup harian (zfs atau zdlra)

10. makesure on primary already alter for convert parameter

alter system set log_file_name_convert='+DATAC2/OPLACIMA','+DATAC2/OPLACIMA19','+RECOIMC/OPLACIMA','+RECOIMC/OPLACIMA19' sid='*' scope=spfile;
alter system set db_file_name_convert='+DATAC2/OPLACIMA','+DATAC2/OPLACIMA19','+RECOIMC/OPLACIMA','+RECOIMC/OPLACIMA19' sid='*' scope=spfile;

11. makesure on v$standby_log must be any thread 1 & 2

select * from gv$standby_log;

action prereq:
1. test switchover

method:
------
1. odg + logical standby + upgrade (standby) + swicthover + upgrade primary (old) + switchback
2. odg + logical standby + upgrade (standby) + cutover
3. odg + cutover + upgrade (standby)

method 1:
---------

https://support.dbagenesis.com/knowledge-base/oracle-11g-to-12c-rolling-upgrade/

https://oracledbwr.com/oracle-database-rolling-upgrade-from-11g-to-12c-using-a-data-guard/

step switchover:
---------------
1. sesuai MOP swicthover dan switchback (tinggal disesuaikan database name nya)
2. sesuai mop cutover (tinggal disesuaikan database name nya)

mop convert logical standby:
xxxxxxxxxxxxxxxxxxxxxxxxxxxx

On primary (prod):
==================
SQL> create restore point pre_upgrade_pri guarantee flashback database;

On standby (prod_st):
=====================
SQL> alter database recover managed standby database cancel;
SQL> create restore point pre_upgrade_stb guarantee flashback database;
SQL> alter database recover managed standby database disconnect;

Build Log Miner directory on primary
-----------------------------------
begin
dbms_logstdby.build;
end;
/

Convert physical standby into logical standby
--------------------------------------------
On standby (prod_st):
=====================
SQL> alter database recover managed standby database cancel;
SQL> shut immediate;

SQL> startup mount;
SQL> alter database recover to logical standby keep identity;
SQL> alter database activate standby database;  --> jika database role ngak berubah menjadi logical standby
SQL> alter database open;
SQL> alter database start logical standby apply immediate;

SQL> select state from v$logstdby_state; 


MOP upgrade:
-----------
precheck upgrade:
------------
- recyclebin must be null
SQL> purge dba_recyclebin;

- parameter use_large_pages must be set FALSE
SQL> alter system set use_large_pages=FALSE SCOPE=SPFILE sid='*';

- redolog must be higher 200MB

1. defer dest_2 on primary

SQL> alter system set log_archive_dest_state_2=DEFER scope=memory sid='*';

2. On Logical Standby (prod_st):
=============================
SQL> alter database stop logical standby apply;
SQL> create restore point before_upgrade_lstb guarantee flashback database;
SQL> shutdown immediate;

3. create profile untuk db 19c

export ORACLE_SID=tesdb191
export ORACLE_HOME=/u01/app/oracle/product/19.0.0.0/dbhome_1
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/jdk/jre/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib


4. copy tnsnames ke path tns versi 19c nya (tnsname primary dan standby)

5. copy passwordfile ke path ORACLE_HOME/dbs versi 19c nya

6. preupgrade (run using profile versi 11) --> makesure ngak ada yang not passed

/u01/app/oracle/product/19.0.0.0/dbhome_1/jdk/bin/java -jar /u01/app/oracle/product/19.0.0.0/dbhome_1/rdbms/admin/preupgrade.jar TERMINAL TEXT

if using DBUA
-------------
7. added on /etc/oratab

OPLACIMA:/u01/app/oracle/product/11.2.0.4/dbhome_1:N

8. DBUA

9. On primary (prod):
==================
SQL> alter system set log_archive_dest_state_2=enable scope=memory sid='*';

10. on Upgraded Logical Standby (prod_st):
======================================
SQL> alter database start logical standby apply immediate;

if using manual upgrade:
------------------------

https://oracle-base.com/articles/misc/update-database-time-zone-file

7. shutdown database (standby) 

SQL> SHUTDOWN IMMEDIATE;

8. startup upgrade (using profile 19c)

SQL> STARTUP UPGRADE;

9. catalog upgrade (using profile 19c) --> estimasi 1,5 jam

$ cd $ORACLE_HOME/rdbms/admin
$ /u01/app/oracle/product/19.0.0.0/dbhome_1/perl/bin/perl catctl.pl -n 4 -l /home/oracle/ssi/log catupgrd.sql

10. change db timezone

SET SERVEROUTPUT ON
DECLARE
  l_tz_version PLS_INTEGER;
BEGIN
  SELECT DBMS_DST.get_latest_timezone_version
  INTO   l_tz_version
  FROM   dual;

  DBMS_OUTPUT.put_line('l_tz_version=' || l_tz_version);
  DBMS_DST.begin_upgrade(l_tz_version);
END;
/

11. startup database

SQL> startup;

12. Check registry

SQL> 
col COMP_ID format A10
col COMP_NAME format A30
col VERSION format A10
col STATUS format A15
SELECT SUBSTR(COMP_ID,1,15) COMP_ID,SUBSTR(COMP_NAME,1,30) COMP_NAME,
SUBSTR(VERSION,1,10) VERSION,STATUS FROM DBA_REGISTRY;

13. On primary (prod):
==================
SQL> alter system set log_archive_dest_state_2=enable scope=memory sid='*';

14. on Upgraded Logical Standby (prod_st):
======================================
SQL> alter database start logical standby apply immediate;

MONITOR process logical standby:
---------------------------------
https://clouddba.co/monitor-steps-logical-standby-database/

Step by Step How to Do Swithcover/Failover on Logical Standby Environment (Doc ID 2535950.1)

mop to switchover --> mulai downtime dari sisi apps
-----------------

http://yvrk1973.blogspot.com/2012/03/switchover-in-logical-standby-database.html

Step by Step How to Do Swithcover/Failover on Logical Standby Environment (Doc ID 2535950.1)

1. change 





ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YY HH24:MI:SS';
SELECT SYSDATE, APPLIED_TIME FROM V$LOGSTDBY_PROGRESS;


SET LONG 1000
SET PAGESIZE 180
SET LINESIZE 79
SELECT EVENT_TIMESTAMP, EVENT, STATUS FROM DBA_LOGSTDBY_EVENTS ORDER BY EVENT_TIMESTAMP;