[In reply to Dedy Sitanggang]
1. CREATE PFILE
*.db_name=OPRMN9IT
*.db_unique_name=OPRMN9IT
*.pga_aggregate_target=2G
*.sga_target=5168M
*.db_create_file_dest='+DATAC5'
*.db_recovery_file_dest_size=1500G
*.compatible='11.2.0.4'
*.db_recovery_file_dest='+RECO5'
*.db_files=1024



2. STARTUP NOMOUNT
startup nomount pfile='/home/oracle/ssi/OPRMN9IT/pfile_restore.sh';


3. CONNECT TO CATALOG
rman target backup_admin/Welcome123 catalog ravpc1/Welcome123@zdlra

4. CONFIGURE AUXILIARY CHANNEL
configure device type 'SBT_TAPE' PARALLELISM 4 BACKUP TYPE TO BACKUPSET;
configure auxiliary channel device type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/u01/app/oracle/product/19.0.0.0/dbhome_1/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";


5. RUNNING DUPLICATE
cd /home/oracle/ssi/OPRMN9IT

export ORACLE_SID=OPRMN9IT1
export ORACLE_HOME=/u01/app/oracle/product/11.2.0.4/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
$ORACLE_HOME/bin/rman auxiliary / catalog rravpc1/Welcome123@zdlra trace=/home/oracle/ssi/OPRMN9IT1/duplicate_OPRMN9IT30082021.log << EOF
run {
duplicate database OPREMNO TO OPRMN9IT;
}
exit
EOF
----


6.CHANGE DATABASE_CLUSTERNYA to=TRUE
alter system set cluster_database=TRUE scope=spfile sid='*';


7. CREATE PFILE from SPFILE
create pfile='/home/oracle/ssi/OPRMN9IT/pfile_OPRMN9IT_new.txt' from spfile;


##shutdown

8. ADD parameter berikut ke PFILE BARU
vi /home/oracle/ssi/OPRMN9IT/pfile_OPRMN9IT_new.txt
##note masukin parameter dibawah ke dalam pfile
OPRMN9IT2.instance_name='OPRMN9IT2'
OPRMN9IT1.instance_name='OPRMN9IT1'
OPRMN9IT2.instance_number=2
OPRMN9IT1.instance_number=1


9. CREATE SPFILE from PFILE
create spfile='+DATAC5/OPRMN9IT/PARAMETER/spfileOPRMN9IT.ora' from pfile='/home/oracle/ssi/OPRMN9IT/pfile_OPRMN9IT_new.txt';


11. add to cluster
$ srvctl add database -d OPRMN9IT -o /u01/app/oracle/product/11.2.0.4/dbhome_1
$ srvctl add instance -d OPRMN9IT -i OPRMN9IT1 -n exa62tbspdb1-mgt
$ srvctl add instance -d OPRMN9IT -i OPRMN9IT2 -n exa62tbspdb2-mgt
$ srvctl modify database -d OTPRN -p '+DATAC5/OPRMN9IT/PARAMETER/spfileOPRMN9IT.ora' 


12. STARTUP DATABASE
srvctl status database -d OPRMN9IT
srvctl start database -d OPRMN9IT
srvctl status database -d OPRMN9IT