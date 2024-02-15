1. OPPRN (node 1)
> masuk ke profile OPPRN
cd /u01/app/acfsmounts/oggacfs/goldengate
./ggsci 
info all


2. OPPOM (node 2)
> masuk ke profile OPPOM
cd /dbfs_direct/FS1/goldengate
./ggsci
info all

------------------------------------------------------------------------------------------------------------------------


--GOLDEN GATE NGRS
check OGG :
1. mgttbspdb1 —-> mgtsolopdb2
2. txntbspdb2 —-> txnsolopdb2
3. shorttbspdb1 —-> shortsolopdb2

COMMAND:
masuk ke db NGRS
$ g
GGSCI> info all --buat check status gap OGG

GGSCI> INFO REPLICAT (nama group), detail, allprocesses  -- buat check detail file nya
Example: INFO REPLICAT RPMS100, detail, allprocesses  —> buat check detail file nya

GGSCI> view params (nama group) --buat check source and target table nya

log errornya disini :  
/apps/oracle/ogg/ogg/ggserr.log



------------------------------------------------------------------------------------------------------------------------

#stop replicat
--------------
stop replicat untuk table TBAP_PRICE_PLAN	> stop ROMS2
stop replicat untuk table TBAP_ITEM 		> stop ROMS3
info all


#start OGG --kalau abbended
-----------
> masuk ke profile
> masuk ke ogg
> info all
> start ROMS1 --sesuaikan dengan nama di ogg
> info all
> start ROMS2
> info all
> start ROMS3


Note!
untuk Check path bisa pake 
ps -ef | grep mgr 
-lalu cari path nya
Check log error di goldengate/ggserr.log
utk 3 tkrcm, opcis, oprreg gg ke 82
/u01/app/acfsmounts/oggacfs/goldengate/dirdat/rsrm3.dsc, APPEND/exceed Megabytes 1000 --cat /dev/null > rsrm3.dsc ?
--------------------------------------------------------------------------------------------------------


3. TKOMS01 
cd /TKOMS01/oravl99/oracle/goldengate/OGG
./ggsci 
info all


--------------------------------------------------------------------------------------------------------


4. Housekkeping Oracle Golden Gate

cd /u01/app/acfsmounts/oggacfs/goldengate/dirdat
ls
rm et0000094*
ls
rm  ex00000380*
df -h


