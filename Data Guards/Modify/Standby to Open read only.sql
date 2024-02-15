Standby OPPOMBSD to open read only

1 Stop MRP 
SQL> alter database recover managed standby database cancel;

2 change open mode database standby to  Open read only
--open ready only  node 1
SQL> alter database open read only;

--open read only node 2
SQL> alter database open read only;

3. Start MRP
SQL> alter database recover managed standby database using current logfile disconnect from session;

4. alter system switch log file
SQL> alter system switch logfile; 5kali