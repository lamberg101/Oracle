http://ural00005.blogspot.com/2018/06/how-to-restart-oracle-zdlra-services.html?m=1

Keterangan :
-----------
IP address :
10.54.128.23
10.54.128.24

username : root
password : Welcome1

GRID_HOME = /u01/app/12.1.0.2/grid
AGENT_HOME = /u01/app/oracle/product/emagent/core/12.1.0.4.0 



1. Log in as oracle to either Recovery Appliance compute server.
$ ssh 10.54.128.24 -l root
$ ssh 10.54.128.23 -l root

2. Open a SQL connection to Oracle Database as the rasys user:
$ sqlplus rasys/ra

password nya "ra"

3. Check the status of the services:
SQL > SELECT state FROM ra_server;

STATE
----------
ON

4. Shut down Recovery Appliance services
SQL > exec dbms_ra.shutdown; 

5. Disconnect from Oracle Database:

SQL> exit

6. Check the current status of Oracle Secure Backup:

# /u01/app/12.1.0.2/grid/bin/crsctl status res osbadmin

7. Check the status of the Oracle Database File System (DBFS) mounts:

$ /u01/app/12.1.0.2/grid/bin/crsctl status res ob_dbfs rep_dbfs

if the status online must be stop

$ /u01/app/12.1.0.2/grid/bin/crsctl stop res ob_dbfs rep_dbfs

8. Verify that the DBFS mounts are offline:

$ /u01/app/12.1.0.2/grid/bin/crsctl status res ob_dbfs rep_dbfs

9. Check the status of Oracle Database and stop database :

$ srvctl status database -d RABSDP

$ srvctl stop database -d RABSDP

10. Stop the Oracle Clusterware stack on all nodes in the cluster:

# /u01/app/12.1.0.2/grid/bin/crsctl stop cluster -all

11. stop agent oem on all nodes :

$ /u01/app/oracle/product/emagent/core/12.1.0.4.0/bin/emctl stop agent



step by step startup zdlra
---------------------------


1. Log in as oracle to either Recovery Appliance compute server.
$ ssh 10.54.128.24 -l root
$ ssh 10.54.128.23 -l root


2. Confirm that Oracle Cluster Ready Services (CRS) is running:

# /u01/app/12.1.0.2/grid/bin/crsctl status server 

NAME=zdlrabsdpdb1-mgt
STATE=ONLINE

NAME=zdlrabsdpdb2-mgt
STATE=ONLINE

or 

# /u01/app/12.1.0.2/grid/bin/crsctl check crs

If CRS is not running, then start it:

# /u01/app/12.1.0.2/grid/bin/crsctl start cluster -all


3. Start Oracle Database:

$ srvctl start database -d RABSDP

Confirm that Oracle Database is running:

$ srvctl status database -d RABSDP

4. Verify that the Database File System (DBFS) mounts are online:

$ /u01/app/12.1.0.2/grid/bin/crsctl status res ob_dbfs rep_dbfs

NAME=ob_dbfs
TYPE=local_resource
TARGET=ONLINE                    , ONLINE
STATE=ONLINE on zdlrabsdpdb1-mgt, ONLINE on zdlrabsdpdb2-mgt

NAME=rep_dbfs
TYPE=local_resource
TARGET=ONLINE                    , ONLINE
STATE=ONLINE on zdlrabsdpdb1-mgt, ONLINE on zdlrabsdpdb2-mgt
  
If DBFS is offline, then start it:

$ /u01/app/12.1.0.2/grid/bin/crsctl start res ob_dbfs rep_dbfs


5. Connect to Oracle Database as the RASYS user:

$ sqlplus rasys/ra 

6. Check the status of Recovery Appliance services:

SQL> SELECT state FROM ra_server;
 
STATE
------------
OFF

If the services are off, then start them:

SQL> exec dbms_ra.startup;

Confirm that the services are started:

SQL> /
 
STATE
------------
ON

7. start agent oem on all nodes :

$ /u01/app/oracle/product/emagent/core/12.1.0.4.0/bin/emctl start agent


================================================================================================================

--dibawag ini nanti cocokan dengan yang diatas

Lamberg Nicholas, [14.02.20 00:52]
[Forwarded from Fatur Rohman]
step by step startup zdlra
---------------------------


1. Log in as oracle to either Recovery Appliance compute server.
$ ssh 10.251.33.109 -l root
$ ssh 10.251.33.109 -l root


2. Confirm that Oracle Cluster Ready Services (CRS) is running:

# /u01/app/12.1.0.2/grid/bin/crsctl status server 

NAME=zdlrabsdpdb1-mgt
STATE=ONLINE

NAME=zdlrabsdpdb2-mgt
STATE=ONLINE

or 

# /u01/app/12.1.0.2/grid/bin/crsctl check crs

If CRS is not running, then start it:

# /u01/app/12.1.0.2/grid/bin/crsctl start cluster -all


3. Start Oracle Database:

$ srvctl start database -d RABSDP

Confirm that Oracle Database is running:

$ srvctl status database -d RABSDP

4. Verify that the Database File System (DBFS) mounts are online:

$ /u01/app/12.1.0.2/grid/bin/crsctl status res ob_dbfs rep_dbfs

NAME=ob_dbfs
TYPE=local_resource
TARGET=ONLINE                    , ONLINE
STATE=ONLINE on zdlrabsdpdb1-mgt, ONLINE on zdlrabsdpdb2-mgt

NAME=rep_dbfs
TYPE=local_resource
TARGET=ONLINE                    , ONLINE
STATE=ONLINE on zdlrabsdpdb1-mgt, ONLINE on zdlrabsdpdb2-mgt
  
If DBFS is offline, then start it:

$ /u01/app/12.1.0.2/grid/bin/crsctl start res ob_dbfs rep_dbfs


5. Connect to Oracle Database as the RASYS user:

$ sqlplus rasys/ra 

6. Check the status of Recovery Appliance services:

SQL> SELECT state FROM ra_server;
 
STATE
------------
OFF

If the services are off, then start them:

SQL> exec dbms_ra.startup;

Confirm that the services are started:

SQL> /
 
STATE
------------
ON

7. start agent oem on all nodes :

$ /u01/app/oracle/product/emagent/core/12.1.0.4.0/bin/emctl start agent