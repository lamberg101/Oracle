--Check current configurasi 
$ rman target /
RMAN> show all;


--set clear
RMAN>
CONFIGURE SNAPSHOT CONTROLFILE NAME CLEAR;


--Check nama file dari default configurationnya
RMAN> 
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/snapcf_OPPOIN191.f'; 
note! snapcf_OPSELREP1.f --ini adalah contoh nama snapshot nya.


--masuk ke path/disk group yang di inginkan (example recoc2)
masuk ke profile grid > asmcmd > RECOC2 > DB nya > pwd
contoh : +RECOC2/OPSELREP/


--run configuration nya 
RMAN> 
configure snapshot controlfile name to '+RECO1/OPRFSODBSD/snapcf_OPRFSODBSD1.f';



--Check lagi
$ rman target /
RMAN> show all;



