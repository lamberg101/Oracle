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


****nohup

export ORACLE_HOME=/apps/oracle/product/12.1.0/dbhome_1
export ORACLE_SID=OPPOM
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/OPatch:$PATH
$ORACLE_HOME/bin/rman target / trace=/home/oracle/restore_OPPOM62.log << EOF
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