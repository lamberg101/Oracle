Detail Steps of Restoring Database using ZDRLA backup.
Thing that needs to be considered when performing the restore database using ZDRLA backup is that we have to set the DBID of the database to determine its backup and use the list from the control_file backup.

1. Create Pfile
Creating a new pfile  and adjust the bellow parameters (input db_name and db-unique_name parameters from the old pfile) 
1. CREATE PFILE
*.db_name=TESTPOIN
*.db_unique_name=TESTPOIN
*.pga_aggregate_target=4g
*.sga_target=8g
*.db_create_file_dest='+DATA1'
*.db_recovery_file_dest_size=2147483648000
*.compatible='12.1.0.2.0'
*.db_recovery_file_dest='+RECO1'


Create profile db
$> vi .TESTPOIN_profile
export ORACLE_SID=TESTPOIN1 --set ke node 1
export ORACLE_HOME=/u01/app/oracle/product/19.0.0.0/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib


2. Start Database
After creating the new pfile  Start database using the newly created pfile. 
$ SQLPLUS / AS SYSDBA

SQL> startup nomount pfile='/home/oracle/ssi/TESTPOIN/pfile_TESTPOIN_restore.txt';


 3. Login to Recovery Manager (RMAN)
Login to RMAN using the zdlra backup user i.e. backup_admin/Welcome123
$ rman target backup_admin/Welcome123 catalog ravpc1/Welcome123@rabsdp



4. Configure auxiliary creadential 
configure auxiliary channel device type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/u01/app/oracle/product/19.0.0.0/dbhome_1/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/zdlra credential_alias=zdlrabsda-scan:1521/rabsdp:dedicated')";

note! kalau error, let it be
Example:
 
 
5. Duplicate Database

$> vi duplicate_TESTPOIN.sh
$> chmod 777 duplicate_TESTPOIN.sh
$> nohup ./duplicate_TESTPOIN.sh &
------
export ORACLE_SID=TESTPOIN1 --set ke node 1
export ORACLE_HOME=/u01/app/oracle/product/19.0.0.0/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
$ORACLE_HOME/bin/rman auxiliary / catalog ravpc1/Welcome123@zdlra trace=/home/oracle/ssi/TESTPOIN/duplicate_opnbp07072021.log << EOF
run {
allocate auxiliary channel c1 type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/u01/app/oracle/product/19.0.0.0/dbhome_1/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/zdlra credential_alias=zdlrabsda-scan:1521/rabsdp:dedicated')";
allocate auxiliary channel c2 type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/u01/app/oracle/product/19.0.0.0/dbhome_1/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/zdlra credential_alias=zdlrabsda-scan:1521/rabsdp:dedicated')";
allocate auxiliary channel c3 type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/u01/app/oracle/product/19.0.0.0/dbhome_1/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/zdlra credential_alias=zdlrabsda-scan:1521/rabsdp:dedicated')";
allocate auxiliary channel c4 type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/u01/app/oracle/product/19.0.0.0/dbhome_1/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/zdlra credential_alias=zdlrabsda-scan:1521/rabsdp:dedicated')";
allocate auxiliary channel c5 type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/u01/app/oracle/product/19.0.0.0/dbhome_1/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/zdlra credential_alias=zdlrabsda-scan:1521/rabsdp:dedicated')";
allocate auxiliary channel c6 type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/u01/app/oracle/product/19.0.0.0/dbhome_1/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/zdlra credential_alias=zdlrabsda-scan:1521/rabsdp:dedicated')";
duplicate database OPPOINBSD to TESTPOIN;
}
exit
EOF
----

Optional
show parameter pfile



6.CHANGE DATABASE_CLUSTERNYA to=TRUE
alter system set cluster_database=true scope=spfile sid='*';


7. CREATE PFILE from SPFILE
create pfile='/home/oracle/ssi/TESTPOIN/pfile_TESTPOIN_new.txt' from spfile;

8. ADD parameter berikut ke PFILE BARU
TESTPOIN2.instance_name='TESTPOIN2'
TESTPOIN1.instance_name='TESTPOIN1'
TESTPOIN2.instance_number=2
TESTPOIN1.instance_number=1

9. CREATE SPFILE from PFILE
create spfile='+DATA1/TESTPOIN/PARAMETER/spfileTESTPOIN1.ora' from pfile='/home/oracle/ssi/TESTPOIN/pfile_TESTPOIN_new.txt';

note!
show parameter pfile --Check nama pfilenya
path spfile di sesuaikan di asm
create path PARAMETER kalau belum ada

10. SHUTDOWN DATABASE
SQL> SHUTDOWN IMMEDIATE;

11. add to cluster
$> srvctl add database -d TESTPOIN -o /u01/app/oracle/product/19.0.0.0/dbhome_1
$> srvctl add instance -d TESTPOIN -i TESTPOIN1 -n exa82absdpdbadm01
$> srvctl add instance -d TESTPOIN -i TESTPOIN2 -n exa82absdpdbadm02
$> srvctl modify database -d TESTPOIN -p '+DATA1/TESTPOIN/PARAMETER/spfileTESTPOIN1.ora' ---ambil path nya dari hasil path create spfile 


12. STARTUP DATABASE
$> srvctl status database -d TESTPOIN
$> srvctl start database -d TESTPOIN
$> srvctl status database -d TESTPOIN



=====================================

Note! 
1. Kalau ga bisa configure allocate channel nya, manual aja di dscript restore nya
2. Kalu dbhome baru, dan err tnsping pas konek ke zdlra, masukin conn string di bawah ke tnsnames

ZDLRA =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = zdlra62-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = zdlra)
    )
  )


rabsdp =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = zdlrabsda-scan)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = rabsdp)
      (UR = A)
    )
  )