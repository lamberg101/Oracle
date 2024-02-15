ODOPE.__data_transfer_cache_size=0
ODOPE.__db_cache_size=3791650816
ODOPE.__java_pool_size=16777216
ODOPE.__large_pool_size=16777216
ODOPE.__oracle_base='/data/oracle'#ORACLE_BASE set from environment
ODOPE.__pga_aggregate_target=3G
ODOPE.__sga_target=8G
ODOPE.__shared_io_pool_size=318767104
ODOPE.__shared_pool_size=4345298944
ODOPE.__streams_pool_size=16777216
*._shared_pool_reserved_pct=10
*.audit_file_dest='/data/oracle/admin/ODOPE/adump'
*.audit_trail='db'
*.compatible='12.1.0.2.0'
*.control_files='/data/ODOPE/controlfile/control_01.ctl'
*.cpu_count=16
*.db_block_size=8192
*.db_create_file_dest='/data/ODOPE/datafile'
*.db_domain=''
*.db_name='OPOPE62'
*.db_recovery_file_dest='/data/ODOPE/fra'
*.db_recovery_file_dest_size=322122547200
*.diagnostic_dest='/data/oracle'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=ODOPEXDB)'
*.log_archive_format='%t_%s_%r.dbf'
*.open_cursors=300
*.pga_aggregate_target=3G
*.processes=5985
*.resource_manager_plan='default_plan'
*.sessions=9000
*.sga_max_size=8G
*.sga_target=8G
*.transactions=9900


startup nomount pfile ='/data/ODOPE/pfile_ODOPE_04062021.txt';

restore controlfile from '/datadump15/opope62/db/control_20210603_7300efdc_1_1.bkp';


catalog start with '/data/ODOPE/backup/arch/';
catalog start with '/data/ODOPE/backup/db/';


/datadump1/opope62/db/

--------------------------------------------------------------------------------------------
catalog start with '/datadump1/opope62/db/OPOPE62_db_20210602_5b00e5ph_1_1.bk';
catalog start with '/datadump3/opope62/db/';
catalog start with '/datadump5/opope62/db/';
catalog start with '/datadump7/opope62/db/';
catalog start with '/datadump9/opope62/db/';
catalog start with '/datadump13/opope62/db/';
catalog start with '/datadump11/opope62/db/';
catalog start with '/datadump1/opope62/arch/';
catalog start with '/datadump3/opope62/arch/';
catalog start with '/datadump7/opope62/arch/';
catalog start with '/datadump7/opope62/arch/';
catalog start with '/datadump5/opope62/arch/';
catalog start with '/datadump9/opope62/arch/';
catalog start with '/datadump11/opope62/arch/';
catalog start with '/datadump15/opope62/arch/';
catalog start with '/datadump13/opope62/arch/';


--------------------------------------------------------------------------------------------

--Colelct
select 'set newname for datafile '''||file_name||''' to ''/data/ODOPE/datafile/%b'';' from dba_data_files;

$ vi restore.sh

export ORACLE_SID=ODOPE
export ORACLE_HOME=/u02/app/oracle/product/12.1.0/dbhome_10
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/OPatch:$PATH
$ORACLE_HOME/bin/rman target / trace=/data/ODOPE/ODOPE_03062021_restore.log << EOF
run  {
crosscheck backup;
crosscheck archivelog all;
allocate channel c1 device type disk;
allocate channel c2 device type disk;
allocate channel c3 device type disk;
allocate channel c4 device type disk;
allocate auxiliary channel d1 device type disk;
allocate auxiliary channel d2 device type disk;
allocate auxiliary channel d3 device type disk;
allocate auxiliary channel d4 device type disk;
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
restore database;
recover database;
}


------------------------------------------------------------------------------------------



/data/ODOPE/redolog/group_21.233242.1000475289
+RECOC1/OPOPE62/ONLINELOG/group_21.233242.1000475289

