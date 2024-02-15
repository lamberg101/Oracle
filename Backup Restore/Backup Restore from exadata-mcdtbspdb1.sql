requiset backup server mcdpdbtbs1 - 10.2.230.105:
user    : oracle
ip      : 10.2.230.105
pass    : 90oracle78

*** Matiin dulu yang ODESB12 nya

------------------------------------------------------------------------------------------------------------

--START PFILE
** create pfile nya dulu kalau belum ada
** rubah file2 parameter nya, sesuaikan dengan env di mcdpdbtbs1
startup mount pfile='/home/oracle/ssi/slam/opesbtbs/pfile_27112020.txt';

------------------------------------------------------------------------------------------------------------

--RESTORE CONTROLE FILE
-control from backup : /datadump16/opesb/db/control_xxxx.bk
-restore controfile from '/datadump16/opesb/db/control_xxxx.bk';

------------------------------------------------------------------------------------------------------------

--CROSSCHECK AND DELETE EXPIRED ARCHIVELOG
RMAN> crosscheck archivelog all;
RMAN> delete noprompt expired archivelog all;
RMAN> crosscheck archivelog all;
sqlplus /nolog

------------------------------------------------------------------------------------------------------------

--SET CATALOG BACKUP
RMAN >
catalog start with '/datadump1/opesb/db/' noprompt;
catalog start with '/datadump3/opesb/db/' noprompt;
catalog start with '/datadump5/opesb/db/' noprompt;
catalog start with '/datadump7/opesb/db/' noprompt;
catalog start with '/datadump9/opesb/db/' noprompt;
catalog start with '/datadump11/opesb/db/' noprompt;
catalog start with '/datadump13/opesb/db/' noprompt;
catalog start with '/datadump15/opesb/db/' noprompt;
catalog start with '/datadump1/opesb/arch/' noprompt;
catalog start with '/datadump3/opesb/arch/' noprompt;
catalog start with '/datadump5/opesb/arch/' noprompt;
catalog start with '/datadump7/opesb/arch/' noprompt;
catalog start with '/datadump9/opesb/arch/' noprompt;
catalog start with '/datadump11/opesb/arch/' noprompt;
catalog start with '/datadump13/opesb/arch/' noprompt;
catalog start with '/datadump15/opesb/arch/' noprompt;


------------------------------------------------------------------------------------------------------------

--RESTORE DATABASE
cd /home/oracle/
nohup bash -x restore_new.sh &
----------------------------------------
export ORACLE_HOME=/u02/app/oracle/product/12.1.0/dbhome_10
export ORACLE_SID=ODESB12
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/OPatch:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
$ORACLE_HOME/bin/rman target / trace=/apps/oracle/restore_OPESB.log << EOF
CONFIGURE DEVICE TYPE DISK PARALLELISM 5 BACKUP TYPE TO BACKUPSET;
run{
run  
 {
	set newname for datafile '+DATAC5/OPESB/DATAFILE/system.4425.1005670155' to '/data/ODESB12/datafile/%b';
	set newname for datafile '+DATAC5/OPESB/DATAFILE/sysaux.4924.1005670157' to '/data/ODESB12/datafile/%b';
	.....
	set newname for datafile '+DATAC5/OPESB/DATAFILE/data_track_login.1847.1043652379' to '/data/ODESB12/datafile/%b';
restore database;
switch datafile all;
} 


------------------------------------------------------------------------------------------------------------

--RECOVER DATABASE;
RMAN> recover database;

------------------------------------------------------------------------------------------------------------

--ALTER DATABASE OPEN RESETLOGS;
RMAN> alter database open resetlogs;
RMAN> exit

