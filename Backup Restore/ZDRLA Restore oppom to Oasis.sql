Target Oasis
10.49.31.4
oracle/90oracle78

1. CREATE PFILE
*.db_name=TESODPOM
*.db_unique_name=TESODPOM
*.pga_aggregate_target=20G
*.sga_target=20G
*.db_create_file_dest='/DBUPGRADE/TESODPOM' --create dir nya dulu
*.db_recovery_file_dest_size=500G
*.compatible='12.1.0.2.0'
*.db_recovery_file_dest='/DBUPGRADE/TESODPOM/FRA' --create dir nya dulu
*.db_files=1024

cd /home/oracle/ssi/TESODPOM
vi pfile_TESODPOM.txt

2. STARTUP NOMOUNT
startup nomount pfile='/home/oracle/ssi/TESODPOM/pfile_TESODPOM.txt';

3. CONNECT TO CATALOG
rman auxiliary / catalog ravpc1/Welcome123@zdlra

4. CONFIGURE AUXILIARY CHANNEL
configure device type 'SBT_TAPE' PARALLELISM 4 BACKUP TYPE TO BACKUPSET;
configure auxiliary channel device type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/apps/oracle/product/12.1.0/dbhome_7/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/apps/oracle/product/12.1.0/dbhome_7/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";


5. RUNNING DUPLICATE
vi duplicate_oppom_tesodpom.sh
----------------------------
export ORACLE_SID=TESODPOM
export ORACLE_HOME=/apps/oracle/product/12.1.0/dbhome_7
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
$ORACLE_HOME/bin/rman auxiliary / catalog ravpc1/Welcome123@zdlra debug trace=/home/oracle/ssi/TESODPOM/rman_30092021.trc  << EOF
run {
allocate auxiliary channel c1 type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/apps/oracle/product/12.1.0/dbhome_7/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/apps/oracle/product/12.1.0/dbhome_7/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";
allocate auxiliary channel c2 type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/apps/oracle/product/12.1.0/dbhome_7/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/apps/oracle/product/12.1.0/dbhome_7/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";
allocate auxiliary channel c3 type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/apps/oracle/product/12.1.0/dbhome_7/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/apps/oracle/product/12.1.0/dbhome_7/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";
allocate auxiliary channel c4 type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/apps/oracle/product/12.1.0/dbhome_7/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/apps/oracle/product/12.1.0/dbhome_7/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";
allocate auxiliary channel c5 type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/apps/oracle/product/12.1.0/dbhome_7/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/apps/oracle/product/12.1.0/dbhome_7/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";
allocate auxiliary channel c6 type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/apps/oracle/product/12.1.0/dbhome_7/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/apps/oracle/product/12.1.0/dbhome_7/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";
duplicate database OPPOM TO TESODPOM;
}
EOF
exit

---------------------------------

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


