Create recovery catalog user:
Example: 
target database DB_PROD
recovery database DB_REC


--ON DB_REC: create catalog user
$sqlplus / as sysdba
SQL> create user recovery_user identified by recovery_pass;
SQL> grant connect, resource, recovery_catalog_owner to recovery_user;

--create catalog tablespace
SQL> create tablespace recovery_tablespace datafile 'path/asm' size 30M;
SQL> alter user recovery_user default tablespace recovery_tablespace;
SQL> alter user recovery_user quota unlimited on recovery_tablespace;
SQL> select table_name from dba_tables where tablespace_name='recovery_tablespace'; --should be empty
SQL> select view_name from dba_views where view_name like 'recovery_%'; --should be empty


--ON TARGET DB_PROD: register database to recovery catalog
$ rman catalog=recovery_user/recovery_pass@db_rec
RMAN> create catalog;


--ON DB_REC: check the contents 
$sqlplus / as sysdba
SQL> select table_name from dba_tables where tablespace_name='recovery_tablespace'; --some tables have been created
SQL> select view_name from dba_views where view_name like 'recovery_%'; --some views have been created
SQL> select text from dba_views where view_name='recovery_something??'
--example: select site_key, db_key, database_role from node
SQL> select table_name, tablespace_name from dba_tables where table_name='node'; --the tablespace would be recovery_tablespace


---------------------------------------------------------------------------------------------------------------------------------------


REGISTER DATABASE to RECOVERY CATALOG.

--ON DB_PROD: connect to TARGET database and as CATALOG database
$ rman target / catalog=recovery_user/recovery_pass@db_rec
--register database
RMAN> register database;


--ON DB_REC: Check the databaase target
$sqlplus / as sysdba
SQL> desc recovery_user.rec_database;
NAME		NULL	TYPE
----------- -------- --------
DB_KEY		NOT NULL 	NUMBER
DB_ID		NOT NULL 	NUMBER
NAME		NOT NULL 	NUMBER
DBINC_KEY	NOT NULL 	NUMBER

SQL> select name from recovery_user.rec_databaase; --there's a db name db_prod registered to this catalog.
NAME
------
DB_PROD

SQL> select name from v$database;
NAME
-------
DB_REC


--ON DB_PROD: when backup database connect as both, db will writhe the meta_data to conrtilfile of both
$ rman target / catalog=recovery_user/recovery_pass@db_rec
RMAN> backup database;


---------------------------------------------------------------------------------------------------------------------------------------

UNREGISTER database from RECOVERY CATALOG

--ON DB_PROD: connect as both
$ rman target / catalog=recovery_user/recovery_pass@db_rec
RMAN> list backup; --Check all the backup


--ON DB_REC: login as recovery_user
$ sqlplus
username: recovery_user
password: recovery_pass

SQL> show user
user is "recovery_user"

SQL> select name from rec_databaase; --rec_databaase is a supposedly table that points to db_prod
NAME
-----
DB_PROD

SQL> select count(bs_key) from rec_backup_piece; --rec_backup_piece is supposedly available and points to db_prod
count(bs_key)
------------
12


--ON DB_PROD: connect as both and unregister
$ rman target / catalog=recovery_user/recovery_pass@db_rec
RMAN> unregister database;


--ON DB_REC: login as recovery_user
$ sqlplus
username: recovery_user
password: recovery_pass

SQL> show user
user is "recovery_user"

SQL> select name from rec_databaase; --rec_databaase is a supposedly table that points to db_prod
no row selected

SQL> select count(bs_key) from rec_backup_piece; --rec_backup_piece is supposedly available and points to db_prod
no row selected



--ON DB_PROD: connect as both and RE-REGISTER it
$ rman target / catalog=recovery_user/recovery_pass@db_rec
RMAN> register database;


#CASE: Cannot unregister becase cannot connect to Target database 
--ON DB_REC: login as recovery_user
$ sqlplus
username: recovery_user
password: recovery_pass

SQL> show user
user is "recovery_user"
SQL> select name from rec_databaase; --rec_databaase is a supposedly table that points to db_prod
NAME
-----
DB_PROD

SQL> select db_key, dbid from rec_databaase; --rec_databaase is a supposedly table that points to db_prod
DB_KEY 		DBID
-----------	----------------
1601		2382320032428

SQL> execute dbms_rcvcat.unregisterdatabase(1601,2382320032428);
PL/SQL procedure successuflly compelted.

SQL> select name from rec_databaase; --rec_databaase is a supposedly table that points to db_prod
no row selected









