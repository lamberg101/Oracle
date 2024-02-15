
1. Create ulang controlfile untuk standby 
SQL> ALTER DATABASE CREATE STANDBY CONTROLFILE AS '/home/oracle/ssi/slam/OPREMEDYBSD/OPREMEDYBSD_stby.ctl';


2. Setelah create controlfile standby, copykan ke server standby dengan path: /home/oracle/ssi/slam/OPREMEDYBSD/OPREMEDYBSD_stby.ctl
scp OPREMEDYBSD_stby.ctl oracle@10.39.64.38:/home/oracle/ssi/slam/OPREMEDYBSD/OPREMEDYBSD_stby.ctl


3. Kemudian controlfile copykan ke asm database standby:
ASMCMD> cd DATAC5/OPRMD9IT/CONTROLFILE
ASMCMD> cp /home/oracle/ssi/slam/OPREMEDYBSD/OPREMEDYBSD_stby.ctl +DATAC5/OPRMD9IT/CONTROLFILE/OPRMD9IT_stby.ctl


4. Startup database Standby dengan pfile yang sudah di buat di clone sebelumnya
Start instance di standby database (nomount) menggunaka pfile yang dibuat di step nomor 7 sudah
SQL> startup nomount pfile='/home/oracle/ssi/slam/OPREMEDYBSD/pfile_OPRMD9IT.txt';


5. Test Koneksi 
Tes koneksi dari server primary ke standby database (belum):
- tnsping OPRMD9IT
- tnsping OPRMD9IT1
- tnsping OPRMD9IT2
- sqlplus sys/OR4cl35y5#2015@OPRMD9IT as sysdba
- sqlplus sys/OR4cl35y5#2015@OPRMD9IT1 as sysdba
- sqlplus sys/OR4cl35y5#2015@OPRMD9IT2 as sysdba

Lakukan juga tes koneksi dari server standby ke primary
- tnsping OPREMEDYBSD
- tnsping OPREMEDYBSD1
- tnsping OPREMEDYBSD2
- sqlplus sys/OR4cl35y5#2015@OPREMEDYBSD as sysdba
- sqlplus sys/OR4cl35y5#2015@OPREMEDYBSD1 as sysdba
- sqlplus sys/OR4cl35y5#2015@OPREMEDYBSD2 as sysdba


6.duplicate database di jalankan dari DATABASE PRIMARY

export ORACLE_SID=OPREMEDYBSD1
export ORACLE_HOME=/u01/app/oracle/product/11.2.0.4/dbhome_1
export PATH=/u01/app/oracle/product/11.2.0.4/dbhome_1/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin

$ORACLE_HOME/bin/rman target sys/OR4cl35y5#2015@OPREMEDYBSD1 AUXILIARY sys/OR4cl35y5#2015@OPRMD9IT1 trace=/home/oracle/ssi/slam/OPREMEDYBSD/duplicate_OPRMD9IT_181818181818181818181818181818181818052020.log << EOF
run {
duplicate target database for standby from active database;
}
exit
EOF

5 Di server standby, setelah selesai duplikat database standby, Check status database standby di node 1 
SQL> select name, database_role from v$database;


6. Di server standby, modify pfile, dan kemudian create spfile from pfile (Step ini belum)
- vi /home/oracle/ssi/slam/OPREMEDYBSD/pfile_OPRMD9IT.txt
- Create spfile from pfile:
SQL> create spfile='+DATAC5/OPRMD9IT/PARAMETERFILE/spfileOPRMD9IT.ora' from pfile='/home/oracle/ssi/slam/OPREMEDYBSD/pfile_OPRMD9IT.txt';


7. Di server standby, Shutdown database di node 1 (Step ini belum)
SQL> shutdown immediate;


8. Di server standby, Register Standby Database Resources with Clusterware (Step ini belum)
. .OPRMD9IT_profile
$ srvctl add database -d OPRMD9IT -o /u01/app/oracle/product/11.2.0.4/dbhome_1
$ srvctl add instance -d OPRMD9IT -i OPRMD9IT1 -n exa62tbspdb1-mgt
$ srvctl add instance -d OPRMD9IT -i OPRMD9IT2 -n exa62tbspdb2-mgt
$ srvctl modify database -d OPRMD9IT -r physical_standby
$ srvctl modify database -d OPRMD9IT -p '+DATAC5/OPRMD9IT/PARAMETERFILE/spfileOPRMD9IT.ora'


9. Di server standby, Start standby database (Step ini belum)
$ srvctl start database -d OPRMD9IT -o mount


10. Di server primary, ENABLE status LOG_ARCHIVE_DEST_STATE_2  (Step ini belum)
ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_2 = ENABLE sid='*' scope=both;


11. Di server standby, Enable MRP dan recover database (Step ini belum)
alter database recover managed standby database using current logfile disconnect;


12. Di server standby, Monitor apply process (Step ini belum)
select thread#,sequence#,archived,applied from v$archived_log order by first_time;
select inst_id, process, status, thread#, sequence#, block#, blocks from gv$managed_standby where process in ('RFS','LNS','MRP0');
select DEST_ID,dest_name,status,type,srl,recovery_mode from v$archive_dest_status where dest_id=1;
select name, open_mode, database_role from v$database;


13. Di server primary, check status archive destination (Step ini belum)
set line 200
col DEST_NAME for a50
col BINDING for a10
select DEST_ID,DEST_NAME,STATUS,BINDING,ERROR from v$ARCHIVE_DEST where status<>'INACTIVE';


14. Di server standby, Open read only standby database (Step ini belum)
Alter database recover managed standby database cancel;
Alter database open read only;
alter database recover managed standby database using current logfile disconnect from session;