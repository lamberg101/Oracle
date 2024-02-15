NODE 1 EXATBS:
-------------

backup grid_home
=================
cd /u01/app
nohup tar -czvf bkup_grid_home_19c_exclude.tar.gz ./19.0.0.0 --exclude "./19.0.0.0/grid/rdbms/audit" > log19.txt &

backup db_home_19
=================
cd /u01/app/oracle/product
nohup tar -czvf bkup_rdbms_home_19_exclude.tar.gz ./19.0.0.0 --exclude "./19.0.0.0/dbhome_1/rdbms/audit" > log19.txt &

==================
prereq  grid home
==================

[oracle@exa62tbspdb1-mgt ~]$ . .grid_profile 
[oracle@exa62tbspdb1-mgt ~]$ cd /u01/app/oracle/source/32847378/32847378
[oracle@exa62tbspdb1-mgt 32847378]$ $ORACLE_HOME/OPatch/opatch version
OPatch Version: 12.2.0.1.24

OPatch succeeded.
[oracle@exa62tbspdb1-mgt 32847378]$ $ORACLE_HOME/OPatch/opatch prereq CheckConflictAgainstOHWithDetail -phBaseDir /u01/app/oracle/source/32847378/32847378
Oracle Interim Patch Installer version 12.2.0.1.24
Copyright (c) 2021, Oracle Corporation.  All rights reserved.

PREREQ session

Oracle Home       : /u01/app/19.0.0.0/grid
Central Inventory : /u01/app/oraInventory
   from           : /u01/app/19.0.0.0/grid/oraInst.loc
OPatch version    : 12.2.0.1.24
OUI version       : 12.2.0.7.0
Log file location : /u01/app/19.0.0.0/grid/cfgtoollogs/opatch/opatch2021-09-09_11-38-46AM_1.log

Invoking prereq "checkconflictagainstohwithdetail"

Prereq "checkConflictAgainstOHWithDetail" passed.

OPatch succeeded.
===================
prereq dbhome 19:
===================
[oracle@exa62tbspdb1-mgt ~]$ . .OPGIS19 
[oracle@exa62tbspdb1-mgt ~]$ sqlplus "/ as sysdba"

SQL*Plus: Release 19.0.0.0.0 - Production on Thu Sep 9 11:40:39 2021
Version 19.10.0.0.0

Copyright (c) 1982, 2020, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.10.0.0.0

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.10.0.0.0
[oracle@exa62tbspdb1-mgt ~]$ . .OPGIS19 
[oracle@exa62tbspdb1-mgt ~]$ cd /u01/app/oracle/source/32847378/32847378
[oracle@exa62tbspdb1-mgt 32847378]$ $ORACLE_HOME/OPatch/opatch version
OPatch Version: 12.2.0.1.24

OPatch succeeded.
[oracle@exa62tbspdb1-mgt 32847378]$ $ORACLE_HOME/OPatch/opatch prereq CheckConflictAgainstOHWithDetail -phBaseDir /u01/app/oracle/source/32847378/32847378
Oracle Interim Patch Installer version 12.2.0.1.24
Copyright (c) 2021, Oracle Corporation.  All rights reserved.

PREREQ session

Oracle Home       : /u01/app/oracle/product/19.0.0.0/dbhome_1
Central Inventory : /u01/app/oraInventory
   from           : /u01/app/oracle/product/19.0.0.0/dbhome_1/oraInst.loc
OPatch version    : 12.2.0.1.24
OUI version       : 12.2.0.7.0
Log file location : /u01/app/oracle/product/19.0.0.0/dbhome_1/cfgtoollogs/opatch/opatch2021-09-09_11-41-28AM_1.log

Invoking prereq "checkconflictagainstohwithdetail"

Prereq "checkConflictAgainstOHWithDetail" passed.

OPatch succeeded.

[oracle@exa62tbspdb1-mgt 32847378]$ $ORACLE_HOME/OPatch/opatch lspatches
32218454;Database Release Update : 19.10.0.0.210119 (32218454)
32222571;OCW Interim patch for 32222571

OPatch succeeded.
[oracle@exa62tbspdb1-mgt 32847378]$ 


=====================================================================================================================
check OPacth version:
=====================================================================================================================
[oracle@exa62tbspdb1-mgt ~]$ $ORACLE_HOME/OPatch/opatch version
OPatch Version: 12.2.0.1.24

OPatch succeeded.

=====================================================================================================================
check anlyze (using root):
=====================================================================================================================
# /u01/app/19.0.0.0/grid/OPatch/opatchauto apply /u01/app/oracle/source/32847378/32847378 -analyze
# /u01/app/oracle/product/19.0.0.0/dbhome_1/OPatch/opatchauto apply /u01/app/oracle/source/32847378/32847378 -analyze

