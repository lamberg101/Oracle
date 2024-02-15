RMAN> restore controlfile from '/home/oracle/ssi/slam/OPUIMIMC/OPUIMTBS_stby.ctl';
RMAN> alter database mount;

3. Crosscheck and delete expired archivelog & backup
RMAN> crosscheck backup;
RMAN> delete noprompt expired backup;
RMAN> crosscheck backup;
RMAN> crosscheck archivelog all;
RMAN> delete noprompt expired archivelog all;

4.  catalog start with 'pindahin ke 1 folder';

5. run script
bash 

export ORACLE_SID=OPUIMIMC1
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
$ORACLE_HOME/bin/rman target / trace=/home/oracle/OPUIMIMC.log << EOF
CONFIGURE DEVICE TYPE DISK PARALLELISM 10 BACKUP TYPE TO BACKUPSET;
run  {
set newname for database to '+DATAIMC';
restore database;
switch datafile all;
}

6. . Di server standby, setelah selesai duplikat database standby, Check status database standby di node 1 
SQL> select name, database_role from v$database;

7. Di server standby, modify pfile, dan kemudian create spfile from pfile (Step ini belum)
- Create spfile from pfile:
SQL> create spfile='+DATAIMC/OPUIMIMC/PARAMETERFILE/spfileOPUIMIMC.ora' from pfile='/home/oracle/ssi/slam/OPUIMIMC/pfile_OPUIMIMC.txt';


15. Di server standby, Shutdown database di node 1 (Step ini belum)
SQL> shutdown immediate;

16. Di server standby, Register Standby Database Resources with Clusterware (Step ini belum)
. .OPUIMIMC_profile
$ srvctl add database -d OPUIMIMC -o /u01/app/oracle/product/12.1.0.2/dbhome_1
$ srvctl add instance -d OPUIMIMC -i OPUIMIMC1 -n exaimcpdb01-mgt
$ srvctl add instance -d OPUIMIMC -i OPUIMIMC2 -n exaimcpdb02-mgt.
$ srvctl modify database -d OPUIMIMC -r physical_standby
$ srvctl modify database -d OPUIMIMC -p '+DATAIMC/OPUIMIMC/PARAMETERFILE/spfileOPUIMIMC.ora'

17. Di server standby, Start standby database (Step ini belum)
$ srvctl start database -d OPUIMIMC -o mount

18. Di server primary, ENABLE status LOG_ARCHIVE_DEST_STATE_2  (Step ini belum)
ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_2 = ENABLE SID='*' scope=both;

19. Di server standby, Enable MRP dan recover database (Step ini belum)
alter database recover managed standby database using current logfile disconnect;