
ini OGG nya mau di matikan yg table TKSOMSOWN.TBAP_PRICE_PLAN dan TKSOMSOWN.TBAP_ITEM ... 

1. masuk profile
. .OPPOM_profile12

2. masuk ke directori
cd /dbfs_direct/FS1/goldengate/

3.running goldengate
./ggsci

4. check status 

GGSCI (exa62bsdpdb2-mgt.telkomsel.co.id) 1> info all

Program     Status      Group       Lag at Chkpt  Time Since Chkpt
MANAGER     RUNNING
REPLICAT    RUNNING     ROMS1       00:00:04      00:00:04
REPLICAT    RUNNING     ROMS2       00:00:05      00:00:05
REPLICAT    RUNNING     ROMS3       00:00:00      00:00:00


5. stop replicat
stop replicat untuk table TBAP_PRICE_PLAN
---- stop replicat ROMS2

stop replicat untuk table TBAP_ITEM
---- stop replicat ROMS3

6. info all

