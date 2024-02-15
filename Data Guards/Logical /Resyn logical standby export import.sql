
IFM_TRC_REPOSITORY
in primary

1. EXPORT




--nohup expdp \"/ as sysdba\" 
directory=PRIM_DUMP tables=DEDY_WIDYANTO.IFM_TRC_REPOSITORY dumpfile=IFM_TRC_REPOSITORY_NEW_%U.dmp logfile=ifm_trc_repository_new.log flashback_scn=16318849592910 parallel=4 &






--RESTART MRP LOGICAL
alter database stop logical standby apply;
alter database start logical standby apply immediate;


--ambil scn dari RESTART_SCN
col applied_scn format 99999999999999999
col LATEST_SCN format 99999999999999999
col MINING_SCN format 99999999999999999
col RESTART_SCN format 99999999999999999
SELECT APPLIED_SCN, LATEST_SCN, MINING_SCN, RESTART_SCN FROM V$LOGSTDBY_PROGRESS;




--RESTART DEST_STATE
alter system set log_archive_dest_state_2=DEFER SCOPE=BOTH SID='*';
alter system set log_archive_dest_state_2=ENABLE SCOPE=BOTH SID='*';










IN STANDBY
2. Drop table
DROP TABLE DEDY_WIDYANTO.IFM_TRC_REPOSITORY PURGE;


3. IMPORT
--nohup impdp \"/ as sysdba\"  
directory=STBY_DUMP 
tables=DEDY_WIDYANTO.IFM_TRC_REPOSITORY 
dumpfile=IFM_TRC_REPOSITORY_NEW_%U.dmp 
logfile=IFM_TRC_REPOSITORY_NEW.log cluster=N exclude=INDEX parallel=4 &

4. create index
CREATE INDEX DEDY_WIDYANTO.IFM_TRC_REPOSITORY ON DEDY_WIDYANTO.IFM_TRC_REPOSITORY (INPUT_FILE_ID_PERSO, POSITION_NUMBER, HLR_DESCRIPTION) TABLESPACE DATA PARALLEL (degree 8) nologging;
alter index DEDY_WIDYANTO.IFM_TRC_REPOSITORY noparallel logging;


Check total index nya di table itu dan create (sesuaikan dulu)



set lines 300
col owner for a20
col directory_name for a30
col directory_path for a70
select owner, directory_name, directory_path from dba_directories
where directory_name='PRIM_DUMP';



--CREATE AND GRANT DRECTORY
create or replace directory STBY_DUMP as '/ogg_data/OPSCM';
grant read, write on directory STBY_DUMP to SYS;