1. BACKUP PFILE 
SQL> create pfile='/home/oracle/ssi/slam/PRODHR/PRODHR_pfile_24062021.txt' from spfile;

2.STARTUP NOMOUNT PRODHR DI MCD 106
SQL> startup nomount pfile ='/home/oracle/PRODHR/PRODHR_pfile_24062021.txt';

3. CREATE SPFILE FROM PFILE
SQL> create spfile  from pfile='/home/oracle/PRODHR/oprmd9it_pfile_23092020.txt';


4.RESTORE CONTROL FILE === backup control file nya kaga dipisah 
RMAN> restore controlfile from '/datadump16/prodhr/db/control_4h01pj7m_1_1.bkp';

5. ALTER DATABASE MOUNT
RMAN> alter database mount;


6. CROSSHCheck BACKUP --hasil backup dipindah ke dalam satu folder lalu jalankan catalog

#CATALOG -- Check dir all arch nya, lalu jalankan catalog, satu per satu.

RMAN> catalog start with '/datadump1/prodhr/db';
RMAN> catalog start with '/datadump2/prodhr/db/';
RMAN> catalog start with '/datadump4/prodhr/db/';
RMAN> catalog start with '/datadump5/prodhr/db/';
RMAN> catalog start with '/datadump6/prodhr/db/';
RMAN> catalog start with '/datadump7/prodhr/db/';
RMAN> catalog start with '/datadump8/prodhr/db/';
RMAN> catalog start with '/datadump9/prodhr/db/';
RMAN> catalog start with '/datadump10/prodhr/db/';
RMAN> catalog start with '/datadump11/prodhr/db/';
RMAN> catalog start with '/datadump12/prodhr/db/';
RMAN> catalog start with '/datadump13/prodhr/db/';
RMAN> catalog start with '/datadump14/prodhr/db/';
RMAN> catalog start with '/datadump15/prodhr/db/';
RMAN> catalog start with '/datadump16/prodhr/db/';
RMAN> catalog start with '/datadump1/prodhr/arch/';
RMAN> catalog start with '/datadump2/prodhr/arch/';
RMAN> catalog start with '/datadump4/prodhr/arch/';
RMAN> catalog start with '/datadump5/prodhr/arch/';
RMAN> catalog start with '/datadump6/prodhr/arch/';
RMAN> catalog start with '/datadump7/prodhr/arch/';
RMAN> catalog start with '/datadump8/prodhr/arch/';
RMAN> catalog start with '/datadump9/prodhr/arch/';
RMAN> catalog start with '/datadump10/prodhr/arch/';
RMAN> catalog start with '/datadump11/prodhr/arch/';
RMAN> catalog start with '/datadump12/prodhr/arch/';
RMAN> catalog start with '/datadump13/prodhr/arch/';
RMAN> catalog start with '/datadump14/prodhr/arch/';
RMAN> catalog start with '/datadump15/prodhr/arch/';
RMAN> catalog start with '/datadump16/prodhr/arch/';







