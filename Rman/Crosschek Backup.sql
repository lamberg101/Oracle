RMAN CROSSCHECK COMMAND 
--the crosscheck statement compares backup files on disk with entries in the catalog or controlfile.
--If a file is found in the catalog, but does not exist on disk it is marked as "EXPIRED".

RMAN> CROSSCHECK BACKUP; --to list any expired backups detected by the crosscheck command use:

RMAN> LIST EXPIRED BACKUP; --to delete any expired backups detected by the crosscheck command use:

RMAN> DELETE EXPIRED BACKUP; --to crosscheck all archive logs use:

RMAN> CROSSCHECK ARCHIVELOG ALL; --to list all expired archive logs detected by the crosscheck command use:

RMAN> LIST EXPIRED ARCHIVELOG ALL; --to delete all expired archive logs detected by the crosscheck command use:

RMAN> DELETE EXPIRED ARCHIVELOG ALL; --to crosscheck all datafile image copies use:

RMAN> CROSSCHECK DATAFILECOPY ALL; --to list expired datafile copies use:

RMAN> LIST EXPIRED DATAFILECOPY ALL; --to delete expired datafile copies use:

RMAN> DELETE EXPIRED DATAFILECOPY ALL; --to crosscheck all backups of the users tablespace use:

RMAN> CROSSCHECK BACKUP OF TABLESPACE USERS; --to list expired backups of the users tablespace:

RMAN> LIST EXPIRED BACKUP OF TABLESPACE USERS; --to delete expired backups of the users tablespace:

RMAN> DELETE EXPIRED BACKUP OF TABLESPACE USERS;