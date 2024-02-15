--Check BEFORE

ASM


--START DATABASE
. .OPRMD9IT_profile
srvctl status database -d TSTING19
srvctl stop database -d TSTING19
srvctl start database -d TSTING19
srvctl status database -d TSTING19




--AKSES DBCA
cd $ORACLE_HOME/bin
export DISPLAY=10.2.230.111:0.0;
./dbca



-----
srvctl config database -d OPDGPOS
srvctl start database -d OPDGPOS -o mount
----------------------------------------------------------------------------------------------------------------


DROP MANUAL

--CLUSTER_DATABASE TO FALSE
alter system set cluster_database=FALSE scope=spfile sid='*';

--SHUTDOWN DB
shutdown immediate;
shutdown / klw cluster pake srvcrl

--STARTUP DB 
startup mount exclusive restrict;

--DROP DB
drop database;



