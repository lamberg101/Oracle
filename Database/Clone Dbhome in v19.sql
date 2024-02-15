https://www.virtual-dba.com/blog/cloning-19c-oracle-home-on-rac/

1. Create Golden Image
--create using x11
$> ./runInstaller -createGoldImage -destinationLocation
/u01/app/oracle/product/19.0.0
Launching Oracle Database Setup Wizard…

--silent mode
$> ./runInstaller -silent -createGoldImage -destinationLocation $PATH


2. Unzip the image to your new oracle home 
$> cd /u01/app/oracle/product/19.0.0
$> unzip LINUX.X64_193000_db_home.zip -d /u01/app/oracle/product/19.0.0/dbhome_1


3. create the profile 
$> vi .19_profile 
export ORACLE_HOME=/u01/app/oracle/product/19.0.0/dbhome_1
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/jdk/jre/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib


4. runInstaller
--Using the GUI
$> cd /u01/app/oracle/product/19.0.0/db_clone
$> ./runInstaller --the rest look at the website


--Using the silent installation
$> ./runInstaller -ignorePrereq -silent \
oracle.install.option=INSTALL_DB_SWONLY \
UNIX_GROUP_NAME=oinstall \
ORACLE_HOME=/u01/app/oracle/product/19.0.0/dbhome_1 \
ORACLE_BASE=/u01/app/oracle \
oracle.install.db.InstallEdition=EE \
oracle.install.db.OSDBA_GROUP=dba \
oracle.install.db.OSOPER_GROUP=dba \
oracle.install.db.OSBACKUPDBA_GROUP=dba \
oracle.install.db.OSDGDBA_GROUP=dba \
oracle.install.db.OSKMDBA_GROUP=dba \
oracle.install.db.OSRACDBA_GROUP=dba \
oracle.install.db.CLUSTER_NODES=rac1,rac2 \ --hostname nya?
DECLINE_SECURITY_UPDATES=true


5. Run the root.sh scripts on both rac nodes as root user
#node1
[root@rac1 ~]/u01/app/oracle/product/19.0.0/db_clone/root.sh
--Check log
/u01/app/oracle/product/19.0.0/db_clone/install/root_rac1.ol_2021-05-18_16-31-2 3-661178137.log for the output of root script

#node2
[root@rac2 ~]/u01/app/oracle/product/19.0.0/db_clone/root.sh
--Check log
/u01/app/oracle/product/19.0.0/db_clone/install/root_rac2.ol_2021-05-18_16-31-3 1-497851499.log for the output of root script

Reference: Doc ID 2565006.1