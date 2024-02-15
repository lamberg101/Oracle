create directory dan create pfile :
===================================
mkdir -p /u01/app/oracle/admin/OPMRA/adump

OPMRA2.__db_cache_size=3942645760
OPMRA1.__db_cache_size=3808428032
OPMRA2.__java_pool_size=100663296
OPMRA1.__java_pool_size=100663296
OPMRA2.__large_pool_size=117440512
OPMRA1.__large_pool_size=117440512
OPMRA2.__pga_aggregate_target=2147483648
OPMRA1.__pga_aggregate_target=2147483648
OPMRA2.__sga_target=6442450944
OPMRA1.__sga_target=6442450944
OPMRA2.__shared_io_pool_size=0
OPMRA1.__shared_io_pool_size=0
OPMRA2.__shared_pool_size=2181038080
OPMRA1.__shared_pool_size=2315255808
OPMRA2.__streams_pool_size=0
OPMRA1.__streams_pool_size=0
*.audit_file_dest='/u01/app/oracle/admin/OPMRA/adump'
*.audit_trail='db'
*.cluster_database=true
*.compatible='11.2.0.4.0'
*.control_files='+DATAC2/opmra/controlfile/ctl_opmra.ctl'  
*.db_block_size=8192
*.db_create_file_dest='+DATAC2' 
*.db_domain=''
*.db_name='OPMRA'
*.db_recovery_file_dest='+RECOC2'
*.db_recovery_file_dest_size=1073741824000
*.diagnostic_dest='/u01/app/oracle'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=OPMRAXDB)'
OPMRA2.instance_number=2
OPMRA1.instance_number=1
*.log_archive_config='nodg_config'
*.log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST'
*.log_archive_dest_2=''
*.log_archive_dest_state_2='DEFER'
*.log_archive_format='arch_%t_%s_%r.arc'
*.open_cursors=300
*.pga_aggregate_target=2147483648
*.processes=2500
*.remote_listener='exapdb62b-scan:1521'
*.remote_login_passwordfile='exclusive'
*.sessions=2000
*.sga_target=6442450944
OPMRA2.thread=2
OPMRA1.thread=1
OPMRA2.undo_tablespace='UNDOTBS2'
OPMRA1.undo_tablespace='UNDOTBS1'


SQL > startup nomount pfile='/home/oracle/pfile_opmra.txt';

$ srvctl add database -d OPMRA -o /u01/app/oracle/product/11.2.0.4/dbhome_1
$ srvctl add instance -d OPMRA -i OPMRA1 -n exa62pdb3-mgt
$ srvctl add instance -d OPMRA -i OPMRA2 -n exa62pdb4-mgt
$ srvctl modify database -d OPMRA -r physical_standby
$ srvctl modify database -d OPMRA -p '+DATAC2/OPMRA/PARAMETERFILE/spfileOPMRA.ora'

SQL > create spfile='+DATAC2/OPMRA/PARAMETERFILE/spfileOPMRA.ora' from pfile='/home/oracle/pfile_opmra.txt';

$ /usr/openv/netbackup/bin/oracle_link --> using oracle dan profile db target

run script :
============
restore controlfile :
---------------------
run {
allocate channel ch00 device type 'sbt_tape';
send 'NB_ORA_SERV=tbsnbuvpapp1.telkomsel.co.id, NB_ORA_CLIENT=exa62pdb1-vip.telkomsel.co.id';
restore controlfile from 'cntrl_OPMRA_7017_1_1029320296';
}


nb:
NB_ORA_SERV : di isi master server nya --> bisa di lihat di more /usr/openv/netbackup/bp.conf
NB_ORA_CLIENT : di isi source db nya saat backup 

RMAN > alter database mount;

restore database:
-----------------
run {
allocate channel ch00 device type 'sbt_tape';
send 'NB_ORA_SERV=tbsnbuvpapp1.telkomsel.co.id, NB_ORA_CLIENT=exa62pdb1-vip.telkomsel.co.id';
restore database;
}

SQL> recover database using backup controlfile until cancel;

SQL> recover database using backup controlfile until cancel;
ORA-00279: change 15768929690155 generated at 01/10/2020 02:33:26 needed for
thread 1
ORA-00289: suggestion :
+RECOC2/opmra/archivelog/2020_01_13/thread_1_seq_156459.42258.1029604237
ORA-00280: change 15768929690155 for thread 1 is in sequence #156459 --> patokan scn nya


Specify log: {<RET>=suggested | filename | AUTO | CANCEL}



--> find sequence nya: 156459

running restore archivelog:
------------------------------
run {
allocate channel ch00 device type 'sbt_tape';
send 'NB_ORA_SERV=tbsnbuvpapp1.telkomsel.co.id, NB_ORA_CLIENT=exa62pdb1-vip.telkomsel.co.id';
restore archivelog from logseq=156459 until logseq=156463 thread=1;
restore archivelog from logseq=57458 until logseq=57460 thread=2;
}


SQL> recover database using backup controlfile until cancel;

==> AUTO

SQL> alter database open resetlogs;

restart database:
=================
[oracle@exa62pdb3-mgt ~]$ srvctl status database -d OPMRA
Instance OPMRA1 is running on node exa62pdb3-mgt
Instance OPMRA2 is running on node exa62pdb4-mgt
[oracle@exa62pdb3-mgt ~]$ srvctl stop database -d OPMRA
[oracle@exa62pdb3-mgt ~]$ srvctl status database -d OPMRA
Instance OPMRA1 is not running on node exa62pdb3-mgt
Instance OPMRA2 is not running on node exa62pdb4-mgt
[oracle@exa62pdb3-mgt ~]$ srvctl start database -d OPMRA

SQL> select name ,database_role,open_mode from gv$database;

NAME	  DATABASE_ROLE    OPEN_MODE
--------- ---------------- --------------------
OPMRA	  PRIMARY	   READ WRITE
OPMRA	  PRIMARY	   READ WRITE

SQL> select host_name from gv$instance;

HOST_NAME
----------------------------------------------------------------
exa62pdb3-mgt.telkomsel.co.id
exa62pdb4-mgt.telkomsel.co.id









