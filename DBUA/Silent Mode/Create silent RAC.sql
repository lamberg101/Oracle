
--CREATE GOLDEN IMAGE (DI SERVER SORUCE)
$> cd /u02/app/oracle/product/19.0.0.0/dbhome3
$> ./runInstaller -silent -createGoldImage -destionationLocation /nfs_dump
lalu copy ke server target


--------------------------------------------------------------------------------------

--INTSAL DB RAC SILENT
[oracle@hostname dbhome1]$ ./runInstaller -igonrePrereq -silent \
oracle.install.option=INSTALL_DB_SWONLY \
UNIX_GROUP_NAME=oninstall \
ORACLE_HOME=/u01/app/oracle/product/19.3.1/dbhome1 \
ORACLE_BASE=/u01/app/oracle \
oracle.install.db.InstallEdition=EE \
oracle.install.db.OSDBA_GROUP=dba \
oracle.install.db.OSOPER_GROUP=dba \
oracle.install.db.OSBACKUPDBA_GROUP=dba \
oracle.install.db.OSDGDBA_GROUP=dba \
oracle.install.db.OSKMDBA_GROUP=dba \
oracle.install.db.OSRACDBA_GROUP=dba \
oracle.install.db.CLUSTER_NODES=crmbeddb1,crmbeddb2 \

--------------------------------------------------------------------------------------

--CREATE DB RAC SILENT
dbca -silent -createDatabase \
  -templateName General_Purpose.dbc \
  -gdbname ODESB -responseFile NO_VALUE \
  -characterSet AL32UTF8 \
  -sysPassword MyPassword123 \
  -systemPassword MyPassword123 \
  -databaseType MULTIPURPOSE \
  -automaticMemoryManagement false \
  -totalMemory 4024 \
  -redoLogFileSize 250 \
  -emConfiguration NONE \
  -ignorePreReqs \
  -nodelist crmbeddb1,crmbeddb2 \
  -storageType ASM \
  -diskGroupName +DATA \
  -recoveryGroupName +DATA \
