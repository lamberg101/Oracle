1. Check high vaule dan default tablespace nya.
set lines 300
col high_value for a35
select TABLESPACE_NAME, index_owner, index_name, partition_name, high_value 
from dba_ind_partitions
where index_name='CMS_DELIVERYTRACKING_INDEX1'
order by index_name desc;

Note! high_value dan default tablespace nya harus dalam bulan yang sama

----------------------------------------------------------------------------------------------------------------------------------

SET DEFAULE ATTRIBUT

#INDEX DEFAULT ATTRIBUT
ALTER INDEX CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING_INDEX1 MODIFY DEFAULT ATTRIBUTES TABLESPACE DELIVERYTRACKING_IDX_042020;
ALTER INDEX CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM_IDX01 MODIFY DEFAULT ATTRIBUTES TABLESPACE TRACKINGSTREAM_IDX_042020;
ALTER INDEX CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM_IDX02 MODIFY DEFAULT ATTRIBUTES TABLESPACE TRACKINGSTREAM_IDX_042020;

#TABLE DEFAULT ATTRIBUT
ALTER TABLE CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM MODIFY DEFAULT ATTRIBUTES TABLESPACE TRACKINGSTREAM_042020;
ALTER TABLE CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING MODIFY DEFAULT ATTRIBUTES TABLESPACE DELIVERYTRACKING_042020;

--kasih ke team apps, kalau mereka lupa jalankan di awal bulan.
--disesuaikn per bulan, kalau tablespace yang di create sampai bulan 6, berarti jalankan sampai bulan 6 juga.

----------------------------------------------------------------------------------------------------------------------------------

set heading off
set linesize 200
set pagesize 9999
spool ind_part.sql
select 'ALTER INDEX '||index_owner||'.'||index_name||' REBUILD PARTITION '||partition_name||' TABLESPACE DELIVERYTRACKING_IDX_042020 NOLOGGING;' 
from dba_ind_partitions 
where tablespace_name='DELIVERYTRACKING_IDX_012020';

pake ini, dengan catatan partition_name nya sesuaikan dengan high_value pada tablespace nya

Contoh:
ALTER INDEX CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING_INDEX1 REBUILD PARTITION SYS_P4589902 TABLESPACE DELIVERYTRACKING_IDX_042020 NOLOGGING;
ALTER INDEX CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING_INDEX1 REBUILD PARTITION SYS_P4589903 TABLESPACE DELIVERYTRACKING_IDX_042020 NOLOGGING;
ALTER INDEX CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING_INDEX1 REBUILD PARTITION SYS_P4589904 TABLESPACE DELIVERYTRACKING_IDX_042020 NOLOGGING;


------------------------------------------------------------------------------------------------------------------------------

OPCMC
--partisi bulanan cmc belum ada kabar dari tim apps
Sebelum mereka create partisi, jalanin ini dulu di kita biar nanti indexnya sesuai tablespacenya
alter index CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING_INDEX1 modify default attributes tablespace DELIVERYTRACKING_IDX_012021;
alter index CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM_IDX01 modify default attributes tablespace TRACKINGSTREAM_IDX_012021;
alter index CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM_IDX02 modify default attributes tablespace TRACKINGSTREAM_IDX_012021;
--jika sudah, unusable index yang cms_trackingstream_idx01 dan cms_trackingstream_idx02.
select 'ALTER INDEX '||index_owner||'.'||index_name||' MODIFY PARTITION '||partition_name||' UNUSABLE;' 
from dba_ind_partitions 
where tablespace_name ='%TRACKINGSTREAM_IDX_012021'
and status='USABLE';
