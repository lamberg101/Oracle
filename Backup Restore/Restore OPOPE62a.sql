Note!
1. pastikan diskgroup aman --asmcmd lsdg
2. pastikan memorynya aman --free -g

1. CREATE PFILE
*.db_name=OPE62NEW
*.db_unique_name=OPE62NEW
*.pga_aggregate_target=4g
*.sga_target=8g
*.db_create_file_dest='+DATA1'
*.db_recovery_file_dest_size=2147483648000
*.compatible='12.1.0.2.0'
*.db_recovery_file_dest='+RECO1'
*.db_files=200



cd /home/oracle/ssi/OPE62NEW
vi pfile_OPE62NEW_restore.txt


2. STARTUP NOMOUNT
startup nomount pfile='/home/oracle/ssi/OPE62NEW/pfile_OPE62NEW_restore.txt';


--profile
export ORACLE_SID=OPE62NEW1
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2/dbhome_1
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/jdk/jre/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib



3. CONNECT TO CATALOG
rman auxiliary / catalog ravpc1/Welcome123@zdlra


4. CONFIGURE AUXILIARY CHANNEL
configure device type 'SBT_TAPE' PARALLELISM 4 BACKUP TYPE TO BACKUPSET;
configure auxiliary channel device type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/u01/app/oracle/product/19.0.0.0/dbhome_1/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";

Note! 
auxiliary channel device type nya disesuaikan dengan existing di target
kalau error, let it be


5. RUNNING DUPLICATE
duplicate database OPOPE62 TO OPE62NEW;


--RUNNING BACKGROUND
vi duplicate_OPE62NEW.sh
chmod 777 duplicate_OPE62NEW.sh
nohup ./duplicate_OPE62NEW.sh &
------
export ORACLE_SID=OPE62NEW1
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2/dbhome_1
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/jdk/jre/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
$ORACLE_HOME/bin/rman auxiliary / catalog ravpc1/Welcome123@zdlra trace=/home/oracle/ssi/OPE62NEW/duplicate_OPE62NEW_07072021.log << EOF
run {
duplicate database OPOPE62 TO OPE62NEW;
}
exit
EOF
----
Optional
show parameter pfile


6.CHANGE DATABASE_CLUSTERNYA to=TRUE
alter system set cluster_database=true scope=spfile sid='*';


/u01/app/oracle/product/12.1.0.2/dbhome_1/dbs/spfileOPE62NEW1.ora


7. CREATE PFILE from SPFILE
create pfile='/home/oracle/ssi/OPE62NEW/pfile_OPE62NEW_new.txt' from spfile;


7. SHUTDOWN IMMEDIATE


8. ADD parameter berikut ke PFILE BARU
OPE62NEW2.instance_name='OPE62NEW2'
OPE62NEW1.instance_name='OPE62NEW1'
OPE62NEW2.instance_number=2
OPE62NEW1.instance_number=1


9. CREATE SPFILE from PFILE --jalain saat db mati
create spfile='+DATA1/OPE62NEW/PARAMETER/spfileOPE62NEW1.ora' from pfile='/home/oracle/ssi/OPE62NEW/pfile_OPE62NEW_new.txt';

note!
show parameter pfile --Check nama pfilenya
path spfile di sesuaikan di asm
create path PARAMETER kalau belum ada


11. add to cluster
srvctl add database -d OPE62NEW -o /u01/app/oracle/product/12.1.0.2/dbhome_1
srvctl add instance -d OPE62NEW -i OPE62NEW1 -n exa82absdpdbadm01
srvctl add instance -d OPE62NEW -i OPE62NEW2 -n exa82absdpdbadm02
srvctl modify database -d OPE62NEW -p '+DATA1/OPE62NEW/PARAMETER/spfileOPE62NEW1.ora' ---ambil path nya dari hasil path create spfile 


12. STARTUP DATABASE
srvctl status database -d OPE62NEW
srvctl start database -d OPE62NEW
srvctl status database -d OPE62NEWa



===================================================================================================================================

DROP DATABASE MANUAL
1. SET CLUSTER DATABASE 
alter system set cluster_database=false scope=spfile sid='*';

2. SHUTDOWN --kalau cluster pake srvcrl
srvctl status database -d DB2TEST
srvctl stop database -d DB2TEST

3. STARTUP
startup mount RESTRICT;

4. DROP
drop database;


------------------------------------------------------------------------------------------------
REMOVE DARI CLUSTER
. .grid
crsctl stat res -t

masuk ke profile db
srvctl status database -d OPE62NEW
srvctl remove database -d OPE62NEW
srvctl status database -d OPE62NEW

. .grid
crsctl stat res -t