=====================================================================================================================
Check status home (using oracle)
=====================================================================================================================

. .OPCITTBS_profile 
[oracle@exa62tbspdb1-mgt ~]$ srvctl status home -o /u01/app/oracle/product/11.2.0.4/dbhome_1 -n exa62tbspdb1-mgt -s /home/oracle/statefile/status11.txt
Database opremnotbs is running on node exa62tbspdb1-mgt

. .OPC2PM 
srvctl status home -o /u01/app/oracle/product/12.1.0.2/dbhome_1 -n exa62tbspdb1-mgt -s /home/oracle/statefile/status121.txt

. .OPC2PODDTBS_profile
srvctl status home -o /u01/app/oracle/product/18.0.0.0/dbhome_1 -n exa62tbspdb1-mgt -s /home/oracle/statefile/status18.txt
 
. .OPGIS19 
srvctl status home -o /u01/app/oracle/product/19.0.0.0/dbhome_1 -n exa62tbspdb1-mgt -s /home/oracle/statefile/status19.txt

. .PRODHR-profile 
srvctl status home -o /u01/app/oracle/product/12.1.0.2_EBS/dbhome_1 -n exa62tbspdb1-mgt -s /home/oracle/statefile/statusprodhr.txt



=====================================================================================================================
Stop home
=====================================================================================================================

. .OPCITTBS_profile 
srvctl stop home -o /u01/app/oracle/product/11.2.0.4/dbhome_1 -t IMMEDIATE -s /home/oracle/statefile/db11.txt -n exa62tbspdb1-mgt

srvctl stop home -o /u01/app/oracle/product/11.2.0.4/dbhome_1 -t IMMEDIATE -s /home/oracle/statefile/db11_ORPRMD.txt -n exa62tbspdb1-mgt

. .OPC2PM
srvctl stop home -o /u01/app/oracle/product/12.1.0.2/dbhome_1 -t IMMEDIATE -s /home/oracle/statefile/db121.txt -node exa62tbspdb1-mgt

. .OPC2PODDTBS_profile
srvctl stop home -o /u01/app/oracle/product/18.0.0.0/dbhome_1 -t IMMEDIATE -s /home/oracle/statefile/db18.txt -node exa62tbspdb1-mgt

. .OPGIS19 
srvctl stop home -o /u01/app/oracle/product/19.0.0.0/dbhome_1 -t IMMEDIATE -s /home/oracle/statefile/db19.txt -node exa62tbspdb1-mgt

. .PRODHR-profile 
srvctl stop home -o /u01/app/oracle/product/12.1.0.2_EBS/dbhome_1 -t IMMEDIATE -s /home/oracle/statefile/dbprodhr.txt -node exa62tbspdb1-mgt


=====================================================================================================================
Apply patch on grid home (using root)
=====================================================================================================================

# /u01/app/19.0.0.0/grid/OPatch/opatchauto apply /u01/app/oracle/source/32847378/32847378 -oh /u01/app/19.0.0.0/grid

=====================================================================================================================
Start home except 19 home
=====================================================================================================================
. .OPCITTBS_profile 
srvctl start home -o /u01/app/oracle/product/11.2.0.4/dbhome_1  -s /home/oracle/statefile/db11.txt -n exa62tbspdb1-mgt
. .OPC2PM
srvctl start home -o /u01/app/oracle/product/12.1.0.2/dbhome_1  -s /home/oracle/statefile/db121.txt -n exa62tbspdb1-mgt
. .OPC2PODDTBS_profile
srvctl start home -o /u01/app/oracle/product/18.0.0.0/dbhome_1  -s /home/oracle/statefile/db18.txt -n exa62tbspdb1-mgt
. .PRODHR-profile 
srvctl start home -o /u01/app/oracle/product/12.1.0.2_EBS/dbhome_1 -s /home/oracle/statefile/dbprodhr.txt -n exa62tbspdb1-mgt

=====================================================================================================================
apply Patch on db home 19 (using root)
=====================================================================================================================

# /u01/app/oracle/product/19.0.0.0/dbhome_1/OPatch/opatchauto apply /u01/app/oracle/source/32847378/32847378 -oh /u01/app/oracle/product/19.0.0.0/dbhome_1

=====================================================================================================================
Start home 19 
=====================================================================================================================
. .OPGIS19 
srvctl start home -oraclehome /u01/app/oracle/product/19.0.0.0/dbhome_1  -statefile  /home/oracle/statefile/db19.txt -node exa62tbspdb1-mgt



NODE 2 EXATBS
--------------
=====================================================================================================================
check OPacth version:
=====================================================================================================================
[oracle@exa62tbspdb2-mgt ~]$ $ORACLE_HOME/OPatch/opatch version
OPatch Version: 12.2.0.1.24

OPatch succeeded.

