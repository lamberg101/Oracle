1. Check CONTROL FILE

#SQLPLUS
sql> show parameter control_files;
sql> select name from v$controlfile;

#BACKUP
--ls -lrth /zfssa/exapdb/backup*/prod/* | grep control
--ls -lrth /zfssa/exapdb/backup*/prod/db/*.ctl


#Check_ISI
SQL> select * from V$CONTROLFILE_RECORD_SECTION order by type;



=========================================================================================

MENAMBAH, MULTIPLEXING (MIRRORING) CONRTOL FILE

1. Check

SQL> select name from v$controlfile;
NAME
--------------------------------------
/oradata/oracle/ts/control01.ctl
/oradata/oracle/ts/control02.ctl
/oradata/oracle/ts/control03.ctl
	

2. Create 1 control file dan di taru di /data1/oracle. 

a. Shutdown database
SQL> shutdown immediate


b. Copy --terserah yg mana, isinya sama.
$cd /data1/oracle/
$cp -rp /oradata/oracle/ts/control03.ctl control04.ctl


c. Edit parameter control_files 

Kalau pakai init file, edit file $ORACLE_HOME/dbs/init_dbname.ora
Tambahkan control file yang baru tersebut ke definisi control_files:
contoh: control_files='/oradata/oracle/ts/control01.ctl','/oradata/oracle/ts/control02.ctl','/oradata/oracle/ts/control03.ctl','/data1/oracle/control04.ctl'

Kalau pakai spfile, harus startup instance.
SQL> startup nomount
SQL> alter system set control_files='/oradata/oracle/ts/control01.ctl','/oradata/oracle/ts/control02.ctl','/oradata/oracle/ts/control03.ctl','/data1/oracle/control04.ctl' scope=spfile;
SQL> shutdown immediate
SQL> startup

SQL> select name from v$controlfile;
NAME
--------------------------------------
/oradata/oracle/ts/control01.ctl
/oradata/oracle/ts/control02.ctl
/oradata/oracle/ts/control03.ctl
/data1/oracle/control04.ctl

=========================================================================================

RENAME (memindahkan) CONTROL FILE

dari /data1/oracle/control04.ctl
ke  /data2/oracle/

1. Shutdown database

2. pindahkan (rename) control file
$cd /data2/oracle/
$mv /data1/oracle/control04.ctl /data2/oracle/
	
3. Edit instance parameter file (initfile atau spfile).
Ganti control file yang lama (/data1/oracle/control04.ctl) menjadi yang baru (/data2/oracle/control04.ctl):
control_files='/oradata/oracle/ts/control01.ctl','/oradata/oracle/ts/control02.ctl','/oradata/oracle/ts/control03.ctl','/data2/oracle/control04.ctl';
	
4. startup database

=========================================================================================

MENGURANGI (DELETE/DROP) CONTROL FILE

1. shutdown database

2. Take out /data2/oracle/control04.ctl dari parameter control_files.
	control_files='/oradata/oracle/ts/control01.ctl','/oradata/oracle/ts/control02.ctl','/oradata/oracle/ts/control03.ctl'

2. startup database

