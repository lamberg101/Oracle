export ORACLE_SID=ODOPE
export ORACLE_HOME=/u02/app/oracle/product/12.1.0/dbhome_10
export PATH=/u02/app/oracle/product/12.1.0/dbhome_10/bin:/u02/app/oracle/product/12.1.0/dbhome_10/OPatch:$PATH
$ORACLE_HOME/bin/rman target / trace=/data/ODOPE/ODOPE_03062021_restore.log << EOF
run  {
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/undotbs2.6934.966526047' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/users.6932.966526047' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/fom_oms_prd.2348.966614087' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/fom_oms_prd.2367.966614145' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/fom_oms_prd.2357.966614151' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/fom_oms_prd.2372.966614183' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/fom_oms_prd_p22.18652.975276809' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/fom_oms_prd_p22.18653.975276873' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/fom_oms_prd_p22.18654.975276875' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/fom_oms_prd_p22.18655.975276877' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/fom_oms_prd_p22.18656.975276995' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/fom_oms_prd.21296.1040322591' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/fom_oms_prd_p22.21377.1045058365' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/fom_oms_prd_p22.9575.1045830351' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/fom_oms_prd.6615.1055462987' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/fom_oms_prd.6614.1055462989' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/fom_oms_prd.8948.1056375891' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/fom_oms_prd.8658.1060357815' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/fom_oms_prd.9039.1061839057' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/fom_oms_prd.13310.1063363449' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/preprdp_oms_user_tbs.15317.1063405533' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/preprdp_oms_user_tbs.15344.1063405541' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/preprdp_oms_user_tbs.351.1063405547' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/preprdp_oms_user_tbs.8588.1063405555' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/preprdp_oms_user_tbs.8587.1063405561' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/preprdp_oms_user_tbs.8586.1063405565' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/preprdp_oms_user_tbs.8585.1063405571' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/sysaux.8555.1063871245' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/sysaux.6637.1064444607' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/preprdp_oms_user_tbs.18803.1067895219' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/preprdp_oms_user_tbs.18718.1068370581' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/preprdp_oms_user_tbs.14549.1068673273' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/fom_oms_prd_p22.7209.1070574673' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/fom_oms_prd_p22.8788.1071068147' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/fom_oms_prd_p22.8789.1071201745' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/fom_oms_prd.8656.1072361515' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/fom_oms_prd.8657.1072361521' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/fom_oms_prd_p22.8784.1073107847' to '/data/ODOPE/datafile/%b';
set newname for datafile '+DATAC1/OPOPE62/DATAFILE/fom_oms_prd.9082.1074107485' to '/data/ODOPE/datafile/%b';
allocate channel c1 device type disk;
allocate channel c2 device type disk;
allocate channel c3 device type disk;
allocate channel c4 device type disk;
restore database;
switch datafile all;
recover database;
release channel ch1;
release channel ch2;
release channel ch3;
release channel ch4;
}

