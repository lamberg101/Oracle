
** SET DATABASE to ARCHIVELOG MODE **

--Check current status
SQL> archive log list
Database log mode No Archive Mode
Archive destination /oradata/oracle/ts/arc

----------------------------------------------------------------

--to actvivate
SQL> shutdown immediate
SQL> startup mount
SQL> alter database archivelog;
SQL> alter database open;

----------------------------------------------------------------

--Crosscheck
SQL> archive log list
Database log mode Archive Mode
Archive destination /oradata/oracle/ts/arc

======================================================================================================================

** CHANGE DB_RECOVERY_FILE DEST **

--Check config sekarang
SQL> show parameter db_recovery_file;

--ganti db_recovery_file_dest ke RECO5
SQL> alter system set db_recovery_file_dest='+RECOC5' scope=both sid='*';

----------------------------------------------------------------------------------------------------------------------

** CHANGE DB RECOVERY FILE DEST SIZE **

--Check config sekarang
SQL> show parameter  db_recovery_file_dest;

--ganti db_recovery_file_dest ke RECO5
SQL> ALTER SYSTEM SET DB_RECOVERY_FILE_DEST_SIZE = 3000G scope=both sid='*';

