1. backup gridhome exclude audit
nohup tar -czvf bkup_grid_home_12.1_exclude.tar.gz ./12.1.0 --exclude "./12.1.0/grid/rdbms/audit" > log.txt &


2.	Ensure that you verify the Oracle Inventory because OPatch accesses it to install the patches. 
$> cd $ORACLE_HOME/Opatch
$> ./opatch lsinventory 
$> ./opatch lspatches


3. Check version
$> asmcmd -V
asmcmd version 19.6.0.0.0

$> crsctl query  crs activeversion
Oracle Clusterware active version on the cluster is [19.0.0.0.0]

$> crsctl query crs releaseversion
Oracle High Availability Services release version on the local node is [19.0.0.0.0]

$> crsctl query crs softwareversion
Oracle Clusterware version on node [exa62bsdpdb1-mgt] is [19.0.0.0.0]



Copy new Opatch
$> mv /u01/app/19.0.0.0/grid/OPatch /u01/app/19.0.0.0/grid/OPatch.ori
$> cd /u01/app/oracle/source/
$> cp OPatch19.tar.Z /u01/app/19.0.0.0/grid
$> gunzip OPatch19.tar.Z
$> tar -xvf OPatch19.tar
$> chown -R oracle:oinstall /u01/app/19.0.0.0/grid/OPatch
$> $ORACLE_HOME/OPatch/opatch version




3. Unzip file
$> unzip -d <PATCH_TOP_DIR>  p32149105_196000DBRU_Linux-x86-64.zip 


4.	Check Confilict
$ cd <PATCH_TOP_DIR>/32149105
$ORACLE_HOME/OPatch/opatch prereq CheckConflictAgainstOHWithDetail -phBaseDir /u01/app/oracle/source/32226239/32218454




6. Create file /tmp/patch_list_dbhome.txt
vi /tmp/patch_list_dbhome.txt
/u01/app/oracle/source/30070242/29972716


7. Run opatch command to check if enough free space is available in the Database Home
$ORACLE_HOME/OPatch/opatch prereq CheckSystemSpace -phBaseFile /tmp/patch_list_dbhome.txt

$> . .OPRCSBSD_profile
$> srvctl status home -o /u01/app/oracle/product/11.2.0.4/dbhome_1 -n exa62bsdpdb1-mgt -s /home/oracle/status11.txt



5.	Ensure all services running are shut down from the Oracle home.
--shutdown all service??


Apply patch
Login as "ROOT USER"
$> /u01/app/19.0.0.0/grid/crs/install/rootcrs.sh -prepatch
 Login as "GRID USER"
$> /u01/app/19.0.0.0/grid/OPatch/opatch apply -oh /u01/app/19.0.0.0/grid -local /u01/app/oracle/source/32226239/32218454
 Login as "ROOT USER"
$> /u01/app/19.0.0.0/grid/rdbms/install/rootadd_rdbms.sh
$> /u01/app/19.0.0.0/grid/crs/install/rootcrs.sh -postpatch



8. opatch auto
opatchauto apply /u01/app/oracle/source/30070242 -oh /u01/app/12.1.0/grid

 START HOME EXCEPT 19 HOME
$> . .OPRCSBSD_profile 
$> srvctl start home -o /u01/app/oracle/product/11.2.0.4/dbhome_1  -s /tmp/db11.txt -n exa62bsdpdb1-mgt


9. datapatch 
$ORACLE_HOME/OPatch/datapatch -verbose

file patch nya sudah di taruk di sini "/u01/app/oracle/source"