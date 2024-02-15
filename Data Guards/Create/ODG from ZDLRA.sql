Set up ODG OPIKNOWS

=======ON PRIMARY DATABASE========
1.SQL> select force_logging from v$database;

FOR
---
NO

SQL> alter database force logging;

Database altered.

SQL> select force_logging from v$database;

FOR
---
YES

2. SQL> select group#,THREAD#,bytes/1024/1024 "Size in MB" from v$log;

    GROUP#    THREAD# Size in MB
---------- ---------- ----------
	 1	    1	     200
	 2	    1	     200
	 3	    2	     200
	 4	    2	     200

SQL> select name from V$database;

NAME
---------
OPIKNOWS


####
craete standby redo log
####
alter database add standby logfile THREAD 1 
group 5 ('+DATAC2','+RECOC2') size 200M,
group 6 ('+DATAC2','+RECOC2') size 200M,
group 7 ('+DATAC2','+RECOC2') size 200M;
alter database add standby logfile THREAD 2 
group 8 ('+DATAC2','+RECOC2') size 200M,
group 9 ('+DATAC2','+RECOC2') size 200M,
group 10 ('+DATAC2','+RECOC2') size 200M;


3. add conn string 
OPIKNOWSTB =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = exa82absdp-scan1)(PORT = 1521))
    )
    (CONNECT_DATA =
        (SERVER = DEDICATED)
      (SERVICE_NAME = OPIKNOWSTB)
        (UR=A)
    )
  )


OPIKNOWSTB1 =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = exa82absdpdb01-vip.telkomsel.co.id)(PORT = 1521))
    )
    (CONNECT_DATA =
        (SERVER = DEDICATED)
      (SERVICE_NAME = OPIKNOWSTB)
        (SID = OPIKNOWSTB1)
        (UR=A)
    )
  )

OPIKNOWSTB2 =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = exa82absdpdb02-vip.telkomsel.co.id)(PORT = 1521))
    )
    (CONNECT_DATA =
        (SERVER = DEDICATED)
      (SERVICE_NAME = OPIKNOWSTB)
        (SID = OPIKNOWSTB2)
        (UR=A)
    )
  
OPIKNOWS =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = exapdb62b-scan)(PORT = 1521))
    )
    (CONNECT_DATA =
        (SERVER = DEDICATED)
      (SERVICE_NAME = OPIKNOWS)
        (UR=A)
    )
  )


OPIKNOWS1 =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = exa62pdb3-vip.telkomsel.co.id)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = OPIKNOWS)
      (SID = OPIKNOWS1)
      (UR = A)
    )
  )

OPIKNOWS2 =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = exa62pdb4-vip.telkomsel.co.id)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = OPIKNOWS)
      (SID = OPIKNOWS2)
      (UR = A)
    )
  )

  
4. create password file 

cd $ORACLE_HOME
/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs
orapwd file=orapwOPIKNOWS1 password=OR4cl35y5#2015 force=y

setelah di buat di copy ke node 2 & server exa82a (MAA)
scp orapwOPIKNOWS1 oracle@10.251.33.89:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/orapwOPIKNOWS2
scp orapwOPIKNOWS1 oracle@10.49.132.14:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/orapwOPIKNOWSTB1
scp orapwOPIKNOWS1 oracle@10.49.132.15:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/orapwOPIKNOWSTB2


5. Create directory on file system for dump trace and file db on ASM
- File system (both nodes)
cd /u01/app/oracle/admin/
mkdir OPIKNOWSTB
cd OPIKNOWSTB
mkdir adump bdump cdump udump

- on ASM
asmcmd
cd +DATA1/
mkdir OPIKNOWSTB
cd OPIKNOWSTB
mkdir PARAMETERFILE DATAFILE CONTROLFILE TEMPFILE ONLINELOG
cd ../..
cd +RECO1/
mkdir OPIKNOWSTB
cd OPIKNOWSTB
mkdir CONTROLFILE ONLINELOG

6. Create pfile dan configure untuk database primary  
---Backup spfile first
create pfile='/home/oracle/ssi/slam/pfile_OPIKNOWS_26012022.txt' from spfile;

alter system set LOG_ARCHIVE_CONFIG='DG_CONFIG=(OPIKNOWS,OPIKNOWSTB)' sid='*' scope=both;
alter system set LOG_ARCHIVE_DEST_1='LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=OPIKNOWS' sid='*' scope=both;
alter system set LOG_ARCHIVE_DEST_2='SERVICE=OPIKNOWSTB1 ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=OPIKNOWSTB' sid='*' scope=both;
alter system set LOG_ARCHIVE_DEST_STATE_1=ENABLE sid='*' scope=both;
alter system set LOG_ARCHIVE_DEST_STATE_2=DEFER sid='*' scope=both;
alter system set LOG_ARCHIVE_MAX_PROCESSES=30 sid='*' scope=both;
alter system set FAL_CLIENT='OPIKNOWS' sid='*' scope=both;
alter system set FAL_SERVER='OPIKNOWSTB' sid='*' scope=both;
alter system set STANDBY_FILE_MANAGEMENT=AUTO sid='*' scope=both;

Di primary backup/create pfile dan configure untuk database standby 
7.create pfile='/home/oracle/ssi/slam/pfile_OPIKNOWS.txt' from spfile;
============= pada server standby ========

