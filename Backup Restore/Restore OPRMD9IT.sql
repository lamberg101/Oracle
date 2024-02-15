**Restore DB ke backup terakhir (tanggal 18 september)**


1. BACKUP PFILE 
SQL> create pfile='/home/oracle/ssi/slam/OPRMD9IT1/oprmd9it_pfile_23092020.txt' from spfile;

2. DROP DB --using DBCA
- Setelah drop database, Check dir sesuai di bawah, kalau belum ada create.
- Kalau sudah ada, drop archive nya --biasanya archive nya masih ada di +RECOC5/

#ASM --jika folder di asm sudah ada tidak perlu di buat kembali
. .grid_profile
asmcmd
cd +DATAC5/
mkdir OPRMD9IT
cd OPRMD9IT
mkdir PARAMETERFILE DATAFILE CONTROLFILE TEMPFILE ONLINELOG
cd ../..
cd +RECOC5/
mkdir OPRMD9IT
cd OPRMD9IT
mkdir CONTROLFILE ONLINELOG


3.STARTUP NOMOUNT OPRMD9IT
SQL> startup nomount pfile ='/home/oracle/ssi/slam/OPRMD9IT1/oprmd9it_pfile_23092020.txt';


4. CREATE SPFILE FROM PFILE
SQL> create spfile='+DATAC5/OPRMD9IT/PARAMETERFILE/spfileOPRMD9IT.ora' from pfile='/home/oracle/ssi/slam/OPRMD9IT1/oprmd9it_pfile_23092020.txt';


5.RESTORE CONTROL FILE === backup control file nya kaga dipisah 
RMAN> restore controlfile from '/datadump16/oprmd9it/db/xxxxxxxxx';
/datadump6/oprmd9it/db/OPREMEDY_db_20200918_a4vanigj_1_1.bk

6. ALTER DATABASE MOUNT
RMAN> alter database mount;


8. CROSSHCheck BACKUP --hasil backup dipindah ke dalam satu folder lalu jalankan catalog

#CATALOG -- Check dir all arch nya, lalu jalankan catalog, satu per satu.

RMAN> catalog start with '/datadump6/oprmd9it/db/';
RMAN> catalog start with '/datadump2/oprmd9it/db/';
RMAN> catalog start with '/datadump10/oprmd9it/db/';
RMAN> catalog start with '/datadump16/oprmd9it/db/';
RMAN> catalog start with '/datadump14/oprmd9it/db/';
RMAN> catalog start with '/datadump8/oprmd9it/db/';
RMAN> catalog start with '/datadump12/oprmd9it/db/';
RMAN> catalog start with '/datadump4/oprmd9it/db/';
RMAN> catalog start with '/datadump2/oprmd9it/arch/';
RMAN> catalog start with '/datadump4/oprmd9it/arch/';
RMAN> catalog start with '/datadump6/oprmd9it/arch/';
RMAN> catalog start with '/datadump8/oprmd9it/arch/';
RMAN> catalog start with '/datadump10/oprmd9it/arch/';
RMAN> catalog start with '/datadump12/oprmd9it/arch/';
RMAN> catalog start with '/datadump14/oprmd9it/arch/';
RMAN> catalog start with '/datadump16/oprmd9it/arch/';


$ vi crosscheck.sh
export ORACLE_SID=OPRMD9IT1
export ORACLE_HOME=/u01/app/oracle/product/11.2.0.4/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
$ORACLE_HOME/bin/rman target / trace=/home/oracle/ssi/slam/OPRMD9IT1/OPRMD9IT_23092020_CATALOG.log << EOF
run  {
crosscheck backup;
crosscheck archivelog all;
}

$ chmod 777 crosscheck.sh
$ ./crosscheck.sh 

Note! setelah selesai, jalankan 
RMAN> delete expired backup


9. RESTORE DATABASE
$ vi restore.sh
export ORACLE_SID=OPRMD9IT1
export ORACLE_HOME=/u01/app/oracle/product/11.2.0.4/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
$ORACLE_HOME/bin/rman target / trace=/home/oracle/ssi/slam/OPRMD9IT1/OPRMD9IT_23092020_restore.log << EOF
run  {
restore database;
recover database;
}

$ chmod 777 restore.sh
$ nohup ./restore.sh &

Note! 
- pantau process restore dari log atau longops
- kalau Check backup (RMAN> list backup) dan arhc belum ada, maka catalog per directory

10. OPEN RESETLOGS
RMAN> alter database open resetlogs;


11. MATIKAN DB OPRMD9IT
SQL> shutdown immediate;


12. REGISTER DATABASE OPRMD9IT
$ srvctl add database -d OPRMD9IT-o /u01/app/oracle/product/11.2.0.4/dbhome_1
$ srvctl add instance -d OPRMD9IT-i OPRMD9IT1-n exa62tbspdb1-mgt
$ srvctl add instance -d OPRMD9IT-i OPRMD9IT2-n exa62tbspdb12-mgt
$ srvctl modify database -d OPRMD9IT -p '+DATAC5/OPRMD9IT/PARAMETERFILE/spfileOPRMD9IT.ora'


13. START DATABASE
$ srvctl status database -d OPRMD9IT
$ srvctl start database -d OPRMDOIT
$ srvctl status database -d OPRMD9IT