export ORACLE_SID=PRODHR
export ORACLE_HOME=/u02/app/oracle/product/12.1.0/dbhome_10
#export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/OPatch:$PATH
export PATH=/u02/app/oracle/product/12.1.0/dbhome_10/bin:/u02/app/oracle/product/12.1.0/dbhome_10/OPatch:$PATH
$ORACLE_HOME/bin/rman target / trace=/home/oracle/PRODHR/prodhr_clone.txt << EOF
run  
{
set newname for datafile '+DATAC5/PRODHR/DATAFILE/system.6647.1039705665' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/system.6677.1039706325' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/system.6679.1039707061' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/system.6681.1039707287' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/system.6649.1039705711' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/system.6680.1039707119' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/system.6654.1039706065' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/system.6595.1039708223' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/system.6553.1039708129' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/system.6683.1039707445' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/system.6652.1039705895' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/system.6561.1039707789' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/system.6630.1039707561' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/sysaux.6663.1039706259' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_undots1.6545.1039705217' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_undots1.6552.1039705627' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_undots1.6646.1039705627' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_undots1.6546.1039705279' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_undots1.6550.1039705521' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/applsysd.6628.1039707583' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/applsysd.6592.1039708231' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/applsysd.6554.1039707611' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/applsysd.6602.1039708243' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/applsysd.2655.1039708473' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/applsysd.6662.1039706249' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/applsysd.6555.1039707623' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/applsysd.6626.1039708247' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/applsysd.6656.1039706149' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/applsysd.2585.1039708443' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/applsysd.6660.1039706215' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/applsysd.6526.1039707597' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/applsysd.6591.1039708241' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/applsysd.2656.1039708459' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/applsysd.6661.1039706233' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/applsysd.6644.1039707567' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/applsysd.6601.1039708221' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/applsysd.2584.1039708423' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/applsysd.2592.1039708405' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/applsysd.6682.1039707535' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/applsysd.6657.1039706165' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/applsysd.6580.1039707553' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/applsysd.6658.1039706181' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/applsysd.6659.1039706199' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_archive.6522.1039707479' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_archive.6549.1039705519' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_interface.6648.1039705709' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_media.6650.1039705785' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_media.6547.1039705305' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_nologging.6599.1039708025' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_queues.6594.1039707899' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_seed.6570.1039702753' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_summary.6551.1039705549' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tools.2653.1039708493' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_data.6537.1039702751' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_data.6524.1039702753' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_data.6528.1039702751' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_data.6530.1039702751' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_data.6593.1039702753' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_data.6532.1039702751' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_data.6539.1039702753' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_data.6569.1039702753' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_data.6533.1039702751' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_data.6538.1039702753' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_data.6588.1039702755' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_data.6525.1039702755' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_data.6534.1039702751' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_data.6529.1039702751' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_data.6578.1039702755' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_data.6531.1039702751' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_data.6640.1039702753' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_idx.6597.1039702755' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_idx.6548.1039705399' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_idx.6543.1039702755' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_idx.6587.1039702753' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_idx.6535.1039702751' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_idx.6544.1039705191' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_idx.6629.1039702755' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_idx.6643.1039702751' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_idx.6542.1039702755' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_idx.6571.1039702753' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_idx.6582.1039702755' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_idx.6536.1039702751' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_idx.2337.1039702751' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_idx.6541.1039702753' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tx_idx.6540.1039702753' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/audit_trail.2652.1039708495' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/audit_trail.6664.1039706267' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/csd.6589.1039707639' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/csx.2651.1039708495' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/ctxd.6665.1039706267' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/ctxd.6590.1039707639' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/discoverer.2752.1039708357' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/dwtelkom_tbs.2650.1039708495' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/hrd.6666.1039706267' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/hrd.6596.1039707639' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/hrd.6627.1039708251' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/hrd.2649.1039708497' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/hrd.6667.1039706269' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/hrd.6556.1039707641' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/hrd.6615.1039708251' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/hrd.2648.1039708497' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayx.6668.1039706269' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayx.6575.1039707641' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/igid.6619.1039708251' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/owapub.2647.1039708499' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/pa_user.6669.1039706271' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/perfstat.6653.1039705969' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/perfstat.6581.1039702755' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/perfstat.6651.1039705813' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/perfstat.6560.1039707781' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/portal.6655.1039706109' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/xxhrd.2654.1039708489' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/xxhrx.6577.1039707641' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.6624.1039708253' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.2644.1039708501' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.6672.1039706273' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.2578.1039708253' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.6616.1039707645' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.2643.1039708503' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.6673.1039706275' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.6692.1039708253' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.6622.1039708251' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.2646.1039708499' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.6670.1039706271' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.6557.1039707643' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.6625.1039708253' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.2645.1039708501' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.6671.1039706273' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.6527.1039707645' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.2642.1039708505' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.6674.1039706275' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.6691.1039708255' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.6558.1039707647' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.2641.1039708507' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.6675.1039706277' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.2755.1039708255' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.6559.1039707647' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.6676.1039706279' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.2754.1039708255' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/idpayd.2753.1039708257' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/system.6600.1039708173' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_seed.6678.1039706961' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_ts_tools.6579.1039707643' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_undotbs1.2583.1039728007' to '/data/PRODHR/datafile/%b';
set newname for datafile '+DATAC5/PRODHR/DATAFILE/apps_undotbs2.2662.1039728029' to '/data/PRODHR/datafile/%b';
restore database;
switch datafile all;
recover database;
}

RMAN> alter database open resetlogs;
