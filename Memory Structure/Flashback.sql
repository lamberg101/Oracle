alter system set undo_retention=86400 scope=both sid='*';
ALTER SYSTEM SET DB_FLASHBACK_RETENTION_TARGET=33120 scope=both sid='*';
alter database flashback on;


select name,open_mode,log_mode,flashback_on from v$database;
alter database flashback off;


create restore point :
CREATE RESTORE POINT RESTORE_03072019 GUARANTEE FLASHBACK DATABASE;