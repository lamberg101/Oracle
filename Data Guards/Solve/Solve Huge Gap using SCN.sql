SYNC GAP dengan restore SCN apabila archive fisik sudah tidak ada di PRIMARY sedangkan STANDBY masih membutuhkan archive tsb.

** Masuk ke masing-masing profile DB

--Check GAP terlebih dahulu di PRIMARY
SQL> @Check_gap.sql


--Check SCN di PRIMARY dan STANDBY
col current_scn format 999999999999999
select current_scn from v$database;

Untuk standby jalankan juga query ini :
col min(checkpoint_change#) for 999999999999999
select min(checkpoint_change#) from v$datafile_header 
where file# not in (select file# from v$datafile where enabled = 'READ ONLY');

HASIL :
** PRIMARY (exa62b - OPRFSEV)

     CURRENT_SCN
----------------
  15676496121613

** STANDBY (exaBSD - OPRFSEVBSD)

     CURRENT_SCN
----------------
  15664480156715

  MIN(CHECKPOINT_CHANGE#)
-----------------------
	 15664480156716

*** ambil yang paling kecil yakni :  15664480156715  


--Jika ada berbedaan SCN tsb, lanjut STOP MRP di standby dan restart db STANDBY (exaBSD - OPRFSEVBSD)
SQL> alter database recover managed standby database cancel;
SQL> exit




***** Di PRIMARY (exa62b - OPRFSEV), defer log archive dest nya
SQL> alter system set log_archive_dest_state_3=DEFER scope=both sid='*';



4. Backup SCN di PRIMARY (exa62b - OPRFSEV) lewat RMAN, masukkan SCN nya berdasarkan current_scn di STANDBY (exaBSD - OPRFSEVBSD)
   *** Kurleb sekitar 3 jam backup

$> . .OPRFSEV
Jalankan lewat nohup !!

$> cd /home/oracle/script/OPRFSEV
$> vi Backup_SCN.sh
$> nohup Backup_SCN.sh &

echo '======================================='
export ORACLE_SID=OPRFSEV1
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2/dbhome_1
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/jdk/jre/bin:$PATH

$ORACLE_HOME/bin/rman target / nocatalog trace=/home/oracle/script/OPRFSEV/OPRFSEV_SCN_BACKUP.trc << EOF
run
{
allocate channel ch01 device type disk format '/datadump11/oprfsev/Backup_Scan/%d_SCN_BAK_%T_%U.bk';
backup incremental from scn 15664480156715 database; 
release channel ch01;
}
exit
EOF

*** Jika sudah selesai ubah chmod :
$> cd /datadump11/oprfsev/
$> chmod -R 777 Backup_Scan/

5. Buat standby controlfile di PRIMARY (exa62b - OPRFSEV), lalu startup di standby (exaBSD - OPRFSEVBSD)

PRIMARY :
SQL> alter database create standby controlfile as '/home/oracle/ssi/oprfsev/oprfsevbsd_stby.bck';
** scp ke server standby '/home/oracle/ssi/oprfsev/oprfsevbsd_stby.ctl'
$> cd /home/oracle/ssi/oprfsev/
$> chmod 777 oprfsevbsd_stby.bck
$> scp oprfsevbsd_stby.ctl oracle@10.54.128.6:/home/oracle/ssi/oprfsevbsd/oprfsevbsd_stby.bck

6. Simpan nama-nama datafile yang pada database STANDBY, dikarenakan nama path datafile di primary dan standby berbedaan
$> cd /home/oracle/ssi/slam/OPRFSEV/
$> . .OPRFSEVBSD
$> sqlplus / as sysdba
spool datafile_names_OPRFSEVBSD.txt
set lines 200
col name format a60
select file#, name from v$datafile order by file#;
spool off

7. Restore catalog backup di Standby (ExaBSD - OPRFSEVBSD)

$> RMAN TARGET /
RMAN > CONFIGURE CHANNEL DEVICE TYPE 'SBT_TAPE' CLEAR;
RMAN > CONFIGURE SNAPSHOT CONTROLFILE NAME TO '+RECOC4/snapcf_OPRFSEV1.f';
RMAN > exit
---------------------------
Jalankan lewat nohup !!

$> cd /home/oracle/ssi/oprfsevbsd
$> vi Restore_SCN.sh
$> nohup Restore_SCN.sh &

echo '======================================='
export ORACLE_SID=OPRFSEVBSD1
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH

$ORACLE_HOME/bin/rman target / nocatalog trace=/home/oracle/ssi/oprfsevbsd/OPRFSEV_SCN_RESTORE.trc << EOF
run
{
CATALOG START WITH '/datadump11/oprfsev/Backup_Scan/' noprompt;
RECOVER DATABASE NOREDO; 
}
exit
EOF

8. Matikan standby database (exaBSD - OPRFSEVBSD) untuk fresh startup mount dari standby controlfile baru
$> . .OPRFSEVBSD
$> srvctl status database -d OPRFSEVBSD
$> srvctl stop database -d OPRFSEVBSD
$> srvctl status database -d OPRFSEVBSD
$> date

   *** Masuk ke RMAN restore controlfile
$> . .OPRFSEVBSD
$> srvctl start database -db OPRFSEVBSD -startoption "NOMOUNT"
$> RMAN TARGET /
RMAN> RESTORE STANDBY CONTROLFILE FROM '/home/oracle/ssi/oprfsevbsd/oprfsevbsd_stby.bck';
RMAN> exit
$> srvctl stop database -d OPRFSEVBSD
$> srvctl start database -d OPRFSEVBSD -o mount

   *** Ubah dulu beberapa parameter di rman karena setelah restore controlfile akan mengikut primary
$> RMAN TARGET /
RMAN> CONFIGURE CHANNEL DEVICE TYPE 'SBT_TAPE' CLEAR;
RMAN> CONFIGURE SNAPSHOT CONTROLFILE NAME TO '+RECOC4/snapcf_OPRFSEV1.f';
RMAN> EXIT

9. Ubah catalog sesuai nama datafile semula di server STANDBY (exaBSD - OPRFSEVBSD) dan recover

$> . .OPRFSEVBSD
Jalankan lewat nohup !!

$> cd /home/oracle/ssi/oprfsevbsd/
$> vi Catalog_Standby.sh
$> nohup Catalog_Standby.sh &

echo '======================================='
export ORACLE_SID=OPRFSEVBSD1
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH

$ORACLE_HOME/bin/rman target / nocatalog trace=/home/oracle/ssi/oprfsevbsd/OPRFSEV_CATALOG_BACKUP.trc << EOF
run
{
CATALOG START WITH '+DATAC4/OPRFSEVBSD/DATAFILE/' noprompt;
}
exit
EOF

@@@@ Add standby redolog (rumus standby redolog yakni = Jumlah Online Redolog + 1)
alter database add standby logfile thread 1 group 26 ('+DATAC4','+RECOC4') size 1G,
group 27 ('+DATAC4','+RECOC4') size 1G,
group 28 ('+DATAC4','+RECOC4') size 1G,
group 29 ('+DATAC4','+RECOC4') size 1G,
group 30 ('+DATAC4','+RECOC4') size 1G,
group 31 ('+DATAC4','+RECOC4') size 1G;

alter database add standby logfile thread 2 group 32 ('+DATAC4','+RECOC4') size 1G,
group 33 ('+DATAC4','+RECOC4') size 1G,
group 34 ('+DATAC4','+RECOC4') size 1G,
group 35 ('+DATAC4','+RECOC4') size 1G,
group 36 ('+DATAC4','+RECOC4') size 1G,
group 37 ('+DATAC4','+RECOC4') size 1G;

10. Setelah selesai catalog, switch database to copy pada standby OPRFSEVBSD

$> RMAN TARGET /
RMAN> SWITCH DATABASE TO COPY;

11. Clearing Redolog Standby di server STANDBY (exa62BSD - OPRFSEVBSD)
$> . .OPRFSEVBSD
$> sqlplus / as sysdba
SQL> select GROUP# from v$logfile where TYPE='STANDBY' group by GROUP#;
SQL> ALTER DATABASE CLEAR LOGFILE GROUP . . . . . .

12. Jalankan MRP di STANDBY
$> . .OPRFSEVBSD
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DISCONNECT;

*** Check gap, Check current_scn di PRIMARY dan STANDBY, seharusnya tidak beda jauh ***

13. Enable dest nya di PRIMARY (exa62b - OPRFSEV)
SQL> alter system set log_archive_dest_state_3=ENABLE scope=both sid='*';

14. Di server Standby (exa62BSD - OPRFSEVBSD)
    Ubah mark crontab delete archive
$> crontab -e
   #0 1 * * * /home/oracle/ssi/slam/OPRFSEV/delete_arc_OPRFSEV.sh
      menjadi ...
   0 1 * * * /home/oracle/ssi/slam/OPRFSEV/delete_arc_OPRFSEV.sh
   
   
   