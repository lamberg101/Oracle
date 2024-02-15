1. Check before
select count(*) from dba_data_files;
select value from v$parameter where name = 'db_files';

2. Backup spfile
create pfile='/data/oradata01/pfile_EBSSAP_20191117.txt' from spfile;

3. Alter
ALTER SYSTEM SET db_files=2000 scope=spfile;

4. restart
SHUTDOWN IMMEDIATE;
STARTUP;


