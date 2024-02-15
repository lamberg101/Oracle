1. Stop LSP on logical standby (Make sure the db had been SYNC!)
   ALTER database stop logical standby apply;
   ALTER SESSION DISABLE GUARD;
2. Defer destination archive to standby
   ALTER system set log_archive_dest_state_2=DEFER scope=both sid='*';
3. Check current scn on standby before exporting tables :
   col MINING_SCN for 9999999999999999
   col APPLIED_SCN for 9999999999999999
   col RESTART_SCN for 9999999999999999
   SELECT APPLIED_TIME, APPLIED_SCN, MINING_TIME, MINING_SCN,RESTART_SCN FROM V$LOGSTDBY_PROGRESS;

4.nohup expdp \"/ as sysdba\"  directory=PRIM_DUMP tables=TELKOMSEL.TMP_MSISDN_ADIT dumpfile=TMP_MSISDN_ADIT_30072021_%U.dmp logfile=TMP_MSISDN_ADIT_30072021.log flashback_scn= parallel=4 &

5. DROP TABLE TELKOMSEL.TMP_MSISDN_ADIT PURGE; ( on standby OPSCM19 !!!)
6. nohup impdp \"/ as sysdba\"  directory=STANDBY_DUMP dumpfile=TMP_MSISDN_ADIT_30072021_%U.dmp logfile=TMP_MSISDN_ADIT_30072021.log cluster=N  parallel=4  & ( ON STANDBY OPSCM19 !!!! )

EXECUTE DBMS_LOGSTDBY.UNSKIP(stmt => 'DML', schema_name => 'TELKOMSEL', object_name =>'TMP_MSISDN_ADIT');

After import
1. Start the LSP on logical Standby
   ALTER SESSION ENABLE GUARD;
   alter database start logical standby apply immediate;
2. Enabel destination archive to standby
   ALTER system set log_archive_dest_state_2=ENABLE scope=both sid='*';

Fatur Rohman, [30.07.21 07:21]
yang mau ditanya ke mas theo terkait semalam gagal statrup dari sisi semaphore nya kan ded @dedytrywanps ?