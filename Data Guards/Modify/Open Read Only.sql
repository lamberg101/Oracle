1. Check gap
--pake script Check gap

2. Main Steps
A. Stop MRP on DB Standby
SQL> alter database recover managed standby database cancel;

B. Change Open Mode Standby Database to Open Read Only
On node 1
SQL>alter database open read only;
On node 2
SQL>alter database open read only;

C. Start MRP on DB Standby
SQL> alter database recover managed standby database using current logfile disconnect from session;


3. Cross-check 
Cross-check tablespaces and Health check Database.


