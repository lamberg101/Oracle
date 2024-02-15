Step Precheck
1 Check gap
--PRIMARY
@Check_gap.sql

SQL> archive log list;
 

--STANDBY 
SQL> select sequence#,applied,thread# from v$archived_log where thread#=1 order by 1;
 
SQL> select sequence#,applied,thread# from v$archived_log where thread#=2 order by 1;
 
Explanation :
From status above between Primary and standby was sync, there was no different archivelog that applied.

39737 38079
----------------------------------------------------------------------------------------------------------------------------------------

enable flashback jam 21:00:
============================

exatbs62b: primary
. .OPRFSODTBS_PROFILE
SQL> select name,open_mode,log_mode,flashback_on from v$database;
SQL> alter database flashback on;
SQL> create restore point pre_failover_bsd guarantee flashback database;


exabsd: standby
. .OPRFSODNEW-profile
SQL> select name,open_mode,log_mode,flashback_on from v$database;
SQL> alter database recover managed standby database cancel;
SQL> alter database flashback on;
SQL> create restore point pre_failover_tbs guarantee flashback database;
SQL> alter database recover managed standby database using current logfile disconnect from session;


exatbs62b: primary
SQL> alter system switch all logfile; 5x


---------------------------------------------------------------------------------------------------------------------------------


ACTIVATE DATABASE BSD JAM 22:00
===============================

SQL> alter database recover managed standby database cancel;
SQL> alter database activate standby database;

#> srvctl status database -d OPRFSODNEW
#> srvctl stop database -d OPRFSODNEW
#> srvctl config database -d OPRFSODNEW
#> srvctl modify database -d OPRFSODNEW -r primary
#> srvctl start database -d OPRFSODNEW

SQL> select name, open_mode, database_role from gv$database;



REINSTATE:
=========
EXABSD:

SQL> select to_char(standby_became_primary_scn) from v$database;

TO_CHAR(STANDBY_BECAME_PRIMARY_SCN)
----------------------------------------
16191323417793



EXATBS62B:
#> srvctl status database -d OPRFSODTBS
#> srvctl stop database -d OPRFSODTBS

SQL> STARTUP MOUNT;
SQL> Flashback Database To Scn 16191323417792;  --dari hasil select (standby_became_primary_scn) diatas, dikuraing 1
SQL> Alter Database Convert To Physical Standby;
SQL> SHUTDOWN IMMEDIATE;

#> srvctl config database -d OPRFSODTBS
#> srvctl modify database -d OPRFSODTBS -r physical_standby
#> srvctl start database -d OPRFSODTBS -o mount




ACTIVATE DATABASE TBS (ROLLBACK)
======================
. .OPRFSODTBS_PROFILE
SQL> alter database recover managed standby database cancel;
SQL> alter database activate standby database;

#> srvctl status database -d OPRFSODTBS
#> srvctl stop database -d OPRFSODTBS
#> srvctl config database -d OPRFSODTBS
#> srvctl modify database -d OPRFSODTBS -r primary
#> srvctl start database -d OPRFSODTBS

SQL> select name, open_mode, database_role from v$database;


===============================================================================================================================================

alter system set log_archive_dest_state_2=ENABLE SCOPE=BOTH SID='*';
alter system set log_archive_dest_state_2=DEFER SCOPE=BOTH SID='*';



col machine for a60
  col username for a30
  col osuser for a30
  set lines 300 pages 1000
  SELECT inst_id,machine,username,osuser,
      NVL(active_count, 0) AS active,
      NVL(inactive_count, 0) AS inactive,
      NVL(killed_count, 0) AS killed 
  FROM   ( SELECT inst_id,machine, status,username,osuser, count(*) AS quantity
      FROM   gv$session
      GROUP BY inst_id, status, machine, status,username,osuser)
  PIVOT  (SUM(quantity) AS count FOR (status) IN ('ACTIVE' AS active, 'INACTIVE' AS inactive, 'KILLED' AS killed))
  where username not in ('SYS')
  ORDER BY inactive asc;
 
 
set pages 999
set lines 999
select 'alter system kill session '''||sid||','||serial#||',@'||inst_id||''' IMMEDIATE;' 
from gv$session 
where username='DOM' 
and last_call_et > 900 
and status = 'INACTIVE' 
order by inst_id;
