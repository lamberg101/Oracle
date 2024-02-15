1. check conflict

/u01/app/oracle/product/12.1.0.2_EBS/dbhome_1/OPatch/opatch prereq CheckConflictAgainstOHWithDetail -phBaseDir /u01/app/oracle/source/30070242/29972716
/u01/app/oracle/product/12.1.0.2_EBS/dbhome_1/OPatch/opatch prereq CheckConflictAgainstOHWithDetail -phBaseDir /u01/app/oracle/source/30070242/29938464

/u01/app/oracle/product/12.1.0.2_EBS/dbhome_1/OPatch/opatch prereq CheckConflictAgainstOHWithDetail -phBaseDir /u01/app/oracle/source/30070242/29938481
/u01/app/oracle/product/12.1.0.2_EBS/dbhome_1/OPatch/opatch prereq CheckConflictAgainstOHWithDetail -phBaseDir /u01/app/oracle/source/30070242/26983807

--atau gunakan oracle home 
$ORACLE_HOME/OPatch/opatch prereq CheckConflictAgainstOHWithDetail -phBaseDir /home/oracle/patchbug/28889389


2. Create file /tmp/patch_list_dbhome.txt

vi /tmp/patch_list_dbhome.txt

/u01/app/oracle/source/30070242/29972716
/u01/app/oracle/source/30070242/29938464
/u01/app/oracle/source/30070242/26983807
/u01/app/oracle/source/30070242/29938481

3. Run opatch command to check if enough free space is available in the Database Home

$ORACLE_HOME/OPatch/opatch prereq CheckSystemSpace -phBaseFile /tmp/patch_list_dbhome.txt

4. opatch auto

opatchauto apply /u01/app/oracle/source/30070242 -oh /u01/app/oracle/product/12.1.0.2_EBS/dbhome_1

5. datapatch 

$ORACLE_HOME/OPatch/datapatch -verbose


file patch nya sudah di taruk di sini "/u01/app/oracle/source"

