#TABLE PARTITION
-----------------
select 'ALTER TABLE '||table_owner||'.'||table_name||' DROP PARTITION '||partition_name||' UPDATE GLOBAL INDEXES;'
from DBA_TAB_PARTITIONS 
where tablespace_name='TABLESPACE_NAME';

Contoh:
ALTER SESSION SET ddl_lock_timeout=360;
ALTER TABLE CAMPAIGN_TRACKING.TRACK_AGGREGATED DROP PARTITION SYS_P2433823 UPDATE GLOBAL INDEXES;
ALTER TABLE CAMPAIGN_TRACKING.TRACK_AGGREGATED DROP PARTITION SYS_P2433863 UPDATE GLOBAL INDEXES;
ALTER TABLE CAMPAIGN_TRACKING.TRACK_AGGREGATED DROP PARTITION SYS_P2433922 UPDATE GLOBAL INDEXES;

Note!
1. HK bisa di lakukan per batch/bulan
2. yang partisi *_default jangan di HK

=====================================================================================================================

CASE :
- Sebagian besar dari data table tersebut 
- 2 partisi kurleb 50% data

Solve!
- Jika data/table nya sering digunakan, baiknya di gather stats
- Script drop partition menggunakan update indexes
SQL> ALTER TABLE MESSAGES DROP PARTITION MESSAGES_SEP2021 UPDATE INDEXES;
SQL> ALTER TABLE ARP_REQUEST_DETAIL DROP PARTITION ARP_REQUEST_DETAIL_JUN2021 UPDATE INDEXES;
SQL> ALTER TABLE ARP_REQUEST_DETAIL DROP PARTITION ARP_REQUEST_DETAIL_JUL2021 UPDATE INDEXES;
SQL> ALTER TABLE ARP_REQUEST_DETAIL DROP PARTITION ARP_REQUEST_DETAIL_AUG2021 UPDATE INDEXES;
SQL> ALTER TABLE ARP_REQUEST_DETAIL DROP PARTITION ARP_REQUEST_DETAIL_SEP2021 UPDATE INDEXES;


Contoh:
ALTER SESSION SET ddl_lock_timeout=360;
ALTER TABLE CAMPAIGN_TRACKING.TRACK_AGGREGATED DROP PARTITION SYS_P2433823 UPDATE GLOBAL INDEXES;

