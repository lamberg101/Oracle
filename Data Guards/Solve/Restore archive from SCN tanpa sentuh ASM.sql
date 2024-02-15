Note!
SYNC GAP dengan restore SCN 
apabila archive fisik sudah tidak ada di PRIMARY 
sedangkan STANDBY masih membutuhkan archive tsb.

---------------------------------------------------------------------------------------------------

1. Check GAP terlebih dahulu di PRIMARY (Exa62b - OPUIMTBS)
HASIL :
   DEST_ID    THREAD#	 PRIMARY  MAXTRANSF    STANDBY MINTRANSF_GAP  APPLY_GAP   HOURSGAP
---------- ---------- ---------- ---------- ---------- ------------- ---------- ----------
	 2	    1	  162117     162117	159384		   0	   2733        250
	 3	    1	  162222     162222	162222		   0	      0 	 0
	 2	    2	   62076      62076	 59847		   0	   2229        250
	 3	    2	   62201      62201	 62201		   0	      0 	 0


2. Check SCN di PRIMARY dan STANDBY

col current_scn format 999999999999999
select current_scn from v$database;

Untuk standby jalankan juga query ini :
col min(checkpoint_change#) for 999999999999999
select min(checkpoint_change#) from v$datafile_header 
where file# not in (select file# from v$datafile where enabled = 'READ ONLY');

HASIL :
** PRIMARY (exa62b - OPUIMTBS)

     CURRENT_SCN
----------------
  15812677465007

** STANDBY (exaIMC - OPUIMIMC)

     CURRENT_SCN
----------------
  15812276382990

  MIN(CHECKPOINT_CHANGE#)
-----------------------
	 15805420630914

*** ambil yang paling kecil yakni :  15805420630914  


   3. Jika ada berbedaan SCN tsb, lanjut STOP MRP di standby dan restart db STANDBY (exaIMC - OPUIMIMC)

SQL> alter database recover managed standby database cancel;
SQL> exit

***** Di PRIMARY (exa62b - OPUIMTBS), defer log archive dest nya
SQL> alter system set log_archive_dest_state_2=DEFER scope=both sid='*';

4. Backup SCN di PRIMARY (exa62b - OPUIMTBS) lewat RMAN, masukkan SCN nya berdasarkan current_scn di STANDBY (exaIMC - OPUIMIMC)
   *** Kurleb sekitar 3 jam backup

$> . .OPUIMTBS
Jalankan lewat nohup !!

$> cd /home/oracle/script/OPUIMTBS
$> vi Backup_SCN_OPUIMTBS.sh
$> nohup sh Backup_SCN_OPUIMTBS.sh > Backup_SCN_OPUIMTBS.log &

echo '======================================='
export ORACLE_SID=OPUIMTBS1
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2/dbhome_1
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/jdk/jre/bin:$PATH

$ORACLE_HOME/bin/rman target / nocatalog trace=/home/oracle/script/OPUIMTBS/OPUIMTBS_SCN_BACKUP.trc << EOF
run
{
allocate channel ch01 device type disk format '/datadump9/opuimtbs/Backup_SCN_OPUIMIMC_NEW/%d_SCN_BAK_%T_%U.bk';
backup incremental from scn 15805420630914 database; 
release channel ch01;
}
exit
EOF


*** Jika sudah selesai ubah chmod :
$> cd /datadump9/opuimtbs/
$> chmod -R 777 Backup_SCN_OPUIMIMC_NEW/

5. Buat standby controlfile di PRIMARY (exa62b - OPUIMTBS), lalu startup di standby (exaIMC - OPUIMIMC)

PRIMARY :
SQL> alter database create standby controlfile as '/home/oracle/script/OPUIMTBS/OPUIMIMC_stby.bck';
** scp ke server standby '/home/oracle/script/OPUIMIMC/OPUIMIMC_stby.bck'
$> cd /home/oracle/script/OPUIMTBS/
$> chmod 777 OPUIMIMC_stby.bck
$> scp OPUIMIMC_stby.bck oracle@10.250.192.181:/home/oracle/script/OPUIMIMC/

6. Simpan nama-nama datafile yang pada database STANDBY, dikarenakan nama path datafile di primary dan standby berbedaan
$> cd /home/oracle/script/OPUIMTBS/
$> . .OPUIMTBS
$> sqlplus / as sysdba
spool datafile_names_OPUIMTBS.txt
set lines 200
col name format a60
select file#, name from v$datafile order by file#;
spool off

7. Restore catalog backup di Standby (exaIMC - OPUIMIMC)

***Tambahan, jalankan berikut agar config rman tidak berjalan ke zdlra
$> RMAN TARGET /
RMAN> CONFIGURE CHANNEL DEVICE TYPE 'SBT_TAPE' CLEAR;
RMAN> CONFIGURE DEVICE TYPE 'SBT_TAPE' CLEAR
***

Jalankan lewat nohup !!

$> cd /home/oracle/script/OPUIMIMC
$> vi Restore_SCN.sh
$> nohup Restore_SCN.sh > Restore_SCN.log &

echo '======================================='
export ORACLE_SID=OPUIMIMC1
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH

$ORACLE_HOME/bin/rman target / nocatalog trace=/home/oracle/script/OPUIMIMC/OPUIMIMC_SCN_RESTORE.trc << EOF
run
{
CATALOG START WITH '/zfssa/testet/backup9/opuimtbs/Backup_SCN_OPUIMTBS_NEW/' noprompt;
RECOVER DATABASE NOREDO; 
}
exit
EOF

8. Matikan standby database (exaIMC - OPUIMIMC) untuk fresh startup mount dari standby controlfile baru

$> . .OPUIMIMC
$> srvctl status database -d OPUIMIMC
$> srvctl stop database -d OPUIMIMC
$> srvctl status database -d OPUIMIMC
$> date

   *** Masuk ke RMAN restore controlfile
$> . .OPUIMIMC
$> srvctl start database -db OPUIMIMC -startoption "NOMOUNT"
$> rman target /
RMAN> RESTORE STANDBY CONTROLFILE FROM '/home/oracle/script/OPUIMIMC/OPUIMIMC_stby.bck';
RMAN> exit
$> srvctl stop database -d OPUIMIMC
$> srvctl start database -d OPUIMIMC -o mount

   *** Ubah dulu beberapa parameter di rman karena setelah restore controlfile akan mengikut primary
$> rman target /
RMAN> CONFIGURE CHANNEL DEVICE TYPE 'SBT_TAPE' CLEAR;
RMAN> CONFIGURE DEVICE TYPE 'SBT_TAPE' CLEAR;
RMAN< CONFIGURE SNAPSHOT CONTROLFILE NAME TO '+RECOIMC/OPUIMIMC/snapcf_OPUIMIMC1.f';
RMAN> EXIT

9. Ubah catalog sesuai nama datafile semula di server STANDBY (exaIMC - OPUIMIMC) dan recover

$> . .OPUIMIMC
Jalankan lewat nohup !!

$> cd /home/oracle/script/OPUIMIMC/
$> vi Catalog_Standby.sh
$> nohup sh Catalog_Standby.sh > Catalog_Standby.log &

echo '======================================='
export ORACLE_SID=OPUIMIMC1
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH

$ORACLE_HOME/bin/rman target / nocatalog trace=/home/oracle/script/OPUIMIMC/OPUIMTBS_CATALOG_BACKUP.trc << EOF
run
{
CATALOG START WITH '+DATAIMC/OPUIMIMC/DATAFILE/' noprompt;
}
exit
EOF

***************
*********** (OPTIONAL, Check saja standby redolog)
@@@@ Add standby redolog (rumus standby redolog yakni = Jumlah Online Redolog + 1)
alter database add standby logfile thread 1 group 26 ('+DATAIMC','+RECOIMC') size 1G,
group 27 ('+DATAIMC','+RECOIMC') size 1G,
group 28 ('+DATAIMC','+RECOIMC') size 1G,
group 29 ('+DATAIMC','+RECOIMC') size 1G,
group 30 ('+DATAIMC','+RECOIMC') size 1G,
group 31 ('+DATAIMC','+RECOIMC') size 1G;

alter database add standby logfile thread 2 group 32 ('+DATAIMC','+RECOIMC') size 1G,
group 33 ('+DATAIMC','+RECOIMC') size 1G,
group 34 ('+DATAIMC','+RECOIMC') size 1G,
group 35 ('+DATAIMC','+RECOIMC') size 1G,
group 36 ('+DATAIMC','+RECOIMC') size 1G,
group 37 ('+DATAIMC','+RECOIMC') size 1G;

10. Setelah selesai catalog, switch database to copy pada standby OPUIMIMC

$> RMAN TARGET /
RMAN> SWITCH DATABASE TO COPY;

11. Clearing Redolog Standby di server STANDBY (exaIMC - OPUIMIMC)
$> . .OPUIMIMC
$> sqlplus / as sysdba
SQL> select GROUP# from v$logfile where TYPE='STANDBY' group by GROUP#;
SQL> ALTER DATABASE CLEAR LOGFILE GROUP . . . . . .;

12. Jalankan MRP di STANDBY
$> . .OPUIMIMC
SQL> RECOVER MANAGED STANDBY DATABASE DISCONNECT FROM SESSION;

*** Check gap, Check current_scn di PRIMARY dan STANDBY, seharusnya tidak beda jauh ***

13. Enable dest nya di PRIMARY (exa62b - OPUIMTBS)
SQL> alter system set log_archive_dest_state_2=ENABLE scope=both sid='*';

14. Di server Standby (exaIMC - OPUIMIMC)
    Ubah mark crontab delete archive
$> crontab -e
   #10 1,13 * * * /home/oracle/script/backup/delete_arc_OPUIMTBS.s`h
      menjadi ...
   #10 1,13 * * * /home/oracle/script/backup/delete_arc_OPUIMTBS.sh
   
============================================================================================================


xcheck processs
#distanbdy
SELECT PROCESS, STATUS, THREAD#, SEQUENCE#, BLOCK#, BLOCKS FROM V$MANAGED_STANDBY;

APPLYING_LOG ---yg mau ke standby
RECEIVING ---yang ada di primay


   