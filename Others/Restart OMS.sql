[Forwarded from Eka Fitriani]
export ORACLE_HOME=/data/OEM12C/middleware
cd /data/OEM12C/middleware/bin
./emctl stop oms -all

export ORACLE_HOME=/data/OEM12C/middleware_new
cd /data/OEM12C/middleware_new/bin
./emctl start oms