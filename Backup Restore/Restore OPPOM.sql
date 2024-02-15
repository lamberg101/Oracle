requiset backup server OPPOM
user    : oracle
ip      : 10.250.200.69
pass    : 90oracle78


1. start pfile
SQL> startup mount pfile='/oradata/OPPOM/OPPOM62/pfile_oppom.txt';

--ambil pfile di db source.
SQL> create pfile=/home/oracle/ssi/pfile_oppom.txt from spfile;

--lalu copy pfile nya ke server TARGET 
/oradata/OPPOM/OPPOM62/pfile_oppom.txt



2. restore controle file
Lempar semua file backup ke server TARGET /oradata/OPPOM/OPPOM62/backup_rman

RMAN> restore controlfile from '/oradata/OPPOM/OPPOM62/backup_rman/control_20190327_0htth8ao_1_1.bkp';
RMAN> alter database mount;


3. Crosscheck and delete expired archivelog & backup.
RMAN> crosscheck backup;
RMAN> delete noprompt expired backup;
RMAN> crosscheck backup;
RMAN> crosscheck archivelog all;
RMAN> delete noprompt expired archivelog all;


4. Check redolog SOURCE server dan ubah di TARGET server
Check path redolog di source:
SQL> col member for a60
SQL> SELECT MEMBER FROM V$LOGFILE;


Masuk sqlplus ke TARGET
Ganti sesuai path baru redolog yang di TARGET :

alter database rename file '+DATA4/OPPOM/ONLINELOG/group_15.49515.1000381087' to '/oradata/OPPOM/OPPOM62/redolog/redo_15a.log';
alter database rename file '+RECOC4/OPPOM/ONLINELOG/group_15.54965.1000381087' to '/oradata/OPPOM/OPPOM62/redolog/redo_15b.log';
alter database rename file '+DATA4/OPPOM/ONLINELOG/group_16.49514.1000381087' to '/oradata/OPPOM/OPPOM62/redolog/redo_16a.log';
alter database rename file '+RECOC4/OPPOM/ONLINELOG/group_16.30845.1000381087' to '/oradata/OPPOM/OPPOM62/redolog/redo_16b.log';
alter database rename file '+DATA4/OPPOM/ONLINELOG/group_17.49513.1000381087' to '/oradata/OPPOM/OPPOM62/redolog/redo_17a.log';
alter database rename file '+RECOC4/OPPOM/ONLINELOG/group_17.42201.1000381089' to '/oradata/OPPOM/OPPOM62/redolog/redo_17b.log';
alter database rename file '+DATA4/OPPOM/ONLINELOG/group_18.49512.1000381089' to '/oradata/OPPOM/OPPOM62/redolog/redo_18a.log';
alter database rename file '+RECOC4/OPPOM/ONLINELOG/group_18.18500.1000381089' to '/oradata/OPPOM/OPPOM62/redolog/redo_18b.log';
alter database rename file '+DATA4/OPPOM/ONLINELOG/group_21.49511.1000381093' to '/oradata/OPPOM/OPPOM62/redolog/redo_21a.log';
alter database rename file '+RECOC4/OPPOM/ONLINELOG/group_21.52891.1000381093' to '/oradata/OPPOM/OPPOM62/redolog/redo_21b.log';
alter database rename file '+DATA4/OPPOM/ONLINELOG/group_22.49510.1000381093' to '/oradata/OPPOM/OPPOM62/redolog/redo_22a.log';
alter database rename file '+RECOC4/OPPOM/ONLINELOG/group_22.6368.1000381093' to '/oradata/OPPOM/OPPOM62/redolog/redo_22b.log';
alter database rename file '+DATA4/OPPOM/ONLINELOG/group_23.49509.1000381093' to '/oradata/OPPOM/OPPOM62/redolog/redo_23a.log';
alter database rename file '+RECOC4/OPPOM/ONLINELOG/group_23.24170.1000381095' to '/oradata/OPPOM/OPPOM62/redolog/redo_23b.log';
alter database rename file '+DATA4/OPPOM/ONLINELOG/group_24.49508.1000381095' to '/oradata/OPPOM/OPPOM62/redolog/redo_24a.log';
alter database rename file '+RECOC4/OPPOM/ONLINELOG/group_24.19146.1000381095' to '/oradata/OPPOM/OPPOM62/redolog/redo_24b.log';


