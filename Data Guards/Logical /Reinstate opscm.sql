STOP LSP
1. Stop LSP ON LOGICAL STANDBY (Make sure the db had been SYNC!)
SQL> ALTER database stop logical standby apply;
SQL> ALTER SESSION DISABLE GUARD;

2. Defer destination archive ON PRIMARY !!!!!!!
SQL> ALTER system set log_archive_dest_state_2=DEFER scope=both sid='*';

3. Check current scn on standby before exporting tables :
SQL>
col mining_scn for 9999999999999999
col applied_scn for 9999999999999999
col restart_scn for 9999999999999999
select applied_time, applied_scn, mining_time, mining_scn,restart_scn from v$logstdby_progress;

mount point path location: /datadump11/OPSCM_TEMP

=========================================================================================================================

1. DROP OLD TABLE di STANDBY DATABASE OPSCM19 !
SQL> DROP TABLE DEDY_WIDYANTO.IFM_TRC_REPOSITORY;
SQL> DROP TABLE TELKOMSEL.TRACE_LOG_TRANSACTION;
SQL> DROP TABLE TELKOMSEL.TRACE_LOG;
SQL> DROP TABLE TELKOMSEL.TCRPS114T;
SQL> DROP TABLE TELKOMSEL.TCPUR043T;

=========================================================================================================================

2. CREATE PILE PAR

vi EXPDP_REINSTATE_OPSCM19_270821.par
---------
DIRECTORY=DATADUMP
DUMPFILE=REINSTATE_OPSCM19_27082021_%U.dmp
LOGFILE=EXPDP_REINSTATE_OPSCM19_27082021.log
parallel=4
flashback_scn=
TABLES =
DEDY_WIDYANTO.IFM_TRC_REPOSITORY
TELKOMSEL.TRACE_LOG_TRANSACTION
TELKOMSEL.TRACE_LOG
TELKOMSEL.TCRPS114T
TELKOMSEL.TCPUR043T
---------

=========================================================================================================================

3. EXPORT (on PRIMARY)
--nohup expdp \"/ as sysdba\" parfile=EXPDP_REINSTATE_OPSCM19_270821.par &


4. IMPORT (on LOGICAL STANDBY OPSCM19!!!!)
--nohup impdp \"/ as sysdba\" directory=DATADUMP dumpfile=REINSTATE_OPSCM19_27082021_%U.dmp logfile=IMP_REINSTATE_OPSCM19_27082021.log cluster=N EXCLUDE=INDEX  parallel=4 &

=========================================================================================================================

5. CREATE INDEX SCRIPT ada di /home/oracle/ssi/slam/OPSCM19
all_index_TCRPS114T.sql
all_index_TCPUR043T.sql
all_index_DEDY.sql
all_index_TRACE_LOG.sql

=========================================================================================================================

6. UNSKIP TABLE
EXECUTE DBMS_LOGSTDBY.UNSKIP(stmt => 'DML', schema_name => 'DEDY_WIDYANTO', object_name =>'IFM_TRC_REPOSITORY');
EXECUTE DBMS_LOGSTDBY.UNSKIP(stmt => 'DML', schema_name => 'TELKOMSEL', object_name =>'TRACE_LOG_TRANSACTION');
EXECUTE DBMS_LOGSTDBY.UNSKIP(stmt => 'DML', schema_name => 'TELKOMSEL', object_name =>'TRACE_LOG');
EXECUTE DBMS_LOGSTDBY.UNSKIP(stmt => 'DML', schema_name => 'TELKOMSEL', object_name =>'TCPUR043T');
EXECUTE DBMS_LOGSTDBY.UNSKIP(stmt => 'DML', schema_name => 'TELKOMSEL', object_name =>'TCRPS114T');



ENABLE 
1. Start the LSP on logical Standby
   ALTER SESSION ENABLE GUARD;
   alter database start logical standby apply immediate;
   
2. Enable destination archive on primary !!!!!
   ALTER system set log_archive_dest_state_2=ENABLE scope=both sid='*';