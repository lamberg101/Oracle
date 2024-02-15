PREREQUISITE :

1. (STANDBY) Stop LSP on logical standby (Make sure the database are in SYNC!)
SQL> alter database stop logical standby apply;
SQL> alter session disable guard;

2. (PRIMARY) Defer destination archive to standby
SQL> alter system set log_archive_dest_state_2=DEFER scope=both sid='*';

3. (STANDBY) Check current scn before exporting tables --ambil yang Restart_SCN nya
col mining_scn for 9999999999999999
col applied_scn for 9999999999999999
col restart_scn for 9999999999999999
select applied_time, applied_scn, mining_time, mining_scn,restart_scn from v$logstdby_progress;

------------------------------------------------------------------------------------------------------------------------------------

A. EXPDP/IMPDP TABLE

1. (ON PRIMARY) Export the skipped table 
--nohup expdp \"/ as sysdba\"  directory=PRIM_DUMP tables=DEDY_WIDYANTO.IFM_TRC_REPOSITORY dumpfile=IFM_TRC_REPOSITORY_NEW_%U.dmp logfile=IFM_TRC_REPOSITORY_NEW.log flashback_scn=16318398493240 parallel=4 &

2. (ON STANDBY) Drop the skiped table
SQL> DROP TABLE DEDY_WIDYANTO.IFM_TRC_REPOSITORY PURGE; (ON STANDBY DB!!!)

3. (ON STANDBY) Import Table
--nohup impdp \"/ as sysdba\"  directory=DUMP_OPSCM tables=DEDY_WIDYANTO.IFM_TRC_REPOSITORY dumpfile=IFM_TRC_REPOSITORY_NEW_%U.dmp logfile=IFM_TRC_REPOSITORY_NEW.log cluster=N EXCLUDE=INDEX parallel=4  &


B. CREATE INDEX (Check the full indexes and their DDL from primary)

1. (ON STANDBY) Create Index --run in background
set timing on
CREATE INDEX DEDY_WIDYANTO.IFM_TRC_REPOSITORY ON DEDY_WIDYANTO.IFM_TRC_REPOSITORY (INPUT_FILE_ID_PERSO, POSITION_NUMBER, HLR_DESCRIPTION) TABLESPACE DATA  PARALLEL (degree 8) nologging;
CREATE UNIQUE INDEX DEDY_WIDYANTO.IFM_TRC_REPOSITORY_SN ON DEDY_WIDYANTO.IFM_TRC_REPOSITORY (SERIAL_NUMBER) TABLESPACE OCS_TS_INDX PARALLEL (degree 8) nologging;
alter index DEDY_WIDYANTO.IFM_TRC_REPOSITORY noparallel logging;
alter index DEDY_WIDYANTO.IFM_TRC_REPOSITORY_SN noparallel logging;



C. UNSKIP TABLE (STANDBY, make sure the mrp is disabled)
execute dbms_logstdby.unskip(stmt => 'DML', schema_name => 'DEDY_WIDYANTO', object_name =>'IFM_TRC_REPOSITORY');
execute dbms_logstdby.unskip(stmt => 'DML', schema_name => 'TELKOMSEL', object_name =>'TRACE_LOG');


D. (STANDBY) Start the LSP and enable logial MRP
alter session enable guard;
alter database start logical standby apply immediate;


E. ENABLE DEST STATE 2 (PRIMARY)
alter system set log_archive_dest_state_2=ENABLE scope=both sid='*';
