
--CREATE PFILE
*.db_name=OPNBPNEW
*.db_unique_name=OPNBPNEW
*.pga_aggregate_target=4g
*.sga_target=8g
*.db_create_file_dest='+DATA1'
*.db_recovery_file_dest_size=2147483648000
*.compatible='12.1.0.2.0'
*.db_recovery_file_dest='+RECO1'
--db_files jangan lupa

cd /home/oracle/ssi/OPNBPNEW
vi pfile_OPNBPNEW_restore.txt


2. STARTUP NOMOUNT
startup nomount pfile='/home/oracle/ssi/OPNBPNEW/pfile_OPNBPNEW_restore.txt';


3. CONNECT TO CATALOG
rman auxiliary / catalog ravpc1/Welcome123@zdlra


4. CONFIGURE AUXILIARY CHANNEL
configure device type 'SBT_TAPE' PARALLELISM 4 BACKUP TYPE TO BACKUPSET;
configure auxiliary channel device type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/u01/app/oracle/product/19.0.0.0/dbhome_1/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";
note! kalau error, let it be


5. RUNNING DUPLICATE
duplicate database OPNBP TO OPNBPNEW;

--RUNNING BACKGROUND
vi duplicate_opnbp.sh
chmod 777 duplicate_opnbp.sh
nohup ./duplicate_opnbp.sh &
------
export ORACLE_SID=OPNBPNEW1
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2/dbhome_1
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/jdk/jre/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
$ORACLE_HOME/bin/rman auxiliary / catalog ravpc1/Welcome123@zdlra trace=/home/oracle/ssi/OPNBPNEW/duplicate_opnbp07072021.log << EOF
run {
duplicate database OPNBP TO OPNBPNEW;
}
exit
EOF
----
Optional
show parameter pfile


6.CHANGE DATABASE_CLUSTERNYA to=TRUE
alter system set cluster_database=true scope=spfile sid='*';


7. CREATE PFILE from SPFILE
create pfile='/home/oracle/ssi/OPNBPNEW/pfile_OPNBPNEW_new.txt' from spfile;


8. ADD parameter berikut ke PFILE BARU
OPNBPNEW2.instance_name='OPNBPNEW2'
OPNBPNEW1.instance_name='OPNBPNEW1'
OPNBPNEW2.instance_number=2
OPNBPNEW1.instance_number=1


9. CREATE SPFILE from PFILE
create spfile='+DATA1/OPNBPNEW/PARAMETER/spfileOPNBPNEW1.ora' from pfile='/home/oracle/ssi/OPNBPNEW/pfile_OPNBPNEW_new.txt';

note!
show parameter pfile --Check nama pfilenya
path spfile di sesuaikan di asm
create path PARAMETER kalau belum ada


10. SHUTDOWN DATABASE
SQL> SHUTDOWN IMMEDIATE;


11. add to cluster
$ srvctl add database -d OPNBPNEW -o /u01/app/oracle/product/12.1.0.2/dbhome_1
$ srvctl add instance -d OPNBPNEW -i OPNBPNEW1 -n exa82absdpdbadm01
$ srvctl add instance -d OPNBPNEW -i OPNBPNEW2 -n exa82absdpdbadm02
$ srvctl modify database -d OPNBPNEW -p '+DATA1/OPNBPNEW/PARAMETER/spfileOPNBPNEW1.ora' ---ambil path nya dari hasil path create spfile 


12. STARTUP DATABASE
srvctl status database -d OPNBPNEW
srvctl start database -d OPNBPNEW
srvctl status database -d OPNBPNEWa