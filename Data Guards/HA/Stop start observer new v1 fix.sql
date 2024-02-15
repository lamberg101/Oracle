step stop observer:
----------------
10.49.132.75 (oam)
10.59.102.207 (service)

[oracle@dgbsdpdb1 ~]$ ps -ef |grep dgmgrl
oracle    18462      1  0 Jun29 ?        19:10:33 /apps/oracle/product/18.1.0.0/db1/bin/dgmgrl -logfile /apps/dataguard/log/c2podd.log            START OBSERVER obbsdc2podd FILE IS '/apps/dataguard/c2podd.fsfo' TRACE_LEVEL IS 'SUPPORT' 
oracle    20469  18034  0 11:13 pts/3    00:00:00 grep --color=auto dgmgrl
oracle    21170      1  0 Aug25 ?        01:15:51 /apps/oracle/product/12.1.0.2/db1/bin/dgmgrl -logfile /apps/dataguard/log/OPRFSOD.log                               start observer file='/apps/dataguard/OPRFSOD.fsfo'
oracle    48460      1  0 Oct21 ?        00:24:00 /apps/oracle/product/12.1.0.2/db1/bin/dgmgrl -logfile /apps/dataguard/log/OPPOMTBS.log                             start observer file='/apps/dataguard/OPPOMTBS.fsfo'
oracle    66424      1  0 Jul08 ?        03:11:44 /apps/oracle/product/12.1.0.2/db1/bin/dgmgrl -logfile /apps/dataguard/log/OPRFSEV2.log                            start observer file='/apps/dataguard/OPRFSEV2.fsfo'
oracle    84721      1  0 Nov15 ?        00:23:22 /apps/oracle/product/19.0.0/client_1/bin/dgmgrl -logfile /apps/dataguard/log/OPDGPOS19.log             START OBSERVER obbsddgpos FILE IS '/home/oracle/fsfo.dat' TRACE_LEVEL IS 'SUPPORT' 
oracle    93334      1  0 Nov17 ?        00:00:23 /apps/oracle/product/12.1.0.2/db1/bin/dgmgrl -logfile /apps/dataguard/log/OPSVCTBS.log                             start observer file='/apps/dataguard/OPSCVTBS.fsfo'
oracle    95882      1  0 Jun07 ?        22:18:34 /apps/oracle/product/18.1.0.0/db1/bin/dgmgrl -logfile /apps/dataguard/log/c2pevn.log            START OBSERVER obbsdc2pevn FILE IS '/apps/dataguard/c2pevn.fsfo' TRACE_LEVEL IS 'SUPPORT' 
oracle   120316      1  0 May27 ?        00:36:43 dgmgrl -logfile /apps/dataguard/log/OPRFSODNEW.log                               start observer  file='/apps/dataguard/OPRFSODNEW.fsfo'


stop observer OPC2PODD:
-----------------------
[oracle@dgbsdpdb1 ~]$ dgmgrl sys/xxxxx@OPC2PODD
DGMGRL > stop OBSERVER obbsdc2podd;

stop observer OPC2PEVN:
-----------------------
[oracle@dgbsdpdb1 ~]$ dgmgrl sys/xxxxx@OPC2PEVN
DGMGRL > stop OBSERVER obbsdc2pevn;


stop observer OPRFSOD:
-----------------------
[oracle@dgbsdpdb1 ~]$ . .12_profile
[oracle@dgbsdpdb1 ~]$ dgmgrl sys/xxxxx@OPRFSODBSD
DGMGRL > stop OBSERVER;


stop observer OPRFSEV:
-----------------------
[oracle@dgbsdpdb1 ~]$ . .12_profile
[oracle@dgbsdpdb1 ~]$ dgmgrl sys/xxxxx@OPRFSEV
DGMGRL > stop OBSERVER;


stop observer OPDGPOS19:
-----------------------
[oracle@dgbsdpdb1 ~]$ . .profile_19
[oracle@dgbsdpdb1 ~]$ dgmgrl sys/xxxxx@OPDGPOS19
DGMGRL > show observer;
Setting masterobsever to server tbs (temporary)
DGMGRL > set masterobserver to obtbsdgpos;
DGMGRL > show observer;
DGMGRL > stop OBSERVER obbsddgpos;



START OBSERVER:

Chek status
untuk versi 18 dan 19
DGMGRL >show observer; 
untuk versi 12
DGMGRL >show configuration verbose; 
==============
start observer OPC2PODD:
-----------------------
[oracle@dgbsdpdb1 ~]$ dgmgrl sys/xxxxx@OPC2PODD
DGMGRL > start observer obbsdc2podd in background file is '/apps/dataguard/c2podd.fsfo' logfile is '/apps/dataguard/log/c2podd.log' connect identifier is OPC2PODD trace_level is support

start observer OPC2PEVN:
-----------------------
[oracle@dgbsdpdb1 ~]$ dgmgrl sys/xxxxx@OPC2PEVN
DGMGRL > start observer obbsdc2pevn in background file is '/apps/dataguard/c2pevn.fsfo' logfile is '/apps/dataguard/log/c2pevn.log' connect identifier is OPC2PEVN trace_level is support


start observer OPRFSOD:
-----------------------
[oracle@dgbsdpdb1 ~]$ . .12_profile
nohup /apps/oracle/product/12.1.0.2/db1/bin/dgmgrl -logfile /apps/dataguard/log/OPRFSOD.log sys/xxxxx@OPRFSODBSD "start observer file='/apps/dataguard/OPRFSOD.fsfo'" &

