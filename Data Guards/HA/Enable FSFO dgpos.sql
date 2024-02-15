PRIMARY = OPDGPOS19 (exaimcpdb-scan)
STANDBY = OPDGPOSTBS (exapdb62b-scan)
enable fsfo di primary:
DGMGRL> enable fast_start failover;
Start observer:
ip observer:
10.49.132.75 (oam)
10.59.102.207 (service)
10.49.10.197 (oam)
10.38.18.66 (service)

edit sqlnet.ora on /apps/oracle/product/19.0.0/client_1/network/admin
NAMES.DIRECTORY_PATH= (TNSNAMES, ONAMES, HOSTNAME,EZCONNECT)
WALLET_LOCATION=(SOURCE=(METHOD=FILE)(METHOD_DATA=(DIRECTORY=/apps/oracle/product/19.0.0/client_1/wallet)))
SQLNET.WALLET_OVERRIDE=TRUE

mkstore -wrl /apps/oracle/product/19.0.0/client_1/wallet -create
mkstore -wrl /apps/oracle/product/19.0.0/client_1/wallet -createCredential 'OPDGPOS19' sys Xxxxxxxxxxxxxxxx
mkstore -wrl /apps/oracle/product/19.0.0/client_1/wallet -createCredential 'OPDGPOSTBS' sys Xxxxxxxxxxxxxxxx

on dgbsdpdb1
start observer obbsddgpos in background logfile is '/apps/dataguard/log/OPDGPOS19.log' connect identifier is OPDGPOS19 trace_level is support
on dgtbspdb1
start observer obtbsdgpos in background logfile is '/apps/dataguard/log/OPDGPOSTBS.log' connect identifier is OPDGPOSTBS trace_level is support	
