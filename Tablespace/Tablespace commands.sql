#Creating	
SQL> create tablespace test datafile 'c:\oracle\test.dbf' size 2G;
SQL> create tablespace test datafile 'c:\oracle\test.dbf' size 2G extent management local uniform size 1M maxsize unlimited;
SQL> create bigfile tablespace test datafile 'c:\oracle\bigfile.dbf' 2G;


#Creating non-standard block size	
Note: if the block is different than db_block_size then make sure to set a db_nk_cache_size 

SQL> alter system db_16k_cache_size = 5M; 
SQL> create tablespace test datafile 'c:\oracle\test.dbf' size 2G blocksize 16K;


#Removing	
SQL> drop tablespace test;
SQL> drop tablespace test including contents and datafiles; (removes the contents and the physical data files)


#Modifying	
SQL> alter tablespace test rename to test99;
SQL> alter tablespace test [offline|online];
SQL> alter tablespace test [read only|read write];
SQL> alter tablespace test [begin backup | end backup];

Note: use v$backup to see tablespace is in backup mode (see below)


#Adding data files	
SQL> alter tablespace test add datafile 'c:\oracle\test02.dbf' 2G;


#Dropping data files	
SQL> alter tablespace test drop datafile 'c:\oracle\test02.dbf';


Autoextending	See Datafile commands


#Rename a data file	>> offline the tablespace then rename at O/S level, then peform below 
SQL> alter tablespace test rename datafile 'c:\oracle\test.dbf' to 'c:\oracle\test99.dbf';


#Tablespace management	
SQL> create tablespace test datafile 'c:\oracle\test.dbf' size 2G extent management manual;


#Extent management	
SQL> create tablespace test datafile 'c:\oracle\test.dbf' size 2G uniform size 1M maxsize unlimited;


#Segment Space management	
SQL> create tablespace test datafile 'c:\oracle\test.dbf' size 2G segment space management manual;


#Display default tablespace	
SQL> select property_value from database_properties where property_name = 'DEFAULT_PERMANENT_TABLESPACE';


#Set default tablespace	
SQL> alter database default tablespace users;


#Display default tablespace type	
SQL> select property_value from database_properties where property_name = 'DEFAULT_TBS_TYPE';


#Set default tablespace type	
SQL> alter database set default bigfile tablespace;
SQL> alter database set default smallfile tablespace;


#Get properties of an existing tablespace	

set long 1000000 
select DBMS_METADATA.GET_DDL('TABLESPACE','USERS') from dual;


#Ceck Free Space	
select tablespace_name, round(sum(bytes/1024/1024),1) "FREE MB" from dba_free_space group by tablespace_name;


#Display backup mode	
select tablespace_name, b.status from dba_data_files a, v$backup b where a.file_id = b.file#;