SET DATABASE to ARCHIVELOG MODE

Pre activity:
backup pfile database OPPRN

sqlplus / as sysdba
CREATE PFILE='/home/oracle/ssi/OPPRN/pfile_opprn_20200130.txt' FROM SPFILE;

show parameter local
(ADDRESS=(PROTOCOL=TCP)(HOST=10.54.128.131)(PORT=1521))

activity:


1. check current status
SQL> archive log list

2. stop ogg
node1:
cd /u01/app/acfsmounts/oggacfs
cd goldengate
./ggsci
GGSCI (exa62bsdpdb1-mgt.telkomsel.co.id) 1>info all
GGSCI (exa62bsdpdb1-mgt.telkomsel.co.id) 1>Stop replicat rsrm*
GGSCI (exa62bsdpdb1-mgt.telkomsel.co.id) 1>info all
GGSCI (exa62bsdpdb1-mgt.telkomsel.co.id) 1>exit


3. set DB to mount mode
srvctl status database -d OPPRN
srvctl stop database -d OPPRN
srvctl start database -d OPPRN -o mount


4. enable archivelog
sqlplus / as sysdba
SQL> alter database archivelog;


5. startup db
srvctl stop database -d OPPRN
srvctl start database -d OPPRN
srvctl status database -d OPPRN

6. Crosscheck.
SQL> archive log list

7. start ogg
node1:
cd /u01/app/acfsmounts/oggacfs
cd goldengate
./ggsci
GGSCI (exa62bsdpdb1-mgt.telkomsel.co.id) 1>info all
GGSCI (exa62bsdpdb1-mgt.telkomsel.co.id) 1>start replicat rsrm*
GGSCI (exa62bsdpdb1-mgt.telkomsel.co.id) 1>info all
GGSCI (exa62bsdpdb1-mgt.telkomsel.co.id) 1>exit

SQL> show parameter local



***ENABLE REDO-SHIPPING***

1. Akses zdlra
2. Akses Protected database (yang akan di enable)
3. Open backup setting (Availability > Backup and Recovery > Backup setting)
4. Enable redo-transport 
- recovery appliance = zdlra
- virtual catalog user = ravpc1
- sesuaikan credential/server.
- other tabs biarkan default.
5. apply
6. wait sampai process selesai (usually it takes 10-15 minutes)


Note!
setelah process enabled redo-shipping selesai, crosscheck parameter listener juga.