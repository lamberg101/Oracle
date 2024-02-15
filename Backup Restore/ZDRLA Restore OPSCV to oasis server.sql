Target Oasis
10.49.31.4
oracle/90oracle78

- cloning existing oracle home
- copy wallent and library nya
- pastikan conn string zdlra sudah ada di home baru
- allocate channel manual di script duplicate nya


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


cd /home/oracle/ssi/TESTSCV
vi pfile_OPSCVTEST_restore.txt


2. STARTUP NOMOUNT
startup nomount pfile='/home/oracle/ssi/TESTSCV/pfile_OPSCVTEST_restore.txt';



3. CONNECT TO CATALOG
rman auxiliary / catalog ravpc1/Welcome123@zdlra


4. CONFIGURE AUXILIARY CHANNEL
configure device type 'SBT_TAPE' PARALLELISM 4 BACKUP TYPE TO BACKUPSET;
configure auxiliary channel device type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/apps/oracle/product/12.1.0/dbhome_7/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/apps/oracle/product/12.1.0/dbhome_7/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";



5. RUNNING DUPLICATE
cd /home/oracle/ssi/TESTSCV/

export ORACLE_SID=TESTSCV
export ORACLE_HOME=/apps/oracle/product/12.1.0/dbhome_7
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
$ORACLE_HOME/bin/rman auxiliary / catalog ravpc1/Welcome123@zdlra debug trace=/home/oracle/ssi/TESTSCV/rman_29092021.trc  << EOF
run {
allocate auxiliary channel c1 type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/apps/oracle/product/12.1.0/dbhome_7/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/apps/oracle/product/12.1.0/dbhome_7/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";
allocate auxiliary channel c2 type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/apps/oracle/product/12.1.0/dbhome_7/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/apps/oracle/product/12.1.0/dbhome_7/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";
allocate auxiliary channel c3 type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/apps/oracle/product/12.1.0/dbhome_7/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/apps/oracle/product/12.1.0/dbhome_7/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";
allocate auxiliary channel c4 type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/apps/oracle/product/12.1.0/dbhome_7/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/apps/oracle/product/12.1.0/dbhome_7/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";
allocate auxiliary channel c5 type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/apps/oracle/product/12.1.0/dbhome_7/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/apps/oracle/product/12.1.0/dbhome_7/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";
allocate auxiliary channel c6 type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/apps/oracle/product/12.1.0/dbhome_7/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/apps/oracle/product/12.1.0/dbhome_7/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";
duplicate database OPSCV TO TESTSCV;
}
EOF
exit


====================================================================================================================================


cp /data/PRODHR/oracle/product/12.1.0.2/db_2/lib/libra.so /apps/oracle/product/12.1.0/dbhome_7/lib/
cp /data/PRODHR/oracle/product/12.1.0.2/db_2/dbs/zdlra/* /apps/oracle/product/12.1.0/dbhome_7/dbs/zdlra



ZDLRA =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = zdlra62-scan)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = zdlra)
    )
  )
