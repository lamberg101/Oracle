SYNC GAP dengan restore SCN apabila archive fisik sudah tidak ada di PRIMARY sedangkan STANDBY masih membutuhkan archive tsb.

1. Check GAP terlebih dahulu di PRIMARY

SQL> @Check_gap.sql

   DEST_ID    THREAD#	 PRIMARY  MAXTRANSF    STANDBY MINTRANSF_GAP  APPLY_GAP   HOURSGAP
---------- ---------- ---------- ---------- ---------- ------------- ---------- ----------
	 3	    1	   34384      34384	 28268		   0	   6116        931
	 3	    2	   37796      37796	 32929		   0	   4867        931


2. Check SCN di PRIMARY dan STANDBY

col current_scn format 999999999999
select current_scn from v$database;

HASIL :
** PRIMARY
     CURRENT_SCN
----------------
  15531154491099

** STANDBY
     CURRENT_SCN
----------------
  15502697410604

3. Jika ada berbedaan SCN tsb, lanjut STOP MRP di standby dan restart db STANDBY

alter database recover managed standby database cancel;
shutdown immediate;

4. Backup SCN di PRIMARY lewat RMAN, masukkan SCN nya berdasarkan current_scn di STANDBY
$> . .OPRFSEV
$rman target /
RMAN> run { allocate channel c1 type disk format '/datadump3/scn_bk_oprfsev/SCN/%U.bkp'; backup incremental from scn 15502697410604 database; }

5. Buat standby controlfile di PRIMARY, lalu startup di standby.

PRIMARY :
alter database create standby controlfile as '/datadump3/scn_bk_oprfsev/cf_to_stby/oprfsevbsd_stby.ctl';
** scp ke server standby /datadump3/scn_bk_oprfsev/cf_new_stby/oprfsevbsd_stby.ctl
$> cd /datadump3/scn_bk_oprfsev/cf_to_stby
scp oprfsevbsd_stby.ctl oracle@10.251.33.88:/datadump3/scn_bk_oprfsev_stby/cf_new_stby/oprfsevbsd_stby.ctl

STANDBY :
** mv controlfile lama di standby 
$>. .grid_profile
$>asmcmd
asmcmd>cd DATAC4/OPRFSEVBSD/CONTROLFILE
asmcmd>mv oprfsevbsd_stby.ctl '+DATAC4/OPRFSEVBSD/CONTROLFILE/oprfsevbsd_stby.ctl.bak'

** mv standby controlfile ke server standby '/datadump3/scn_bk_oprfsev_stby/oprfsevbsd_stby.ctl'
ASMCMD>cp /datadump3/scn_bk_oprfsev_stby/cf_new_stby/oprfsevbsd_stby.ctl '+DATAC4/OPRFSEVBSD/CONTROLFILE/oprfsevbsd_stby.ctl'

6. Restore controlfile dengan startup nomount di STANDBY
$> . .OPRFSEVBSD 
$> sqlplus '/ as sysdba'
SQLPLUS> startup nomount;
SQLPLUS> alter database mount standby database;
SQLPLUS> exit
$> rman target /
RMAN> crosscheck archivelog all;
RMAN> delete noprompt expired archivelog all; 

6. Masuk RMAN STANDBY untuk restore scn backup di catalog /datadump3/scn_bk_oprfsev
$> . .OPRFSEVBSD 
$>rman target /
RMAN> catalog start with '/datadump3/scn_bk_oprfsev/SCN';
RMAN> recover database;

7. Jalankan MRP di STANDBY

alter database recover managed standby database disconnect from session;

*** Check gap, Check current_scn di PRIMARY dan STANDBY, seharusnya tidak beda jauh ***
 