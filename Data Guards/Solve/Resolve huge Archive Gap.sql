Resolve huge archive gap between PRIMARY and STANDBY
A Physical Standby database synchs with Primary by continuous apply of archive logs from a Primary Database.
When the logs are missing on standby difference is huge (say more than 500 logs), you have to rebuild the standby database from scratch.

----------------------------------------------------------------------------------------------------

1. Please use below query to find out archive gap on Standby:
Select 
Arch.Thread# "Thread", 
Arch.Sequence# "Last Sequence Received", 
Appl.Sequence# "Last Sequence Applied", 
(Arch.Sequence# – Appl.Sequence#) "Difference" 
From (Select Thread# ,Sequence# 
	From V$Archived_Log 
	Where (Thread#,First_Time ) In (Select Thread#,Max(First_Time) 
	From V$Archived_Log Group By Thread#)) Arch, 
	(Select Thread# ,Sequence# 
	From V$Log_History 
	Where (Thread#,First_Time ) In (Select Thread#,Max(First_Time) 
	From V$Log_History 
Group By Thread#)) Appl 
Where Arch.Thread# = Appl.Thread# 
Order By 1;
 
 
Thread        Last Sequence Received      Last Sequence Applied     Difference
------------- --------------------------- ------------------------- ------------
1             8254                        7954                    	300
 

2. Find the SCN on the PRIMARY:

SQL> select current_scn from v$database;
 
CURRENT_SCN
———–  
242671761


3. Find the SCN on the STANDBY:

SQL> select current_scn from v$database;

CURRENT_SCN
———–  
223771173


4. Clearly you can see there is difference

Stop and shutdown the managed standby apply process:

SQL> alter database recover managed standby database cancel;

Database altered.

Shutdown the standby database

SQL> shut immediate

On the primary, take an incremental backup from the SCN number where the standby current value 223771173:

 RMAN> run { allocate channel c1 type disk format ‘/backup/%U.bkp’;
backup incremental from scn 223771173 database;
 }
On the primary, create a new standby controlfile:

SQL> alter database create standby controlfile as ‘/backup/for_standby.ctl’;

Database altered.

Copy the standby controlfile to STANDBY and bring up the standby instance in nomount status with standby controlfile:

SQL> startup nomount

SQL> alter database mount standby database;

Connect to RMAN on STANDBY, Catalog backup files to RMAN using below commands:

$ rman target=/

RMAN> catalog start with ‘/backup’;

PERFORM RECOVER:

RMAN> recover database;

Start managed recovery process:

SQL> alter database recover managed standby database disconnect from session;

Database altered.

Check the SCN’s in primary and standby it should be close to each other.