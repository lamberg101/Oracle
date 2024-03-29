1. Pre-check 
Cross-check list tablespaces and Health check database.
2. Main Action
3.1. OPCMC
** TRACKINGSTREAM_112021 (need min 120G)
CREATE TABLESPACE TRACKINGSTREAM_112021 DATAFILE '+DATAC1' SIZE 1G AUTOEXTEND ON NEXT 100M MAXSIZE 30G;
alter tablespace TRACKINGSTREAM_112021 add datafile '+DATAC1' size 1G autoextend on next 300M maxsize 30G;
alter tablespace TRACKINGSTREAM_112021 add datafile '+DATAC1' size 1G autoextend on next 300M maxsize 30G;
ALTER USER CAMPAIGN_TRACKING QUOTA UNLIMITED ON TRACKINGSTREAM_112021;

** TRACKINGSTREAM_IDX_112021
CREATE TABLESPACE TRACKINGSTREAM_IDX_112021 DATAFILE '+DATAC1' SIZE 100M AUTOEXTEND ON NEXT 100M MAXSIZE 30G;
ALTER USER CAMPAIGN_TRACKING QUOTA UNLIMITED ON TRACKINGSTREAM_IDX_112021;

** DELIVERYTRACKING_112021 (need min 120G)
CREATE TABLESPACE DELIVERYTRACKING_112021 DATAFILE '+DATAC1' SIZE 1G AUTOEXTEND ON NEXT 100M MAXSIZE 30G;
alter tablespace DELIVERYTRACKING_112021 add datafile '+DATAC1' size 1G autoextend on next 300M maxsize 30G;
alter tablespace DELIVERYTRACKING_112021 add datafile '+DATAC1' size 1G autoextend on next 300M maxsize 30G;
ALTER USER CAMPAIGN_TRACKING QUOTA UNLIMITED ON DELIVERYTRACKING_112021;

** DELIVERYTRACKING_IDX_112021
CREATE TABLESPACE DELIVERYTRACKING_IDX_112021 DATAFILE '+DATAC1' SIZE 1G AUTOEXTEND ON NEXT 100M MAXSIZE 30G;
ALTER USER CAMPAIGN_TRACKING QUOTA UNLIMITED ON DELIVERYTRACKING_IDX_112021;


####Create Monthly Tablespace:###
--Change default attribute
ALTER INDEX CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING_INDEX1 MODIFY DEFAULT ATTRIBUTES TABLESPACE DELIVERYTRACKING_IDX_122021; 
ALTER INDEX CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM_IDX01 MODIFY DEFAULT ATTRIBUTES TABLESPACE TRACKINGSTREAM_IDX_122021; 
ALTER INDEX CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM_IDX02 MODIFY DEFAULT ATTRIBUTES TABLESPACE TRACKINGSTREAM_IDX_122021; 
 
--selesai team apps create partisi index tracking stream nya di unusable 
select 'alter index '||index_owner||'.'||index_name||' modify partition '||partition_name||' UNUSABLE;' from dba_ind_partitions 
where tablespace_name ='TRACKINGSTREAM_IDX_122021'and status='USABLE';

ALTER SESSION set ddl_lock_timeout=360;
--hasil query diatas







3.2. OPSELREP
** DT_RATEDATA_202111 (need min 90G)
CREATE TABLESPACE DT_RATEDATA_202111 DATAFILE '+DATA1' SIZE 1G AUTOEXTEND ON NEXT 100M MAXSIZE 30G;
alter tablespace DT_RATEDATA_202111 add datafile '+DATA1' size 1G autoextend on next 300M maxsize 30G;
alter tablespace DT_RATEDATA_202111 add datafile '+DATA1' size 1G autoextend on next 300M maxsize 30G;
ALTER USER UREP1 QUOTA UNLIMITED ON DT_RATEDATA_202111;

** IDX_RATEDATA_202111
CREATE TABLESPACE IDX_RATEDATA_202111 DATAFILE '+DATA1' SIZE 1G AUTOEXTEND ON NEXT 100M MAXSIZE 30G;
ALTER USER UREP1 QUOTA UNLIMITED ON IDX_RATEDATA_202111;

