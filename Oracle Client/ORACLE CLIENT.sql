NOTE! 
-- tiap OS beda dir installernya.
-- tes (tnsping, telnet) kalau belum bisa --> kendala firewall
--SOURCE CLIENT FILE
10.59.100.244
10.53.69.204 --disini pake 12
/data/OEM12C/source --versi 19
source oracle client: di server oem
/data/OEM12C/client --versi 12

------------------------------------------------------------------------------------------------------------

--CREATE DIRECTORY 
mkdir -p /apps/oracle/product


--COPY FILE 
scp Client_19.tar oracle@10.2.232.52:/apps/oracle/product


--UNTAR FILE
$> mv Client_19.tar /apps5/verona_revamp/
$> cd /apps5/verona_revamp/
$> tar -xvf Client_19.tar
$> chmod -R 777 client_19g


--SET BASH_PROFILE 
ORACLE_BASE=/apps/oracle/
export ORACLE_BASE
ORACLE_HOME=/apps/oracle/product/client_1
export ORACLE_HOME
PATH=$ORACLE_HOME/bin:/usr/bin:/usr/sbin:$PATH
export PATH
LD_LIBRARY_PATH=$ORACLE_HOME/lib
export LD_LIBRARY_PATH


tar -xvf Client_12.tar
chmod -R 777 client_1



ORACLE_BASE=/apps/oracle/
export ORACLE_BASE
ORACLE_HOME=/apps/oracle/product/client_11g
export ORACLE_HOME
PATH=$ORACLE_HOME/bin:/usr/bin:/usr/sbin:$PATH
export PATH
LD_LIBRARY_PATH=$ORACLE_HOME/lib
export LD_LIBRARY_PATH







