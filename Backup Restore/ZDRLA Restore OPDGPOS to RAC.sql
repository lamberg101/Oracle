Detail Steps of Restoring Database using ZDRLA backup.
Thing that needs to be considered when performing the restore database using ZDRLA backup is that we have to set the DBID of the database to determine its backup and use the list from the control_file backup.

1. Create Pfile
Creating a new pfile  and adjust the bellow parameters (input db_name and db-unique_name parameters from the old pfile) 
1. CREATE PFILE
*.db_name=OTDGPOS
*.db_unique_name=OTDGPOS
*.pga_aggregate_target=4g
*.sga_target=8g
*.db_create_file_dest='+DATA1'
*.db_recovery_file_dest_size=2147483648000
*.compatible='12.1.0.2.0'
*.db_recovery_file_dest='+RECO1'

2. Start Database
After creating the new pfile  Start database using the newly created pfile. 
$ SQLPLUS / AS SYSDBA

SQL> startup nomount pfile='/home/oracle/ssi/TESTDGPOS/pfile_OPRFSODTES_restore.txt';


 3. Login to Recovery Manager (RMAN)
Login to RMAN using the zdlra backup user i.e. backup_admin/Welcome123
$ rman target backup_admin/Welcome123 catalog ravpc1/Welcome123@rabsdp



 4. Configure auxiliary creadential 
RMAN> configure device type 'SBT_TAPE' PARALLELISM 4 BACKUP TYPE TO BACKUPSET;
configure auxiliary channel device type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/u01/app/oracle/product/19.0.0.0/dbhome_1/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";

note! kalau error, let it be
Example:
 
 

 5. Duplicate Database

--RUNNING BACKGROUND
vi duplicate_OTDGPOS.sh
chmod 777 duplicate_OTDGPOS.sh
nohup ./duplicate_OTDGPOS.sh &
------
export ORACLE_SID=OPRFSODTES1
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2/dbhome_1
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/jdk/jre/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
$ORACLE_HOME/bin/rman auxiliary / catalog ravpc1/Welcome123@zdlra trace=/home/oracle/ssi/OTDGPOS/duplicate_opnbp07072021.log << EOF
run {
duplicate database OPDGPOS19TO OTDGPOS;
}
exit
EOF
----
Optional
show parameter pfile








6.CHANGE DATABASE_CLUSTERNYA to=TRUE
alter system set cluster_database=true scope=spfile sid='*';


7. CREATE PFILE from SPFILE
create pfile='/home/oracle/ssi/OTDGPOS/pfile_OPRFSODTES_new.txt' from spfile;

8. ADD parameter berikut ke PFILE BARU
OTDGPOS2.instance_name='OTDGPOS2'
OTDGPOS1.instance_name='OTDGPOS1'
OTDGPOS2.instance_number=2
OTDGPOS1.instance_number=1

9. CREATE SPFILE from PFILE
create spfile='+DATA1/OTDGPOS/PARAMETER/spfileOPRFSODTES1.ora' from pfile='/home/oracle/ssi/OTDGPOS/pfile_OPRFSODTES_new.txt';

note!
show parameter pfile --Check nama pfilenya
path spfile di sesuaikan di asm
create path PARAMETER kalau belum ada

10. SHUTDOWN DATABASE
SQL> SHUTDOWN IMMEDIATE;

11. add to cluster
$ srvctl add database -d OTDGPOS -o /u01/app/oracle/product/12.1.0.2/dbhome_1
$ srvctl add instance -d OTDGPOS -i OTDGPOS1 -n exa82absdpdbadm01
$ srvctl add instance -d OTDGPOS -i OTDGPOS2 -n exa82absdpdbadm02
$ srvctl modify database -d OPRFSODTES -p '+DATA1/OPRFSODTES/PARAMETER/spfileOPRFSODTES1.ora' ---ambil path nya dari hasil path create spfile 

12. STARTUP DATABASE
srvctl status database -d OPRFSODTES
srvctl start database -d OPRFSODTES
srvctl status database -d OPRFSODTES