start observer OPPOMTBS:
-----------------------
[oracle@dgbsdpdb1 ~]$ . .12_profile
nohup /apps/oracle/product/12.1.0.2/db1/bin/dgmgrl -logfile /apps/dataguard/log/OPPOMTBS.log sys/xxxxx@OPPOMTBS "start observer file='/apps/dataguard/OPPOMTBS.fsfo'" &

start observer OPRFSEV:
-----------------------
[oracle@dgbsdpdb1 ~]$ . .12_profile
nohup /apps/oracle/product/12.1.0.2/db1/bin/dgmgrl -logfile /apps/dataguard/log/OPRFSEV2.log sys/xxxxx@OPRFSEV "start observer file='/apps/dataguard/OPRFSEV2.fsfo'" &

start observer OPSCVTBS:
-----------------------
[oracle@dgbsdpdb1 ~]$ . .12_profile
nohup /apps/oracle/product/12.1.0.2/db1/bin/dgmgrl -logfile /apps/dataguard/log/OPSVCTBS.log sys/xxxxx@OPSCVTBS "start observer file='/apps/dataguard/OPSCVTBS.fsfo'" &

start observer OPDGPOS19:
-----------------------
[oracle@dgbsdpdb1 ~]$ . .profile_19
[oracle@dgbsdpdb1 ~]$ dgmgrl sys/xxxxx@OPDGPOS19
DGMGRL > start observer obbsddgpos in background file is '/apps/dataguard/dgpos.fsfo' logfile is '/apps/dataguard/log/OPDGPOS19.log' connect identifier is OPDGPOS19 trace_level is support
DGMGRL >show observer;
Make sure master on server bsd
DGMGRL > set masterobserver to obbsddgpos;
DGMGRL >show observer;




xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


step stop observer:
----------------
10.49.10.197 (oam)
10.38.18.66 (service)

[oracle@dgtbspdb1 ~]$ ps -ef |grep dgmgrl
oracle    75780      1  0 Jun07 ?        1-00:02:40 /apps/oracle/product/18.1.0.0/db1/bin/dgmgrl -logfile /apps/dataguard/log/c2pevn.log               START OBSERVER obtbsc2pevn FILE IS '/apps/dataguard/c2pevn.fsfo' TRACE_LEVEL IS 'SUPPORT' 
oracle   101987 101321  0 11:32 pts/2    00:00:00 grep --color=auto dgmgrl
oracle   111583      1  0 Jun29 ?        20:34:09 /apps/oracle/product/18.1.0.0/db1/bin/dgmgrl -logfile /apps/dataguard/log/c2podd.log               START OBSERVER obtbsc2podd FILE IS '/apps/dataguard/c2podd.fsfo' TRACE_LEVEL IS 'SUPPORT' 
oracle   119534      1  0 Nov15 ?        00:25:08 /apps/oracle/product/19.0.0/client_1/bin/dgmgrl -logfile /apps/dataguard/log/OPDGPOSTBS.log              START OBSERVER obtbsdgpos FILE IS '/home/oracle/fsfo.dat' TRACE_LEVEL IS 'SUPPORT' 


stop observer OPC2PODD:
-----------------------
[oracle@dgtbspdb1 ~]$ dgmgrl sys/xxxxx@OPC2PODD
DGMGRL > show observer; 
DGMGRL > set masterobserver to obbsdc2podd;
DGMGRL > stop OBSERVER obtbsc2podd;

stop observer OPC2PEVN:
-----------------------
[oracle@dgtbspdb1 ~]$ dgmgrl sys/xxxxx@OPC2PEVN
DGMGRL > show observer; 
DGMGRL > set masterobserver to obbsdc2pevn;
DGMGRL > stop OBSERVER obtbsc2pevn;

stop observer OPDGPOS19:
-----------------------
[oracle@dgtbspdb1 ~]$ . .profile_19
[oracle@dgtbspdb1 ~]$ dgmgrl sys/xxxxx@OPDGPOS19
DGMGRL > stop OBSERVER obtbsdgpos;


START OBSERVER:
show observer;
==============
start observer OPC2PODD:
-----------------------
[oracle@dgtbspdb1 ~]$ dgmgrl sys/xxxxx@OPC2PODD
DGMGRL > start observer obtbsc2podd in background logfile is '/apps/dataguard/log/c2podd.log' connect identifier is OPC2PODD trace_level is support

DGMGRL > set masterobserver to obtbsc2podd


start observer OPC2PEVN:
-----------------------
[oracle@dgtbspdb1 ~]$ dgmgrl sys/xxxxx@OPC2PEVN
DGMGRL > start observer obtbsc2pevn in background FILE IS '/apps/dataguard/c2pevn.fsfo' logfile is '/apps/dataguard/log/c2pevn.log ' connect identifier is OPC2PEVN trace_level is support
DGMGRL > set masterobserver to obtbsc2pevn

start observer OPDGPOS19:
-----------------------
[oracle@dgtbspdb1 ~]$ . .19_profile
[oracle@dgtbspdb1 ~]$ dgmgrl sys/xxxxx@OPDGPOS19
DGMGRL > start observer obtbsdgpos in background logfile is '/apps/dataguard/log/OPDGPOSTBS.log' connect identifier is OPDGPOSTBS trace_level is support
