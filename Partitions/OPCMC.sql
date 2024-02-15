
ALTER INDEX CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING_INDEX1 MODIFY DEFAULT ATTRIBUTES TABLESPACE DELIVERYTRACKING_IDX_092021;
ALTER INDEX CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM_IDX01 MODIFY DEFAULT ATTRIBUTES TABLESPACE TRACKINGSTREAM_IDX_092021;
ALTER INDEX CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM_IDX02 MODIFY DEFAULT ATTRIBUTES TABLESPACE TRACKINGSTREAM_IDX_092021;

Sebelum tim apps CMC nya create partisi, biar partisinya si index ke default. WAJIB!! 
--supaya kalau mereka create dan lupa define tbs nya, akan masuk ke tbs yg di assign
(Klo engga ntar report mindahin index object nya krn masih ke default tbs yg lama) 
Sama di unusable index partisi yg trackingstream_idx_* after tim apps create partisi





#BUAT YG TRACKING STREAM
select table_owner,table_name,partition_name,tablespace_name, high_value 
from DBA_TAB_PARTITIONS 
where table_owner = 'CAMPAIGN_TRACKING' 
and tablespace_name='TRACKINGSTREAM_122020';

#BUAT YG DELIVERY
select table_owner,table_name,partition_name,tablespace_name, high_value 
from DBA_TAB_PARTITIONS 
where table_owner = 'CAMPAIGN_TRACKING' 
and tablespace_name='DELIVERYTRACKING_122020';