1. buat pfile hanya dengan memasukan parameter db_name

*.db_name='OPIKNOW'
*.db_unique_name='OPIKNOWSTB'
-- add parameter sga/pga as is primary if error
*.pga_aggregate_target=2000m
*.sga_target=7008m

2. Create profile di server standby :
node1:
vi .OPIKNOWSTB1
export ORACLE_SID=OPIKNOWSTB1
export ORACLE_HOME=/u01/app/oracle/product/19.0.0.0/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib

node2:
vi .OPIKNOWSTB2
export ORACLE_SID=OPIKNOWSTB2
export ORACLE_HOME=/u01/app/oracle/product/19.0.0.0/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib

2.startup nomount
startup nomount pfile='/home/oracle/opiknowstb.txt';

3.masuk ke rman menggunakan user backup
rman target backup_admin/Welcome123 catalog ravpc1/Welcome123@zdlra

RMAN > List db_unique_name all;
RMAN > set dbid 2519466144;
RMAN> LIST BACKUP OF CONTROLFILE;

run {
allocate channel oem_sbt_backup type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/u01/app/oracle/product/19.0.0.0/dbhome_1/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";
restore CONTROLFILE from tag 'TAG20220125T060211';
release channel oem_sbt_backup;
}

4. Copy output control file to asm
/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/cntrlOPIKNOWSTB1.dbf

. .grid_profile
asmcmd
cd +DATA1/OPIKNOWSTB/CONTROLFILE
cp /u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/cntrlOPIKNOWSTB1.dbf cntrlOPIKNOWSTB1.dbf
cd +RECO1/OPIKNOWSTB/CONTROLFILE
cp /u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/cntrlOPIKNOWSTB1.dbf cntrlOPIKNOWSTB1.dbf

channel oem_sbt_backup: starting datafile backup set restore
channel oem_sbt_backup: restoring control file
channel oem_sbt_backup: reading from backup piece c-2519466144-20220125-00
channel oem_sbt_backup: piece handle=c-2519466144-20220125-00 tag=TAG20220125T060211
channel oem_sbt_backup: restored backup piece 1
channel oem_sbt_backup: restore complete, elapsed time: 00:00:01
output file name=/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/cntrlOPIKNOWSTB1.dbf
Finished restore at 26-JAN-22

4. Shutdown standby database
shutdown immediate;

5. Edit pfile
sesuaikan dengan parameter dari primary

6.startup nomount
startup nomount pfile='/home/oracle/ssi/slam/pfile_OPIKNOWSTB_26012022.txt';

7.rubah database menjadi mount

SQL>  alter database mount;


8. CROSCHECK BACKUP , RESTORE DAN RECOVER 

Crosscheck backup, Restore Database dan Recover Database

RMAN > crosscheck backup;

6.
vi restore_OPIKNOWS.sh
export ORACLE_SID=OPIKNOWSTB1
export ORACLE_HOME=/u01/app/oracle/product/19.0.0.0/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
$ORACLE_HOME/bin/rman target backup_admin/Welcome123 catalog ravpc1/Welcome123@zdlra debug trace=/home/oracle/ssi/rman_OPIKNOWS_ODG.trc  << EOF
run {
allocate channel c1 type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/u01/app/oracle/product/19.0.0.0/dbhome_1/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";
allocate channel c2 type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/u01/app/oracle/product/19.0.0.0/dbhome_1/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";
allocate channel c3 type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/u01/app/oracle/product/19.0.0.0/dbhome_1/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";
allocate channel c4 type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/u01/app/oracle/product/19.0.0.0/dbhome_1/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";
allocate channel c5 type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/u01/app/oracle/product/19.0.0.0/dbhome_1/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";
allocate channel c6 type 'sbt_tape' format '%d_%U' parms "SBT_LIBRARY=/u01/app/oracle/product/19.0.0.0/dbhome_1/lib/libra.so, SBT_PARMS=(RA_WALLET='location=file:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/zdlra credential_alias=zdlra62-scan:1521/zdlra:dedicated')";
SET NEWNAME FOR DATABASE to new;
SET NEWNAME FOR tempfile 1 to new;
RESTORE DATABASE;
RECOVER DATABASE;
}
EOF
exit

nohup ./restore_OPIKNOWS.sh &

7. Shutdown database standby

8. CREATE STANDBY CONTROL FILE
create control standby dari primary
SQL> ALTER DATABASE CREATE STANDBY CONTROLFILE AS '/home/oracle/ssi/OPIKNOWSTB_stby.ctl';

9. Copy to standby
- copy to ASM
. .grid_profile
asmcmd
cd +DATA1/OPIKNOWSTB/CONTROLFILE
cp /home/oracle/ssi/slam/OPIKNOWSTB_stby.ctl OPIKNOWSTB_stby.ctl
cd +RECO1/OPIKNOWSTB/CONTROLFILE
cp /home/oracle/ssi/slam/OPIKNOWSTB_stby.ctl OPIKNOWSTB_stby.ctl

10. Edit pfile dan arahkan control file dari step 8
create spfile from pfile='/home/oracle/ssi/slam/pfile_OPIKNOWSTB_26012022.txt';

11. Startup mount

alter system set standby_file_management=auto scope=both sid='*'


