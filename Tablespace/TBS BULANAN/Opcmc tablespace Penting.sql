
--Change default attribute 
*JALANIN SEBELUM MEREKA CREATE PARTISI*
ALTER INDEX CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING_INDEX1 MODIFY DEFAULT ATTRIBUTES TABLESPACE DELIVERYTRACKING_IDX_112021; 
ALTER INDEX CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM_IDX01 MODIFY DEFAULT ATTRIBUTES TABLESPACE TRACKINGSTREAM_IDX_112021; 
ALTER INDEX CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM_IDX02 MODIFY DEFAULT ATTRIBUTES TABLESPACE TRACKINGSTREAM_IDX_112021; 
 
--selesai team apps create partisi index tracking stream nya di unusable 
select 'alter index '||index_owner||'.'||index_name||' modify partition '||partition_name||' UNUSABLE;' from dba_ind_partitions 
where tablespace_name ='TRACKINGSTREAM_IDX_102021'and status='USABLE';

ALTER SESSION set ddl_lock_timeout=360;
--hasil query diatas



MOVE PARTISI --karena salah partisi/nyasar

set heading off
set linesize 200
set pagesize 9999
select 'ALTER INDEX '||index_owner||'.'||index_name||' REBUILD PARTITION '||partition_name||' TABLESPACE TRACKINGSTREAM_IDX_112021 NOLOGGING;' 
from dba_ind_partitions 
where tablespace_name='TRACKINGSTREAM_IDX_102021';

Contoh:
ALTER INDEX CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING_INDEX1 REBUILD PARTITION SYS_P4589902 TABLESPACE DELIVERYTRACKING_IDX_102021 NOLOGGING;
ALTER INDEX CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING_INDEX1 REBUILD PARTITION SYS_P4589903 TABLESPACE DELIVERYTRACKING_IDX_102021 NOLOGGING;
ALTER INDEX CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING_INDEX1 REBUILD PARTITION SYS_P4589904 TABLESPACE DELIVERYTRACKING_IDX_102021 NOLOGGING;

Note!
1. Pake NOLOGGING kalau sudah ada isinya, kalau belum ga usah aja gpp
2. partisinya di sesuain (TIMESTAMP' 2021-11-02 00:00:00') diseuain dengan partisi tbs nya
================================================================================================

1. Check high vaule dan default tablespace nya.
set lines 300
col high_value for a35
select TABLESPACE_NAME, index_owner, index_name, partition_name, high_value 
from dba_ind_partitions
where index_name='CMS_DELIVERYTRACKING_INDEX1'
and TABLESPACE_NAME='DELIVERYTRACKING_IDX_102021'
order by index_name desc;

Note! high_value dan default tablespace nya harus dalam bulan yang sama