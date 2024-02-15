Clone Oracle Home
link: https://houseofbrick.com/cloning-an-oracle-home/
or https://docs.oracle.com/database/121/LADBI/app_cloning.htm#LADBI7852
-------------------------------------------------------------------------------------

1. Make sure the Oracle home you are using has all necessary patches installed.

2. Stop all processes in the Oracle home to be cloned. Typically, this will be the Oracle database process and the listener. 
Once they are stopped, use the fuser command to identify any remaining processes, fuser –v –c /u01/app/oracle/product/12.1.0.2/dbhome_1. 
The output will be similar to below:

USER       PID ACCESS COMMAND
/u01/app/oracle/product/12.1.0/dbhome_1:
root     kernel mount /
oracle     3381 .r.e. bash
oracle     3731 Fr.e. tnslsnr
 
If there are any processes listed, which correspond to the Oracle database (e.g. tnslsnr) kill them.


3. Create a zip or tar file containing the Oracle home, but not the Oracle base. Exclude any files you do not want to carry over using the –x option, for example:
zip -r dbhome_1.zip /u01/app/oracle/product/12.1.0/dbhome_1 -x 
"/u01/app/oracle/product/12.1.0/dbhome_1/network/admin/listener.ora" 
"/u01/app/oracle/product/12.1.0/dbhome_1/network/admin/tnsnames.ora"
"/u01/app/oracle/product/12.1.0/dbhome_1/oradata/*"


4. At this point, you will have a file named dbhome_1.zip (in this case) that contains a good Oracle home directory.


5. Copy this file to your new server, and make sure all the required Oracle prerequisites are installed. 
If you are installing on Oracle Enterprise Linux, you can ensure this by installing the Oracle preinstall package for your current Oracle version 
(e.g.. oracle-rdbms-server-12cR1-preinstall). 
If using Red Hat Enterprise Linux or other versions, review this Oracle Metalink document for the required packages: note 1587357.1.


6. Create the top-level directory and change the ownership to oracle, e.g. mkdir –p /u01, chown oracle:oinstall /u01.


7. Unzip the file using the –d option to create the entire directory tree: unzip –d / dbhome_1.zip. 
This will recreate a directory structure identical to the old structure on your new server.


8. In order to reduce the chance of typos and to save typing, set the ORACLE_HOME environment variable to your new Oracle home, 
e.g. export ORACLE_HOME=/u01/app/oracle/product/12.1.0/dbhome_1


9. Move to the /u01/app/oracle/product/12.1.0/dbhome_1/clone/bin directory and run the clone command to install and register the new Oracle home. 
The syntax of the command is:

$ORACLE_HOME/perl/bin/perl $ORACLE_HOME/clone/bin/clone.pl 
ORACLE_BASE="target_oracle_base" ORACLE_HOME="target_oracle_home"
OSDBA_GROUP=OSDBA_privileged_group OSOPER_GROUP=OSOPER_privileged_group
 –defaultHomeName


10. Below is the command used and the output:
set profile
$> vi .12_1_profile 
export ORACLE_BASE=/home/oracle
export ORACLE_HOME=$ORACLE_BASE/product/12.1/12.1.0/dbhome_10
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/jdk/jre/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib


$> ./runInstaller -silent -clone ORACLE_HOME="/home/oracle/product/12.1/12.1.0/dbhome_10/" ORACLE_HOME_NAME="db_121" ORACLE_BASE="/home/oracle/"


11. At this point, you have successfully cloned your Oracle home. The next step is to copy your old database over to the new home on your brand new server.





