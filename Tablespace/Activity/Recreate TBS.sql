1. Collect All objects pada tablespace USERS
SQL> Check object dari dba_objects.


2. Check unsuable index. 
select index_owner,index_name,partition_name, tablespace_name,status from dba_ind_partitions where status ='UNUSABLE';
select index_name,index_type,tablespace_name,status, index_type from dba_indexes where status='UNUSABLE';
select index_owner, index_name, partition_name, subpartition_name, tablespace_name from dba_ind_subpartitions where  status = 'UNUSABLE';


3. Collect All objects default attributs
?

4. Check Default Atribute 
select DEF_TABLESPACE_NAME, count(DEF_TABLESPACE_NAME) from dba_part_indexes group by DEF_TABLESPACE_NAME;
select DEF_TABLESPACE_NAME, count(DEF_TABLESPACE_NAME) from dba_part_tables group by DEF_TABLESPACE_NAME;


5. Collect all user yang Default Tablespace nya tbs USERS 
SQL> Check dari tbs users. 


=================================================================================================================================

1. Create New Tablespace
CREATE TABLESPACE USERS2 DATAFILE '+DATAIMC' SIZE 100M AUTOEXTEND ON NEXT 100M MAXSIZE 30G;

2. Moving Object USERS to USERS2
#Table
select 'ALTER TABLE '||owner||'.'||table_name||' MOVE TABLESPACE USERS2;' 
from dba_tables 
where tablespace_name='USERS';

#Index
select 'alter index '||owner||'.'||index_name||' rebuild tablespace USERS2;' 
from dba_indexes 
where tablespace_name='USERS';

#LOB
select 'ALTER TABLE '||owner||'.'||table_name||' MOVE LOB ('||COLUMN_NAME||') store as '||SEGMENT_NAME||' (tablespace USERS2);' 
from dba_lobs 
where tablespace_name='USERS';


3. Check kembali --pastikan semua object yang ada pada tablespaces USERS/lama sudah 0.
select owner, count(owner) from dba_lobs where tablespace_name='USERS' group by owner;
select owner, count(owner) from dba_segments where tablespace_name='USERS' group by owner;
select owner, count(owner) from dba_tables where tablespace_name='USERS' group by owner;
select owner, count(owner) from dba_indexes where tablespace_name='USERS' group by owner;
select owner, count(owner) from dba_tab_partitions where tablespace_name='USERS' group by owner;
select owner, count(owner) from dba_ind_partitions where tablespace_name='USERS' group by owner;


4. Assign all user yg masih default tbs USERS ke USERS2
select 'ALTER USER '||username||' DEFAULT TABLESPACE USERS2;' 
from dba_users 
where DEFAULT_TABLESPACE='USERS';

5. Rename tbs USERS to USERSOLD
SQL> ALTER TABLESPACE USERS RENAME TO USERSOLD;

6. Offline tablespace USERSOLD
SQL> ALTER TABLESPACE USERSOLD OFFLINE;

7. Rename USERS2 to USERS
SQL> ALTER TABLESPACE USERS2 RENAME TO USERS;

8. Drop tablespace USERSOLD --wait one week.
SQL> DROP TABLESPACE USERSOLD INCLUDING CONTENTS AND DATAFILES;

