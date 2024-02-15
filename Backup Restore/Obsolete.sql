** Expired vs Obsolete Backups **

1. Expired backups (no longer exists on the OS level) 
	RMAN> crosscheck backup; 
	RMAN> delete expired backup;

2. Obsolete backups (no longer used or required) 
	RMAN> report obsolete; 
	RMAN> delete obsolete;

3. Check Config 		: RMAN> SHOW ALL
4. Check Archive log 	: RMAN> LIST ARCHIVELOG ALL;
5. Check List backup 	: RMAN> list backup of database;


----------------------------------------------------------------------------------------------------------------------------------------------------------

** REDUNDANCY vs RECOVERY WINDOW **

Configure a retention policy:
	RMAN> CONFIGURE RETENTION POLICY TO RECOVERY WINDOW;
	RMAN> CONFIGURE RETENTION POLICY TO REDUNDANCY;
	RMAN> CONFIGURE RETENTION POLICY TO NONE;

1. Recovery Window 
	RMAN> CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 7 DAYS; --> SYSDATE - BACKUP CHECKPOINT TIME >=  7

2. Backup Redundancy 
	RMAN> CONFIGURE RETENTION POLICY TO REDUNDANCY 2;

3. Default 
	RMAN> CONFIGURE RETENTION POLICY TO NONE;


Note! 
If you configure the retention policy to NONE, thens RMAN does not consider any backups as obsolete. 
Consequently, RMAN issues an error when you run REPORT OBSOLETE without any other options and the retention policy is set to NONE.

-----------------------------------------------------------------------------------------------------------------------------------------------

3. Exempting Backups from the Retention Policy

# Creates a backup and exempts it from retention policy until last day of 2007
BACKUP DATABASE KEEP UNTIL TIME TO_DATE('31-DEC-2007' 'dd-mon-yyyy') NOLOGS;

# Specifies that backupset 2 is no longer exempt from the retention policy
CHANGE BACKUPSET 2 NOKEEP;

# Creates a backup that is indefinitely exempt from the retention policy
BACKUP TABLESPACE users KEEP FOREVER NOLOGS;




LINK:
http://vishwanath-dbahelp.blogspot.com/2011/08/difference-between-redundancy-and.html
https://web.stanford.edu/dept/itss/docs/oracle/10gR2/backup.102/b14191/rcmconc1007.htm
