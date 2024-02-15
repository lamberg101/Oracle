--MONITOR CREATE PARTISI OPCMC april 2021 (042021)
--Sebelum mereka create, jalankan ini :
  ALTER INDEX CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING_INDEX1 MODIFY DEFAULT ATTRIBUTES TABLESPACE DELIVERYTRACKING_IDX_042021;
  ALTER INDEX CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM_IDX01 MODIFY DEFAULT ATTRIBUTES TABLESPACE TRACKINGSTREAM_IDX_042021;
  ALTER INDEX CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM_IDX02 MODIFY DEFAULT ATTRIBUTES TABLESPACE TRACKINGSTREAM_IDX_042021;

--Setelah partisi di create, jangan lupa unusable index CMS_TRACKINGSTREAM_IDX01 & CMS_TRACKINGSTREAM_IDX02 :
select 'alter index '||index_owner||'.'||index_name||' modify partition '||partition_name||' UNUSABLE;' 
from dba_ind_partitions 
where tablespace_name like '%TRACKINGSTREAM_IDX_042021%';



=====================================================================================================================

--CONTOH SCRIPT CREATE PARTISI

ALTER SESSION SET ddl_lock_timeout=300;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM SET INTERVAL ();
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-02 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-03 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-04 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-05 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-06 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-07 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-08 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-09 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-10 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-11 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-12 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-13 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-14 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-15 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-16 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-17 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-18 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-19 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-20 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-21 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-22 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-23 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-24 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-25 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-26 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-27 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-28 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-29 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-04-30 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM add partition values less than (TIMESTAMP' 2021-05-01 00:00:00') logging nocompress tablespace TRACKINGSTREAM_042021;
alter table CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM SET INTERVAL ( NUMTODSINTERVAL(1, 'DAY'));


ALTER SESSION SET ddl_lock_timeout=300;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING SET INTERVAL ();
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-02 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-03 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-04 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-05 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-06 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-07 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-08 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-09 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-10 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-11 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-12 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-13 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-14 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-15 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-16 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-17 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-18 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-19 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-20 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-21 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-22 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-23 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-24 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-25 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-26 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-27 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-28 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-29 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-04-30 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING add partition values less than (TIMESTAMP' 2021-05-01 00:00:00') logging nocompress tablespace DELIVERYTRACKING_042021;
alter table CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING SET INTERVAL ( NUMTODSINTERVAL(1, 'DAY'));
