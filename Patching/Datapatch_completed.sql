OLAP, Advanced Analytics and Real Application Testing options
[oracle@ccolladm02vm01 --]$ echo $ORACLE_SID
OTBIC2
[oracleOccolladm02vm01 -1$ echo $ORACLE_HOME
/u02/app/oracle/product/12.1.0/dbhome_4
[oracle@ccolladm02vm01 -1$ date
Fri Apr 30 19:42:11 VIB 2021
[oracleOccolladm02vm01 -1$ $ORACLE_HOME/OPatch/datapatch -verbose
SQL Patching tool version 12.1.0.2.0 Production on Fri Apr 30 19:42:14 2021 
Copyright (c) 2012, 2017, Oracle. All rights reserved.

Log file for this invocation: /u02/app/oracle/cfgtoollogs/sqlpatch/sqlpatch241527 2021 04 30 19 42 14/sqlpatchinvocation.log

Connecting to database...OK
Note: Datapatch will only apply or rollback SQL fixes for PDBs
   that are in an open state, no patches will be applied to closed PDBs. 
   Please refer to Note: Datapatch: Database 12c Post Patch SQL Automation 
   (Doc ID 1585822.1)
Bootstrapping registry and package to current versions...done
Determining current state...done

Current state of SQL patches:
Patch 27475603 (Database PSU 12.1.0.2.180417, Oracle JavaVM Component (APR2018)):
 Installed in the binary registry and CDB$ROOT OTBI PDB$SEED
Patch 27711172 0:
 Not installed in the binary or the SQL registry
Bundle series DBBP:
 ID 201020 in the binary registry and ID 201020 in PDB CDB$ROOT, ID 201020 in PDB PDB$SEED, ID 201020 in PDB OTBI

Adding patches to installation queue and performing prereq checks... 
Installation queue:
 For the following PDBs: CDB$ROOT PDB$SEED OTBI
  Nothing to roll back
  Nothing to apply

SQL Patching tool complete on Fri Apr 30 19:44:44 2021 
[oracle@ccolladmo2vm01 -]$ I

