1. Stop LSP on logical standby (Make sure the db had been SYNC!)
   ALTER database stop logical standby apply;
   ALTER SESSION DISABLE GUARD;
2. Defer destination archive on primary !!!!!!!
   ALTER system set log_archive_dest_state_2=DEFER scope=both sid='*';
3. Check current scn on standby before exporting tables :
   col MINING_SCN for 9999999999999999
   col APPLIED_SCN for 9999999999999999
   col RESTART_SCN for 9999999999999999
   SELECT APPLIED_TIME, APPLIED_SCN, MINING_TIME, MINING_SCN,RESTART_SCN FROM V$LOGSTDBY_PROGRESS;
   
   mount point path location
   /datadump11/OPSCM_TEMP
==========================================================================================================================

1.nohup expdp \"/ as sysdba\"  directory=DATADUMP tables=DEDY_WIDYANTO.IFM_TRC_REPOSITORY dumpfile=IFM_TRC_REPOSITORY_072021_%U.dmp logfile=IFM_TRC_REPOSITORY_072021.log flashback_scn=disesuaikan parallel=4 &
2.DROP TABLE DEDY_WIDYANTO.IFM_TRC_REPOSITORY; ( on standby OPSCM19 !!!)
3.nohup impdp \"/ as sysdba\"  directory=STANDBY_DUMP dumpfile=IFM_TRC_REPOSITORY_072021_%U.dmp logfile=IMP_IFM_TRC_REPOSITORY_072021.log cluster=N  parallel=4  & ( ON STANDBY OPSCM19 !!!! )
4.create index
CREATE INDEX "DEDY_WIDYANTO"."IFM_TRC_REPOSITORY_SUM" ON "DEDY_WIDYANTO"."IFM_TRC_REPOSITORY" ("PERSO_PO_ID", "POSITION_NUMBER")
TABLESPACE "OCS_TS_INDX" PARALLEL (degree 8) nologging;
alter index DEDY_WIDYANTO.IFM_TRC_REPOSITORY_SUM noparallel logging;

CREATE INDEX "DEDY_WIDYANTO"."IFM_TRC_REPOSITORY" ON "DEDY_WIDYANTO"."IFM_TRC_REPOSITORY" ("INPUT_FILE_ID_PERSO", "POSITION_NUMBER", "HLR_DESCRIPTION")
TABLESPACE "DATA" PARALLEL (degree 8) nologging;
alter index DEDY_WIDYANTO.IFM_TRC_REPOSITORY noparallel logging;

CREATE UNIQUE INDEX "DEDY_WIDYANTO"."IFM_TRC_REPOSITORY_SN" ON "DEDY_WIDYANTO"."IFM_TRC_REPOSITORY" ("SERIAL_NUMBER")
TABLESPACE "OCS_TS_INDX" PARALLEL (degree 8) nologging;
alter index DEDY_WIDYANTO.IFM_TRC_REPOSITORY_SN noparallel logging;

CREATE INDEX "DEDY_WIDYANTO"."IFM_TRC_REPOSITORY_FLG" ON "DEDY_WIDYANTO"."IFM_TRC_REPOSITORY" ("FLAG")
TABLESPACE "OCS_TS_INDX" PARALLEL (degree 8) nologging;
alter index DEDY_WIDYANTO.IFM_TRC_REPOSITORY_FLG noparallel logging;

CREATE INDEX "DEDY_WIDYANTO"."IFM_TRC_REPOSITORY_NSTS" ON "DEDY_WIDYANTO"."IFM_TRC_REPOSITORY" ("NEW_STORE_STATUS")
TABLESPACE "OCS_TS_INDX" PARALLEL (degree 8) nologging;
alter index DEDY_WIDYANTO.IFM_TRC_REPOSITORY_NSTS noparallel logging;

CREATE UNIQUE INDEX "DEDY_WIDYANTO"."IFM_TRC_REPOSITORY_M" ON "DEDY_WIDYANTO"."IFM_TRC_REPOSITORY" ("MSISDN")
TABLESPACE "OCS_TS_INDX" PARALLEL (degree 8) nologging;
alter index DEDY_WIDYANTO.IFM_TRC_REPOSITORY_M noparallel logging;

CREATE UNIQUE INDEX "DEDY_WIDYANTO"."IFM_TRC_REPOSITORY_I" ON "DEDY_WIDYANTO"."IFM_TRC_REPOSITORY" ("IMSI"))
TABLESPACE "OCS_TS_INDX" PARALLEL (degree 8) nologging;
alter index DEDY_WIDYANTO.IFM_TRC_REPOSITORY_I noparallel logging;

CREATE INDEX "DEDY_WIDYANTO"."IFM_TRC_REPOSITORY_ISD" ON "DEDY_WIDYANTO"."IFM_TRC_REPOSITORY" ("IS_DELETED")
TABLESPACE "OCS_TS_INDX" PARALLEL (degree 8) nologging;
alter index DEDY_WIDYANTO.IFM_TRC_REPOSITORY_ISD noparallel logging;

CREATE INDEX "DEDY_WIDYANTO"."IFM_TRC_REPOSITORY_MO" ON "DEDY_WIDYANTO"."IFM_TRC_REPOSITORY" ("MSISDN_OLD")
TABLESPACE "OCS_TS_INDX" PARALLEL (degree 8) nologging;
alter index DEDY_WIDYANTO.IFM_TRC_REPOSITORY_MO noparallel logging;

