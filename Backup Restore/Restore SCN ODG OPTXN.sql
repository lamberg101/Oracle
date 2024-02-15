SYNC GAP dengan restore SCN apabila archive fisik sudah tidak ada di PRIMARY sedangkan STANDBY masih membutuhkan archive tsb.

** Masuk ke masing-masing profile DB

1. Check GAP terlebih dahulu di PRIMARY (optxntbs-txntbspdb2 ___ optxnsol-txnsolopdb1)


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
  15946304375590


** STANDBY (exaIMC - OPUIMIMC)

     CURRENT_SCN
----------------
  15941385636424


MIN(CHECKPOINT_CHANGE#)
-----------------------
  15939799026755


*** ambil yang paling kecil yakni :  15939799026755  


   3. Jika ada berbedaan SCN tsb, lanjut STOP MRP di standby dan restart db STANDBY (optxnsol-txnsolopdb1)

SQL> alter database recover managed standby database cancel;
SQL> exit

***** Di PRIMARY (optxntbs-txntbspdb2), defer log archive dest nya
SQL> alter system set log_archive_dest_state_2=DEFER scope=both sid='*';

4. Backup SCN di PRIMARY (optxntbs-txntbspdb2) lewat RMAN, masukkan SCN nya berdasarkan current_scn di STANDBY (optxnsol-txnsolopdb1)

Jalankan lewat nohup !!

$> cd /home/oracle/script/
$> vi Backup_SCN_optxntbs.sh
$> nohup sh Backup_SCN_optxntbs.sh > Backup_SCN_optxntbs.log &

echo '======================================='
export ORACLE_SID=optxntbs
export ORACLE_HOME/apps/oracle/product/12cR1/db
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/jdk/jre/bin:$PATH

$ORACLE_HOME/bin/rman target / nocatalog trace=/home/oracle/script/optxntbs_SCN_BACKUP.trc << EOF
run
{
allocate channel ch01 device type disk format '/backup/backup_incremental_optxntbs/%d_SCN_BAK_%T_%U.bk';
backup incremental from scn 15939799026755 database; 
release channel ch01;
}
exit
EOF


*** Jika sudah selesai ubah chmod :
$> cd /backup/backup_incremental_optxntbs/
$> chmod -R 777 backup_incremental_optxntbs/

5. Buat standby controlfile di PRIMARY (optxntbs-txntbspdb2), lalu startup di standby (optxnsol-txnsolopdb1)

PRIMARY :
SQL> alter database create standby controlfile as '/home/oracle/script/optxnsol_stby.bck';
** scp ke server standby '/home/oracle/script/optxnsol_stby.bck'
$> cd /home/oracle/script/
$> chmod 777 optxnsol_stby.bck
$> scp optxnsol_stby.bck oracle@10.75.10.7:/home/oracle/script/

6. Restore catalog backup di Standby (optxnsol-txnsolopdb1)

Jalankan lewat nohup !!

$> cd /home/oracle/script
$> vi Restore_SCN.sh
$> nohup Restore_SCN.sh > Restore_SCN.log &

echo '======================================='
export ORACLE_SID=optxnsol
export ORACLE_HOME=/apps/oracle/product/12cR1/db
export PATH=$ORACLE_HOME/bin:$PATH

$ORACLE_HOME/bin/rman target / nocatalog trace=/home/oracle/script/optxnsol_SCN_RESTORE.trc << EOF
run
{
CATALOG START WITH '/backup/backup_incremental_optxntbs/' noprompt;
RECOVER DATABASE NOREDO; 
}
exit
EOF

7. Matikan standby database (optxnsol-txnsolopdb1) untuk fresh startup mount dari standby controlfile baru

$> sqlplus / as sysdba
SQL> shutdown immediate;
SQL> exit
$> sqlplus / as sysdba
SQL> startup nomount
SQL> exit
$> RMAN TARGET /
RMAN> RESTORE STANDBY CONTROLFILE FROM '/home/oracle/script/optxnsol_stby.bck';
RMAN> exit

*** rebounce ke mount
SQL> shutdown immediate;
SQL> exit
$> sqlplus / as sysdba
SQL> startup mount;

   *** Ubah dulu beberapa parameter di rman karena setelah restore controlfile akan mengikut primary
$> RMAN TARGET /
RMAN> CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/apps/oracle/product/12cR1/db/dbs/snapcf_optxnsol.f';
RMAN> EXIT


------ Bawah belum diganti / disesuaikan ------

8. Ubah catalog sesuai nama datafile semula di server STANDBY (optxnsol-txnsolopdb1) dan recover

Jalankan lewat nohup !!

$> cd /home/oracle/script/
$> vi Catalog_Standby_optxnsol.sh
$> nohup sh Catalog_Standby_optxnsol.sh > Catalog_Standby_optxnsol.log &

echo '======================================='
export ORACLE_SID=optxnsol
export ORACLE_HOME=/apps/oracle/product/12cR1/db
export PATH=$ORACLE_HOME/bin:$PATH

$ORACLE_HOME/bin/rman target / nocatalog trace=/home/oracle/script/optxnsol_CATALOG_BACKUP.trc << EOF
run
{
CATALOG START WITH '+/blablaahaidhpdadasfasfsafs' noprompt;
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
SQL> alter database recover managed standby database using current logfile disconnect from session;

*** Check gap, Check current_scn di PRIMARY dan STANDBY, seharusnya tidak beda jauh ***

13. Enable dest nya di PRIMARY (exa62b - OPUIMTBS)
SQL> alter system set log_archive_dest_state_2=ENABLE scope=both sid='*';

14. Di server Standby (exaIMC - OPUIMIMC)
    Ubah mark crontab delete archive
$> crontab -e
   #10 1,13 * * * /home/oracle/script/backup/delete_arc_OPUIMTBS.s`h
      menjadi ...
   #10 1,13 * * * /home/oracle/script/backup/delete_arc_OPUIMTBS.sh
   
   
   