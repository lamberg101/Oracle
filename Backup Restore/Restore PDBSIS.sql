1. backup spfile
create pfile='/u02/dpump/pfile_pdbsis_26062019.ora' from spfile;



+DATAC1/PDBSIS/CONTROLFILE/pdbsis_20190314.ctl
+DATAC1/PDBSIS/CONTROLFILE/

/u02/dpump/lina/pbsis.ora

requiset restore
user    : opc
pass    : welcome1
di rdp   10.251.38.112 

?database di stop?

1.startup nomount pfile='/u02/dpump/lina/pbsis.ora';
startup nomount pfile='/u02/dpump/lina/pbis_bck.ora';

2.
RMAN> restore controlfile from '+DATAC1/PDBSIS/CONTROLFILE/pdbsis_20190314.ctl';
RMAN> alter database mount;

3. Crosscheck and delete expired archivelog & backup
RMAN> crosscheck backup;
RMAN> delete noprompt expired backup;
RMAN> crosscheck backup;
RMAN> crosscheck archivelog all;
RMAN> delete noprompt expired archivelog all;

4. catalog start with '/dump/rman_full_20190314/';

5. run script
bash 

export ORACLE_SID=PDBSIS2
export /sbin:/bin:/usr/sbin:/usr/bin:/u02/app/oracle/product/11.2.0/dbhome_11/bin:/u02/app/oracle/product/11.2.0/dbhome_11/OPatch; export PATH
$ORACLE_HOME/bin/rman target / trace=/home/oracle/restore.log << EOF
CONFIGURE DEVICE TYPE DISK PARALLELISM 10 BACKUP TYPE TO BACKUPSET;
run  
i{
alter database rename file '+DATA_EXAP/prodt/onlinelog/group_3.24051.976481419' to '+DATAC1/PDBSIS/DATAFILE/%b';
alter database rename file '+RECO_EXAP/prodt/onlinelog/group_3.16458.976481421' to '+RECOC1/PDBSIS/ARCHIVELOG/2019_restore/%b';
alter database rename file '+DATA_EXAP/prodt/onlinelog/group_4.24437.976481421' to '+DATAC1/PDBSIS/DATAFILE/%b';
alter database rename file '+RECO_EXAP/prodt/onlinelog/group_4.16452.976481423' to '+RECOC1/PDBSIS/ARCHIVELOG/2019_restore/%b';
alter database rename file '+DATA_EXAP/prodt/onlinelog/group_1.24200.976481413' to '+DATAC1/PDBSIS/DATAFILE/%b';
alter database rename file '+RECO_EXAP/prodt/onlinelog/group_1.7456.976481415' to '+RECOC1/PDBSIS/ARCHIVELOG/2019_restore/%b';
alter database rename file '+DATA_EXAP/prodt/onlinelog/group_2.24178.976481417' to '+DATAC1/PDBSIS/DATAFILE/%b';
alter database rename file '+RECO_EXAP/prodt/onlinelog/group_2.9451.976481417' to '+RECOC1/PDBSIS/ARCHIVELOG/2019_restore/%b';
alter database rename file '+DATA_EXAP/prodt/onlinelog/group_5.24300.976481423' to '+DATAC1/PDBSIS/DATAFILE/%b';
alter database rename file '+RECO_EXAP/prodt/onlinelog/group_5.11910.976481425' to '+RECOC1/PDBSIS/ARCHIVELOG/2019_restore/%b';
alter database rename file '+DATA_EXAP/prodt/onlinelog/group_6.13461.976481425' to '+DATAC1/PDBSIS/DATAFILE/%b';
alter database rename file '+RECO_EXAP/prodt/onlinelog/group_6.15617.976481427' to '+RECOC1/PDBSIS/ARCHIVELOG/2019_restore/%b';
alter database rename file '+DATA_EXAP/prodt/onlinelog/group_7.13450.976481427' to '+DATAC1/PDBSIS/DATAFILE/%b';
alter database rename file '+RECO_EXAP/prodt/onlinelog/group_7.12114.976481429' to '+RECOC1/PDBSIS/ARCHIVELOG/2019_restore/%b';
alter database rename file '+DATA_EXAP/prodt/onlinelog/group_8.15054.976481429' to '+DATAC1/PDBSIS/DATAFILE/%b';
alter database rename file '+RECO_EXAP/prodt/onlinelog/group_8.6525.976481431' to '+RECOC1/PDBSIS/ARCHIVELOG/2019_restore/%b';
alter database rename file '+DATA_EXAP/prod/onlinelog/group_9.44584.994379453' to '+DATAC1/PDBSIS/DATAFILE/%b';
alter database rename file '+RECO_EXAP/prod/onlinelog/group_9.17394.994379453' to '+RECOC1/PDBSIS/ARCHIVELOG/2019_restore/%b';
alter database rename file '+DATA_EXAP/prod/onlinelog/group_10.44585.994379455' to '+DATAC1/PDBSIS/DATAFILE/%b';
alter database rename file '+RECO_EXAP/prod/onlinelog/group_10.18427.994379455' to '+RECOC1/PDBSIS/ARCHIVELOG/2019_restore/%b';
alter database rename file '+DATA_EXAP/prod/onlinelog/group_11.44586.994379457' to '+DATAC1/PDBSIS/DATAFILE/%b';
alter database rename file '+RECO_EXAP/prod/onlinelog/group_11.18169.994379457' to '+RECOC1/PDBSIS/ARCHIVELOG/2019_restore/%b';
alter database rename file '+DATA_EXAP/prod/onlinelog/group_12.44587.994379457' to '+DATAC1/PDBSIS/DATAFILE/%b';
alter database rename file '+RECO_EXAP/prod/onlinelog/group_12.17517.994379459' to '+RECOC1/PDBSIS/ARCHIVELOG/2019_restore/%b';
alter database rename file '+DATA_EXAP/prod/onlinelog/group_13.44588.994379459' to '+DATAC1/PDBSIS/DATAFILE/%b';
alter database rename file '+RECO_EXAP/prod/onlinelog/group_13.13155.994379461' to '+RECOC1/PDBSIS/ARCHIVELOG/2019_restore/%b';
alter database rename file '+DATA_EXAP/prod/onlinelog/group_14.44589.994379461' to '+DATAC1/PDBSIS/DATAFILE/%b';
alter database rename file '+RECO_EXAP/prod/onlinelog/group_14.1314.994379463' to '+RECOC1/PDBSIS/ARCHIVELOG/2019_restore/%b';
alter database rename file '+DATA_EXAP/prod/onlinelog/group_15.44590.994379463' to '+DATAC1/PDBSIS/DATAFILE/%b';
alter database rename file '+RECO_EXAP/prod/onlinelog/group_15.13301.994379465' to '+RECOC1/PDBSIS/ARCHIVELOG/2019_restore/%b';
alter database rename file '+DATA_EXAP/prod/onlinelog/group_16.44591.994379465' to '+DATAC1/PDBSIS/DATAFILE/%b';
alter database rename file '+RECO_EXAP/prod/onlinelog/group_16.13353.994379467' to '+RECOC1/PDBSIS/ARCHIVELOG/2019_restore/%b';
alter database rename file '+DATA_EXAP/prod/onlinelog/group_17.44592.994379467' to '+DATAC1/PDBSIS/DATAFILE/%b';
alter database rename file '+RECO_EXAP/prod/onlinelog/group_17.13717.994379469' to '+RECOC1/PDBSIS/ARCHIVELOG/2019_restore/%b';
alter database rename file '+DATA_EXAP/prod/onlinelog/group_18.44593.994379469' to '+DATAC1/PDBSIS/DATAFILE/%b';
alter database rename file '+RECO_EXAP/prod/onlinelog/group_18.14126.994379471' to '+RECOC1/PDBSIS/ARCHIVELOG/2019_restore/%b';
restore database;
switch datafile all;
}