** Make Offline tablespace 
alter tablespace DT_RATEDATA_202106 OFFLINE;
alter tablespace IDX_RATEDATA_202106 OFFLINE;

** Drop Offline tablespace 
>> Check Tablespace with OFFLINE status :
SQL> select tablespace_name, status from dba_tablespaces where status='OFFLINE';

>> Activity
SQL> Drop tablespace DT_RATEDATA_202105 INCLUDING CONTENTS AND DATAFILES;
SQL> Drop tablespace IDX_RATEDATA_202105 INCLUDING CONTENTS AND DATAFILES;



3.3. OPICASMS19
** DT_RATEDATA_202111 (need min 90G)
CREATE TABLESPACE DT_RATEDATA_202111 DATAFILE '+DATAC5' SIZE 1G AUTOEXTEND ON NEXT 100M MAXSIZE 30G;
alter tablespace DT_RATEDATA_202111 add datafile '+DATAC5' size 1G autoextend on next 300M maxsize 30G;
alter tablespace DT_RATEDATA_202111 add datafile '+DATAC5' size 1G autoextend on next 300M maxsize 30G;
ALTER USER ICACB_SMS1 QUOTA UNLIMITED ON DT_RATEDATA_202111;
ALTER USER ICACB_SMS2 QUOTA UNLIMITED ON DT_RATEDATA_202111;
ALTER USER ICACB_SMS3 QUOTA UNLIMITED ON DT_RATEDATA_202111;
ALTER USER ICACB_SMS4 QUOTA UNLIMITED ON DT_RATEDATA_202111;

** IDX_RATEDATA_202111
CREATE TABLESPACE IDX_RATEDATA_202111 DATAFILE '+DATAC5' SIZE 1G AUTOEXTEND ON NEXT 100M MAXSIZE 30G;
ALTER USER ICACB_SMS1 QUOTA UNLIMITED ON IDX_RATEDATA_202111;
ALTER USER ICACB_SMS2 QUOTA UNLIMITED ON IDX_RATEDATA_202111;
ALTER USER ICACB_SMS3 QUOTA UNLIMITED ON IDX_RATEDATA_202111;
ALTER USER ICACB_SMS4 QUOTA UNLIMITED ON IDX_RATEDATA_202111;

** Make Offline tablespace 
alter tablespace DT_RATEDATA_202106 OFFLINE;
alter tablespace IDX_RATEDATA_202106 OFFLINE;

** Drop Offline tablespace 
>> Check Tablespace with OFFLINE status :
SQL> select tablespace_name, status from dba_tablespaces where status='OFFLINE';

>> Activity
Drop tablespace DT_RATEDATA_202105 INCLUDING CONTENTS AND DATAFILES;
Drop tablespace IDX_RATEDATA_202105 INCLUDING CONTENTS AND DATAFILES;



3.4. OPHPOINT
** TBS_PART_TBL_POIN_202111 (need min 100G)
CREATE TABLESPACE TBS_PART_TBL_POIN_202111 DATAFILE '+DATA1' SIZE 1G AUTOEXTEND ON NEXT 100M MAXSIZE 25G;
alter tablespace TBS_PART_TBL_POIN_202111 add datafile '+DATA1' size 1G autoextend on next 300M maxsize 25G;
alter tablespace TBS_PART_TBL_POIN_202111 add datafile '+DATA1' size 1G autoextend on next 300M maxsize 25G;
alter tablespace TBS_PART_TBL_POIN_202111 add datafile '+DATA1' size 1G autoextend on next 300M maxsize 25G;
ALTER USER NEWTSPOIN QUOTA UNLIMITED ON TBS_PART_TBL_POIN_202111;

** Make Offline tablespace 
SQL> alter tablespace TBS_PART_TBL_POIN_202008 OFFLINE;

** Drop Offline tablespace 
>> Check Tablespace with OFFLINE status :
SQL> select tablespace_name, status from dba_tablespaces where status='OFFLINE';
>> Activity
SQL> Drop tablespace TBS_PART_TBL_POIN_202007 INCLUDING CONTENTS AND DATAFILES;

4. Cross-check 
Cross-check tablespaces and Health check Database.