=====================================================================================================================
check anlyze (using root):
=====================================================================================================================
# /u01/app/19.0.0.0/grid/OPatch/opatchauto apply /u01/app/oracle/source/32847378/32847378 -analyze
# /u01/app/oracle/product/19.0.0.0/dbhome_1/OPatch/opatchauto apply /u01/app/oracle/source/32847378/32847378 -analyze

=====================================================================================================================
Check status home
=====================================================================================================================

. .OPCITTBS_profile 
srvctl status home -oraclehome /u01/app/oracle/product/11.2.0.4/dbhome_1 -node exa62tbspdb2-mgt -statefile /home/oracle/statefile/status11.txt

. .OPC2PM 
srvctl status home -oraclehome /u01/app/oracle/product/12.1.0.2/dbhome_1 -node exa62tbspdb2-mgt -statefile /home/oracle/statefile/status121.txt

. .OPC2PODDTBS_profile
srvctl status home -oraclehome /u01/app/oracle/product/18.0.0.0/dbhome_1 -node exa62tbspdb2-mgt -statefile /home/oracle/statefile/status18.txt
 
. .OPGIS19 
srvctl status home -oraclehome /u01/app/oracle/product/19.0.0.0/dbhome_1 -node exa62tbspdb2-mgt -statefile /home/oracle/statefile/status19.txt

. .PRODHR-profile 
srvctl status home -oraclehome /u01/app/oracle/product/12.1.0.2_EBS/dbhome_1 -node exa62tbspdb2-mgt -statefile /home/oracle/statefile/statusprodhr.txt



=====================================================================================================================
Stop home
=====================================================================================================================

. .OPCITTBS_profile 
srvctl stop home -oraclehome /u01/app/oracle/product/11.2.0.4/dbhome_1 -stopoption IMMEDIATE -statefile /home/oracle/statefile/db11.txt -n exa62tbspdb2-mgt

. .OPC2PM
srvctl stop home -oraclehome /u01/app/oracle/product/12.1.0.2/dbhome_1 -stopoption IMMEDIATE -statefile /home/oracle/statefile/db121.txt -node exa62tbspdb2-mgt

. .OPC2PODDTBS_profile
srvctl stop home -oraclehome /u01/app/oracle/product/18.0.0.0/dbhome_1 -stopoption IMMEDIATE -statefile /home/oracle/statefile/db18.txt -node exa62tbspdb2-mgt

. .OPGIS19 
srvctl stop home -oraclehome /u01/app/oracle/product/19.0.0.0/dbhome_1 -stopoption IMMEDIATE -statefile /home/oracle/statefile/db19.txt -node exa62tbspdb2-mgt

. .PRODHR-profile 
srvctl stop home -oraclehome /u01/app/oracle/product/12.1.0.2_EBS/dbhome_1 -stopoption IMMEDIATE -statefile /home/oracle/statefile/dbprodhr.txt -node exa62tbspdb2-mgt


=====================================================================================================================
Apply patch on grid home (using root)
=====================================================================================================================

# /u01/app/19.0.0.0/grid/OPatch/opatchauto apply /u01/app/oracle/source/32847378/32847378 -oh /u01/app/19.0.0.0/grid

=====================================================================================================================
Start home except 19 home
=====================================================================================================================

. .OPCITTBS_profile 
srvctl start home -oraclehome /u01/app/oracle/product/11.2.0.4/dbhome_1  -statefile /home/oracle/statefile/db11.txt -node exa62tbspdb2-mgt
. .OPC2PM
srvctl start home -oraclehome /u01/app/oracle/product/12.1.0.2/dbhome_1  -statefile /home/oracle/statefile/db121.txt -node exa62tbspdb2-mgt
. .OPC2PODDTBS_profile
srvctl start home -oraclehome /u01/app/oracle/product/18.0.0.0/dbhome_1  -statefile /home/oracle/statefile/db18.txt -node exa62tbspdb2-mgt
. .PRODHR-profile 
srvctl start home -oraclehome /u01/app/oracle/product/12.1.0.2_EBS/dbhome_1 -statefile /home/oracle/statefile/dbprodhr.txt -node exa62tbspdb2-mgt

=====================================================================================================================
apply Patch on db home 19 (using root)
=====================================================================================================================

# /u01/app/oracle/product/19.0.0.0/dbhome_1/OPatch/opatchauto apply /u01/app/oracle/source/32847378/32847378 -oh /u01/app/oracle/product/19.0.0.0/dbhome_1

=====================================================================================================================
Start home 19 
=====================================================================================================================
19c
====
. .OPGIS19 
srvctl start home -oraclehome /u01/app/oracle/product/19.0.0.0/dbhome_1  -statefile  /home/oracle/statefile/db19.txt -node exa62tbspdb2-mgt





