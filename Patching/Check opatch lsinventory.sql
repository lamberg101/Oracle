[oracle@exaimcpdb02-mgt OPatch]$ ./opatch lsinventory
Oracle Interim Patch Installer version 12.2.0.1.17
Copyright (c) 2020, Oracle Corporation.  All rights reserved.


Oracle Home       : /u01/app/oracle/product/19.0.0.0/dbhome_1
Central Inventory : /u01/app/oraInventory
   from           : /u01/app/oracle/product/19.0.0.0/dbhome_1/oraInst.loc
OPatch version    : 12.2.0.1.17
OUI version       : 12.2.0.7.0
Log file location : /u01/app/oracle/product/19.0.0.0/dbhome_1/cfgtoollogs/opatch/opatch2020-11-11_22-22-56PM_1.log

Lsinventory Output file location : /u01/app/oracle/product/19.0.0.0/dbhome_1/cfgtoollogs/opatch/lsinv/lsinventory2020-11-11_22-22-56PM.txt

--------------------------------------------------------------------------------
Local Machine Information::
Hostname: exaimcpdb02-mgt
ARU platform id: 226
ARU platform description:: Linux x86-64

Installed Top-level Products (1): 

Oracle Database 19c                                                  19.0.0.0.0
There are 1 products installed in this Oracle Home.


Interim patches (2) :

Patch  30557433     : applied on Wed Jul 08 00:25:20 WIB 2020
Unique Patch ID:  23305305
Patch description:  "Database Release Update : 19.6.0.0.200114 (30557433)"
   Created on 6 Jan 2020, 19:07:34 hrs PST8PDT
   Bugs fixed:
     30545281, 8476681, 14735102, 17428816, 19080742, 19697993, 20313356
     21374587, 21965541, 23296836, 23606241, 24687075, 25756945, 25806201
     25883179, 25986062, 25997810, 26476244, 26611353, 26739322, 26777814
     26872233, 27036163, 27044169, 27101798, 27126938, 27195935, 27244999
     27254335, 27359766, 27369515, 27406105, 27411022, 27423500, 27439716
     27453490, 27458357, 27489107, 27666312, 27710072, 27729678, 27846298
     27880025, 27934711, 27935464, 27941110, 27957203, 27967484, 28064977
     28072567, 28109326, 28125947, 28129791, 28181021, 28189466, 28204262

--------------------------------------------------------------------------------


cd $ORACLE_HOME/OPatch
./opatch lsinventory

./opatch lsinventory -detail > lsinv20201228_detail.txt