5. Masukkan new catalog backup dari source
RMAN> catalog start with '/oradata/OPPOM/OPPOM62/backup_rman/';

*** ini lumayan lama, kalau ga mau putus pakai RDP saja

6. restore database;
Gunakan nohup, buat dan paste script di /home/oracle/restore_OPPOM.sh
cd /home/oracle/
jalankan script
nohup sh /home/oracle/restore_OPPOM.sh &

*** selalu Check log hingga restore completed
/home/oracle/restore_OPPOM62.log

7. recover database;
Jalankan apabila restore backup telah selesai
RMAN> recover database;

8. alter database open resetlogs;
RMAN> alter database open resetlogs;
RMAN> exit

****DONE****

-----------------------------------------------------------------------------------------------------------------------------------------------

SCRIPT untuk restore :
--Point yang perlu diperhatikan
1. Collect pathname dqatafile nya di database server source, ganti set newname for datafile 'source' to 'newpath'
   SELECT NAME FROM V$DATAFILE: <--- di database source
2. Export ORACLE_SID, ORACLE_HOME sesuai dengan yang ada di server TARGET
3. Configure parallelism nya menjadi 10 (Jangan terlalu banyak tergantung kuatnya CPU!!!)
 
   
SCIPT point 4 sbb :

export ORACLE_SID=OPPOM
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/OPatch:$PATH
$ORACLE_HOME/bin/rman TARGET / trace=/home/oracle/restore_OPPOM62.log << EOF
CONFIGURE DEVICE TYPE DISK PARALLELISM 10 BACKUP TYPE TO BACKUPSET;
run  
 {
set newname for datafile '+DATAC4/OPPOM/DATAFILE/system.2926.978101477' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/opm_data.551.978103883' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/sysaux.2925.978101443' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/undotbs1.545.978101523' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/undotbs2.1012.978101595' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/users.1034.978101523' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/opm_index.552.978103907' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/pom_log_index.1038.978109873' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/pom_log_data.1184.978109885' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/prool_soainfra.48969.993400535' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/prool_ias_ums.48971.993400537' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/prool_ess.48972.993400537' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/prool_wls.48973.993400539' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/prool_ias_opss.48974.993400539' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/prool_iau.48975.993400539' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/prool_stb.48976.993400541' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/prool_mds.48977.993400541' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/probt_wls.49017.993483459' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/probt_mds.49018.993483461' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/probt_stb.49019.993483461' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/probt_ias_opss.49020.993483463' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/probt_soainfra.49021.993483463' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/probt_iau.49022.993483465' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/probt_ias_ums.49023.993483465' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/probt_ess.49024.993483465' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/proui_wls.49110.993571837' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/proui_iau.49109.993571839' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/proui_ias_opss.49108.993571839' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/proui_ias_ums.49107.993571841' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/proui_stb.49111.993571841' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/proui_mds.49112.993571841' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/prooltbs_wls.47529.994864267' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/prooltbs_mds.47527.994864297' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/prooltbs_soainfra.47520.994864299' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/prooltbs_ess.47515.994864299' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/prooltbs_stb.47464.994864301' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/prooltbs_ias_opss.47458.995209997' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/prooltbs_iau.47468.994864301' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/prooltbs_ias_ums.47454.994864303' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/prouitbs_ias_ums.47470.995207433' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/prouitbs_stb.47509.995207433' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/prouitbs_wls.47530.995207435' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/prouitbs_mds.47528.995207437' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/prouitbs_iau.47521.995207437' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/prouitbs_ias_opss.47519.995207437' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/probttbs_ess.49404.998922021' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/probttbs_soainfra.49405.998922051' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/probttbs_ias_opss.49406.998922051' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/probttbs_stb.49407.998922053' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/probttbs_wls.49408.998922053' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/probttbs_mds.49409.998922053' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/probttbs_ias_ums.49410.998922055' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/probttbs_iau.49411.998922055' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/pomapp.49414.999374019' to '/oradata/OPPOM/OPPOM62/datafile/%b';
set newname for datafile '+DATAC4/OPPOM/DATAFILE/datal01.49415.999374105' to '/oradata/OPPOM/OPPOM62/datafile/%b';
restore database;
switch datafile all;
}