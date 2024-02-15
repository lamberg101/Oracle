SYNC GAP dengan restore SCN apabila archive fisik sudah tidak ada di PRIMARY sedangkan STANDBY masih membutuhkan archive tsb.

** Masuk ke masing-masing profile DB

1. Check GAP terlebih dahulu di PRIMARY

HASIL :
   DEST_ID    THREAD#	 PRIMARY  MAXTRANSF    STANDBY MINTRANSF_GAP  APPLY_GAP   HOURSGAP
---------- ---------- ---------- ---------- ---------- ------------- ---------- ----------
	 2	    	1		  161978     161978		159384		   0	   2594        212
	 3	    	1		  161978     161978		161978		   0	      0 	 	0
	 2	    	2		   61877      61877		 59847		   0	   2030        212
	 3	    	2		   61877      61877		 61877		   0	      0 	 	0


2. Check SCN di PRIMARY dan STANDBY

col current_scn format 99999999999999999
select current_scn from v$database;

HASIL :
** PRIMARY
       CURRENT_SCN
------------------
    15811243178339

** STANDBY
       CURRENT_SCN
------------------
    15805420630913

3. Jika ada berbedaan SCN tsb, lanjut STOP MRP di standby dan restart db STANDBY

SQL> alter database recover managed standby database cancel;
SQL> exit


4. Backup SCN di PRIMARY lewat RMAN, masukkan SCN nya berdasarkan current_scn di STANDBY
$> . .OPUIMTBS_profile
Jalankan lewat nohup !!

Backup_SCN.sh

echo '======================================='
export ORACLE_SID=OPUIMTBS1
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2/dbhome_1
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/jdk/jre/bin:$PATH

$ORACLE_HOME/bin/rman target / nocatalog trace=/home/oracle/script/backup/log/OPUIMTBS_SCN_BACKUP.trc << EOF
run
{
allocate channel ch01 device type disk format '/datadump9/opuimtbs/Backup_Scn/%d_SCN_BAK_%T_%U.bk';
backup incremental from scn 15805420630913 database; 
release channel ch01;
}
exit
EOF


*** Jika sudah selesai ubah chmod ***
$> cd datadump9/opuimtbs/
$> chmod -R 777 Backup_Scn/


5. Buat standby controlfile di PRIMARY, lalu startup di STANDBY.

PRIMARY :
SQL> alter database create standby controlfile as '/home/oracle/ssi/slam/OPUIMTBS/opuimtbs_stby.ctl';

** scp ke server STANDBY 
$> cd /home/oracle/ssi/slam/OPUIMTBS/
scp opuimtbs_stby.ctl oracle@10.250.192.181:/home/oracle/ssi/slam/OPUIMIMC/

6. Simpan nama-nama datafile yang pada database STANDBY, dikarenakan nama path datafile di PRIMARY dan STANDBY berbedaan
$> . .OPUIMIMC_profile
$> cd /home/oracle/ssi/slam/OPUIMIMC/
$> sqlplus / as sysdba
spool datafile_names_OPUIMIMC.txt
set lines 200
col name format a60
select file#, name from v$datafile order by file#;
spool off

6. Matikan STANDBY DATABASE untuk fresh startup mount dari STANDBY controlfile baru
$> . .OPUIMIMC_profile
$> srvctl status database -d OPUIMIMC
$> srvctl stop database -d OPUIMIMC
$> srvctl status database -d OPUIMIMC
$> date

   *** Move standby control lama di STANDBY ASM ke file system
$> .grid_profile
$> asmcmd
ASM> cd +DATAIMC/OPUIMIMC/CONTROLFILE
ASM> mv OPUIMIMC_stby.ctl OPUIMIMC_stby.ctl_old

   *** Move standby control baru di STANDBY ke ASM
$> .grid_profile
$> asmcmd
ASM> cd +DATAIMC/OPUIMIMC/CONTROLFILE
ASM> cp /home/oracle/ssi/slam/OPUIMIMC/opuimtbs_stby.ctl +DATAIMC/OPUIMIMC/CONTROLFILE/opuimimc_stby.ctl --sesuaikan dengan parameter control 
    
   *** masih di STANDBY Masuk ke SQLPLUS rebound database ke status mount
$>  . .OPUIMIMC_profile
--$> sqlplus / as sysdba
--SQL> startup nomount
--SQL> exit
--$> srvctl config database -d OPUIMIMC
--$> srvctl modify database -d OPUIMIMC -r physical_standby
$> srvctl start database -d OPUIMIMC -o mount
--$> sqlplus / as sysdba
--SQL> alter database mount standby database;

8. Restore catalog backup di Standby

Jalankan lewat nohup !!

Restore_SCN.sh

echo '======================================='
export ORACLE_SID=OPUIMIMC1
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH

$ORACLE_HOME/bin/rman target / nocatalog trace=/home/oracle/script/backup/log/OPUIMIMC_SCN_RESTORE.trc << EOF
run
{
CATALOG START WITH '/zfssa/testet/backup9/opuimtbs/Backup_Scn/' noprompt;
RECOVER DATABASE NOREDO; 
}
exit
EOF



9. Ubah catalog sesuai nama datafile semula di server STANDBY dan recover
$> . .OPUIMIMC_profile
Jalankan lewat nohup !!

Catalog_Standby.sh

echo '======================================='
export ORACLE_SID=OPUIMIMC1
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH

$ORACLE_HOME/bin/rman target / nocatalog trace=/home/oracle/script/backup/log/OPUIMIMC_CATALOG_BACKUP.trc << EOF
run
{
CATALOG START WITH '+DATAIMC/OPUIMIMC/DATAFILE/' noprompt;
}
exit
EOF



10. Setelah selesai catalog, Check datafile perubahan setelah restore
SQL>SELECT FILE#, NAME FROM V$DATAFILE WHERE CREATION_CHANGE# > 15641412426525;

*** Jika query nya "no row" lanjutkan untuk switch copy
Jalankan lewat nohup !!

Switch_Copy_Standby.sh

echo '======================================='
export ORACLE_SID=OPUIMIMC1
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH

$ORACLE_HOME/bin/rman target / nocatalog trace=/home/oracle/script/backup/log/OPUIMIMC_SWITCH_DATAFILE.trc << EOF
run
{
SWITCH DATABASE TO COPY;
}
exit
EOF

11. Jalankan MRP di STANDBY
$> . .OPUIMIMC_profile
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DISCONNECT;

*** Check gap, Check current_scn di PRIMARY dan STANDBY, seharusnya tidak beda jauh ***
 