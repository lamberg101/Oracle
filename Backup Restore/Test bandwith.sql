
Note!
--Pastikan library dan wallet nya sudah sesuai
--Troubleshooting ZDLRA Network Connectivity Issues (Doc ID 2721330.1)

--
SQL> startup nomount pfile='/home/oracle/ssi/TESTPOIN/pfile_TESTPOIN_restore.txt';

[oracle@exa62pdb1-mgt ~]$ rman target /

RMAN> run {
allocate channel channel_01 DEVICE TYPE 'SBT_TAPE' FORMAT '%d_%U' PARMS "SBT_LIBRARY=/u01/app/oracle/product/19.0.0.0/dbhome_1/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/zdlra credential_alias=zdlrabsda-scan:1521/rabsdp:dedicated')";
send channel channel_01 'NETTEST BACKUP 1024M';
}


RMAN> run {
allocate channel channel_01 DEVICE TYPE 'SBT_TAPE' FORMAT '%d_%U' PARMS "SBT_LIBRARY=/u01/app/oracle/product/19.0.0.0/dbhome_1/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/zdlra credential_alias=zdlrabsda-scan:1521/rabsdp:dedicated')";
send channel channel_01 'NETTEST RESTORE 1024M';  
}