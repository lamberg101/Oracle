sshpass -p 'oracle' ssh -o ServerAliveInterval=30 10.59.88.20 -l oracle

step:
======

set lines 300 pages 1000
col machine for a40
col username for a35
col osuser for a35
col SERVICE_NAME for a30
 SELECT INST_ID,machine,username,SERVICE_NAME,
        NVL(active_count, 0) AS active,
        NVL(inactive_count, 0) AS inactive,
        NVL(killed_count, 0) AS killed 
 FROM   ( SELECT INST_ID,machine, status,username,SERVICE_NAME, count(*) AS quantity
          FROM   gv$session where username is not null
          GROUP BY INST_ID,machine, status,username,SERVICE_NAME)
 PIVOT  (SUM(quantity) AS count FOR (status) IN ('ACTIVE' AS active, 'INACTIVE' AS inactive, 'KILLED' AS killed))
 ORDER BY machine,username;


set lines 300 pages 1000
col machine for a40
col username for a35
col osuser for a35
col SERVICE_NAME for a30
 SELECT INST_ID,machine,username,SERVICE_NAME,
        NVL(active_count, 0) AS active,
        NVL(inactive_count, 0) AS inactive,
        NVL(killed_count, 0) AS killed 
 FROM   ( SELECT INST_ID,machine, status,username,SERVICE_NAME, count(*) AS quantity
          FROM   gv$session where username is not null
          GROUP BY INST_ID,machine, status,username,SERVICE_NAME)
 PIVOT  (SUM(quantity) AS count FOR (status) IN ('ACTIVE' AS active, 'INACTIVE' AS inactive, 'KILLED' AS killed))
 where SERVICE_NAME = 'ODSCVDG'
 ORDER BY machine,username;


matiin node 1 exacm
--------------------
srvctl status database -d ODBIC
date; srvctl stop instance -db ODBIC -i ODBIC1 -stopoption abort -force; date; srvctl status database -d ODBIC

start node 1 exacm
------------------
srvctl status database -d ODBIC
date; srvctl start instance -d ODBIC -i ODBIC1; date; srvctl status database -d ODBIC

matiin node 2 exacm
-------------------
srvctl status database -d ODBIC
date; srvctl stop instance -d ODBIC -i ODBIC2 -stopoption abort -force; date; srvctl status database -d ODBIC

start node 2 exacm
-----------------
srvctl status database -d ODBIC
date; srvctl start instance -d ODBIC -i ODBIC2; date; srvctl status database -d ODBIC

switchover to brn
-----------------
dgmgrl sys/oracle
show configuration;
show database ODSCV;
validate database ODSCV;

SQL> alter system switch all logfile; 3x

switchover to ODSCV;


matiin node 1 BRN
--------------------
srvctl status database -d ODSCV
date; srvctl stop instance -db ODSCV -i ODSCV1 -stopoption abort -force; date; srvctl status database -d ODSCV

start node 1 BRN
------------------
srvctl status database -d ODSCV
date; srvctl start instance -d ODSCV -i ODSCV1; date; srvctl status database -d ODSCV

matiin node 2 BRN
-------------------
srvctl status database -d ODSCV
date; srvctl stop instance -d ODSCV -i ODSCV2 -stopoption abort -force; date; srvctl status database -d ODSCV

start node 2 BRN
-----------------
srvctl status database -d ODSCV
date; srvctl start instance -d ODSCV -i ODSCV2; date; srvctl status database -d ODSCV



switchback to exacm
---------------------
dgmgrl sys/oracle
show configuration;
show database ODBIC;
validate database ODBIC;

SQL> alter system switch all logfile; 3x

switchover to ODBIC;


failover to brn
----------------
dgmgrl sys/oracle
show configuration;
show database ODBIC;
validate database ODBIC;

SQL> alter system switch all logfile; 3x

failover to ODBIC;

kalo cara abort (running di exacm)
----------------
srvctl status database -d ODBIC
date; srvctl stop database -d ODBIC -stopoption abort -force; date; srvctl status database -d ODBIC


reinstate exacm (running di exacm)
----------------
srvctl status database -d ODBIC
date; srvctl start database -d ODBIC ; date; srvctl status database -d ODBIC


failover to exacm
-------------------
dgmgrl sys/oracle
show configuration;
show database ODSCV;
validate database ODSCV;

SQL> alter system switch all logfile; 3x

failover to ODSCV;

kalo cara abort (running di exacm)
----------------
srvctl status database -d ODSCV
date; srvctl stop database -d ODSCV -stopoption abort -force; date; srvctl status database -d ODSCV


reinstate brn (running di exacm)
----------------
srvctl status database -d ODSCV
date; srvctl start database -d ODSCV ; date; srvctl status database -d ODBIC