CREATE INDEX "DEDY_WIDYANTO"."IFM_TRC_REPOSITORY_IO" ON "DEDY_WIDYANTO"."IFM_TRC_REPOSITORY" ("IMSI_OLD")
TABLESPACE "OCS_TS_INDX" PARALLEL (degree 8) nologging;
alter index DEDY_WIDYANTO.IFM_TRC_REPOSITORY_IO noparallel logging;

CREATE INDEX "DEDY_WIDYANTO"."IFM_TRC_REPOSITORY_ISU" ON "DEDY_WIDYANTO"."IFM_TRC_REPOSITORY" ("IS_USED")
TABLESPACE "OCS_TS_INDX" PARALLEL (degree 8) nologging;
alter index DEDY_WIDYANTO.IFM_TRC_REPOSITORY_ISU noparallel logging;

CREATE INDEX "DEDY_WIDYANTO"."IFM_TRC_REPOSITORY_STS" ON "DEDY_WIDYANTO"."IFM_TRC_REPOSITORY" ("STORE_STATUS")
TABLESPACE "OCS_TS_INDX" PARALLEL (degree 8) nologging;
alter index DEDY_WIDYANTO.IFM_TRC_REPOSITORY_STS noparallel logging;

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

1.nohup expdp \"/ as sysdba\"  directory=DATADUMP tables=TELKOMSEL.TRACE_LOG_TRANSACTION dumpfile=TRACE_LOG_TRANSACTION_082021_%U.dmp logfile=TRACE_LOG_TRANSACTION_082021.log flashback_scn=disesuaikan parallel=4 &
2.DROP TABLE TELKOMSEL.TRACE_LOG_TRANSACTION; ( on standby OPSCM19 !!!)
3.nohup impdp \"/ as sysdba\"  directory=STANDBY_DUMP dumpfile=TRACE_LOG_TRANSACTION_082021_%U.dmp logfile=IMP_TRACE_LOG_TRANSACTION_082021.log cluster=N  parallel=4  & ( ON STANDBY OPSCM19 !!!! )
4.create index
CREATE INDEX "TELKOMSEL"."TRACE_LOG_TRANSACTION_NDX1" ON "TELKOMSEL"."TRACE_LOG_TRANSACTION" ("CREATED_PERIODE", "TRANSACTION_TYPE", "TRANSACTION_REFF_ID")
TABLESPACE "DATA2" PARALLEL (degree 8) nologging;
alter index TELKOMSEL.TRACE_LOG_TRANSACTION_NDX1 noparallel logging;

=====================================================================================================================

1.nohup expdp \"/ as sysdba\"  directory=DATADUMP tables=TELKOMSEL.TRACE_LOG dumpfile=TRACE_LOG_082021_%U.dmp logfile=TRACE_LOG_082021.log flashback_scn=disesuaikan parallel=4 &
2.DROP TABLE TELKOMSEL.TRACE_LOG; ( on standby OPSCM19 !!!)
3.nohup impdp \"/ as sysdba\"  directory=STANDBY_DUMP dumpfile=TRACE_LOG_082021_%U.dmp logfile=IMP_TRACE_LOG_082021.log cluster=N  parallel=4  & ( ON STANDBY OPSCM19 !!!! )
4.create index

CREATE INDEX "TELKOMSEL"."TRCLOG_IDX01" ON "TELKOMSEL"."TRACE_LOG" ("TRACE_ID")
TABLESPACE "DATA" PARALLEL (degree 8) nologging;
alter index TELKOMSEL.TRCLOG_IDX01 noparallel logging;

=========================================================================================================================

1.nohup expdp \"/ as sysdba\"  directory=DATADUMP tables=TELKOMSEL.TTRACE dumpfile=TTRACE_082021_%U.dmp logfile=TTRACE_082021.log flashback_scn=disesuaikan parallel=4 &
2.DROP TABLE TELKOMSEL.TTRACE; ( on standby OPSCM19 !!!)
3.nohup impdp \"/ as sysdba\"  directory=STANDBY_DUMP dumpfile=TTRACE_082021_%U.dmp logfile=IMP_TTRACE_082021.log cluster=N  parallel=4  & ( ON STANDBY OPSCM19 !!!! )
4.create index
CREATE INDEX "TELKOMSEL"."TTRACE_1" ON "TELKOMSEL"."TTRACE" ("NOMOR")
TABLESPACE "OCS_TS_INDX" PARALLEL (degree 8) nologging;
alter index TELKOMSEL.TTRACE_1 noparallel logging;

==========================================================================================================================

UNSKIP TABLE ON STANDBY !!!!!!!!
EXECUTE DBMS_LOGSTDBY.UNSKIP(stmt => 'DML', schema_name => 'DEDY_WIDYANTO', object_name =>'IFM_TRC_REPOSITORY');
EXECUTE DBMS_LOGSTDBY.UNSKIP(stmt => 'DML', schema_name => 'TELKOMSEL', object_name =>'TRACE_LOG_TRANSACTION');
EXECUTE DBMS_LOGSTDBY.UNSKIP(stmt => 'DML', schema_name => 'TELKOMSEL', object_name =>'TRACE_LOG');
EXECUTE DBMS_LOGSTDBY.UNSKIP(stmt => 'DML', schema_name => 'TELKOMSEL', object_name =>'TTRACE');

ENABLE 
1. Start the LSP on logical Standby
   ALTER SESSION ENABLE GUARD;
   alter database start logical standby apply immediate;
   
2. Enable destination archive on primary !!!!!
   ALTER system set log_archive_dest_state_2=ENABLE scope=both sid='*';