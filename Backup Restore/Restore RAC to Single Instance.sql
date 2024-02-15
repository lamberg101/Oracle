TARGET:
--OASIS/oasis
10.49.31.4/oasisrtspdb1/opoasis
oracle/Oracle#2020
--alternative 
ssh habibrk@10.49.31.4
wulfj2u9
sudo su - oracle

1. Create Pfile
Creating a new pfile and adjust the bellow parameters (input db_name and db-unique_name parameters from the old pfile) 
1. CREATE PFILE
*.db_name=TESTSCV
*.db_unique_name=TESTSCV
*.pga_aggregate_target=6g
*.sga_target=12g
*.db_create_file_dest='/DBUPGRADE/TESTSCV'
*.db_recovery_file_dest_size=2147483648000
*.compatible='12.1.0.2.0'
*.db_files=200
*.db_recovery_file_dest='/DBUPGRADE/TESTSCV/FRA'




2. Start Database
create profile
$ vi .TESTSCV_profile
export ORACLE_SID=TESTSCV
export ORACLE_HOME=/data/PRODHR/oracle/product/12.1.0.2/db_2
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib



3. Masukan connection string intended zdlra to tnsname.ora target database
Example:
ZDLRA =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = zdlra62-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = zdlra)
    )
  )


After creating the new pfile  Start database using the newly created pfile. 
$ sqlplus / as sysdba

SQL> startup nomount pfile='/home/oracle/ssi/TESTSCV/pfile_OPSCVTEST_restore.txt';


pastiin ini sudah ada
ls -lrth /u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/zdlra

3. Login to Recovery Manager (RMAN)
Login to RMAN using the zdlra backup user i.e. backup_admin/Welcome123
$ rman target backup_admin/Welcome123 catalog ravpc1/Welcome123@rabsdp --utk db bsd
$ rman target backup_admin/Welcome123 catalog ravpc1/Welcome123@zdlra --untuk db tbs




4. Configure auxiliary creadential 
RMAN> 
configure device type 'SBT_TAPE' PARALLELISM 4 BACKUP TYPE TO BACKUPSET;
configure auxiliary channel device type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/data/PRODHR/oracle/product/12.1.0.2/db_2/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/data/PRODHR/oracle/product/12.1.0.2/db_2/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";

--configure auxiliary channel device type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/u01/app/oracle/product/19.0.0.0/dbhome_1/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";

CONFIGURE DATAFILE BACKUP COPIES FOR DEVICE TYPE SBT_TAPE TO 1; 
CONFIGURE CHANNEL DEVICE TYPE 'SBT_TAPE' FORMAT   '%d_%U' PARMS  "SBT_LIBRARY=/data/PRODHR/oracle/product/12.1.0.2/db_2/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/data/PRODHR/oracle/product/12.1.0.2/db_2/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";




ls -lrth /u01/app/oracle/product/12.1.0.2/dbhome_1/lib/libra.so
/u01/app/oracle/product/12.1.0.2/dbhome_1/lib/libra.so
ls -lrth /u01/app/oracle/product/12.1.0.2/dbhome_1/dbs/zdlra/

/u01/app/oracle/product/12.1.0.2/dbhome_1/dbs/zdlra/cwallet.sso.lck
/u01/app/oracle/product/12.1.0.2/dbhome_1/dbs/zdlra/cwallet.sso

/home/habibrk


RMAN-00571: ===========================================================
RMAN-00569: =============== ERROR MESSAGE STACK FOLLOWS ===============
RMAN-00571: ===========================================================
RMAN-03002: failure of Duplicate Db command at 09/03/2021 00:10:05
RMAN-05501: aborting duplication of target database
RMAN-03009: failure of allocate command on ORA_AUX_SBT_TAPE_1 channel at 09/03/2021 00:10:05
ORA-19554: error allocating device, device type: SBT_TAPE, device name: 
ORA-27211: Failed to load Media Management Library
Additional information: 4058







rman auxiliary / catalog ravpc1/Welcome123@zdlra







ls -lrth /data/PRODHR/oracle/product/12.1.0.2/db_2/

note! kalau error, let it be
Example:

/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/zdlra/

 5. Duplicate Database
--RUNNING BACKGROUND
vi duplicate_TESTSCV.sh
chmod 777 duplicate_TESTSCV.sh
nohup ./duplicate_TESTSCV.sh &
------
export ORACLE_SID=TESTSCV
export ORACLE_HOME=/data/PRODHR/oracle/product/12.1.0.2/db_2
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
$ORACLE_HOME/bin/rman auxiliary / catalog ravpc1/Welcome123@zdlra trace=/home/oracle/ssi/TESTSCV/duplicate_opscvtbs02092021.log << EOF
run {
duplicate database OPSCV TO TESTSCV; 
}
exit
EOF
----------------


NOTE!
duplicate database OPSCVTBS TO TESTSCV;  
--target database using db name
SQL> show parameter db_name


Optional
show parameter pfile



6.CHANGE DATABASE_CLUSTERNYA to=TRUE
alter system set cluster_database=true scope=spfile sid='*';


7. CREATE PFILE from SPFILE
create pfile='/home/oracle/ssi/TESTSCV/pfile_OPSCVTEST_new.txt' from spfile;
create pfile='/home/oracle/ssi/slam/OPURPTRX14122021.txt' from spfile='+DATAC2/OPURPTRX/PARAMETERFILE/spfile.1773.1091235487';



8. ADD parameter berikut ke PFILE BARU
TESTSCV2.instance_name='TESTSCV2'
TESTSCV1.instance_name='TESTSCV'
TESTSCV2.instance_number=2
TESTSCV1.instance_number=1

9. CREATE SPFILE from PFILE
create spfile='+DATAC2/OPURPTRX/PARAMETERFILE/spfileOPURPTRX1.ora' from pfile='/home/oracle/ssi/slam/OPURPTRX14122021.txt';

srvctl modify database -d OPURPTRX -p '+DATAC2/OPURPTRX/PARAMETERFILE/spfileOPURPTRX1.ora'

note!
show parameter pfile --Check nama pfilenya
path spfile di sesuaikan di asm
create path PARAMETER kalau belum ada

10. SHUTDOWN DATABASE
SQL> SHUTDOWN IMMEDIATE;

11. STARTUP DATABASE
Startup;
